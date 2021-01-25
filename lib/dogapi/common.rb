# Unless explicitly stated otherwise all files in this repository are licensed under the BSD-3-Clause License.
# This product includes software developed at Datadog (https://www.datadoghq.com/).
# Copyright 2011-Present Datadog, Inc.

require 'cgi'
require 'net/https'
require 'rbconfig'
require 'socket'
require 'uri'
require 'English'

require 'rubygems'
require 'multi_json'
require 'set'
require 'open3'

require 'dogapi/version'

module Dogapi
  USER_AGENT = format(
    'dogapi-rb/%<version>s (ruby %<ruver>s; os %<os>s; arch %<arch>s)',
    version: VERSION,
    ruver: RUBY_VERSION,
    os: RbConfig::CONFIG['host_os'].downcase,
    arch: RbConfig::CONFIG['host_cpu']
  )

  # Metadata class to hold the scope of an API call
  class Scope
    attr_reader :host, :device
    def initialize(host=nil, device=nil)
      @host = host
      @device = device
    end
  end

  # <b>DEPRECATED:</b> Going forward, use the newer APIService.
  class Service
    # <b>DEPRECATED:</b> Going forward, use the newer APIService.
    def initialize(api_key, api_host=Dogapi.find_datadog_host)
      @api_key = api_key
      @host = api_host
    end

    # <b>DEPRECATED:</b> Going forward, use the newer APIService.
    def connect
      warn '[DEPRECATION] Dogapi::Service has been deprecated in favor of the newer V1 services'
      uri = URI.parse(@host)
      session = Net::HTTP.new(uri.host, uri.port)
      if 'https' == uri.scheme
        session.use_ssl = true
      end
      session.start do |conn|
        yield(conn)
      end
    end

    # <b>DEPRECATED:</b> Going forward, use the newer APIService.
    def request(method, url, params)
      warn '[DEPRECATION] Dogapi::Service has been deprecated in favor of the newer V1 services'
      if !params.has_key? :api_key
        params[:api_key] = @api_key
      end

      resp_obj = nil
      connect do |conn|
        req = method.new(url)
        req.set_form_data params
        resp = conn.request(req)
        begin
          resp_obj = MultiJson.load(resp.body)
        rescue
          raise 'Invalid JSON Response: ' + resp.body
        end

        if resp_obj.has_key? 'error'
          request_string = params.pretty_inspect
          error_string = resp_obj['error']
          raise "Failed request\n#{request_string}#{error_string}"
        end
      end
      resp_obj
    end
  end

  # Superclass that deals with the details of communicating with the DataDog API
  class APIService
    attr_reader :api_key, :application_key
    def initialize(api_key, application_key, silent=true, timeout=nil, endpoint=nil, skip_ssl_validation=false)
      @api_key = api_key
      @application_key = application_key
      @api_host = endpoint || Dogapi.find_datadog_host()
      @silent = silent
      @skip_ssl_validation = skip_ssl_validation
      @timeout = timeout || 5
    end

    # Manages the HTTP connection
    def connect
      connection = Net::HTTP

      # Expose using a proxy without setting the HTTPS_PROXY or HTTP_PROXY variables
      proxy = Dogapi.find_proxy()

      if proxy
        proxy_uri = URI.parse(proxy)
        connection = Net::HTTP::Proxy(proxy_uri.host, proxy_uri.port, proxy_uri.user, proxy_uri.password)
      end

      uri = URI.parse(@api_host)
      session = connection.new(uri.host, uri.port)
      session.open_timeout = @timeout
      session.use_ssl = uri.scheme == 'https'
      if @skip_ssl_validation
        session.verify_mode = OpenSSL::SSL::VERIFY_NONE
      end
      session.start do |conn|
        conn.read_timeout = @timeout
        yield conn
      end
    end

    def suppress_error_if_silent(e)
      raise e unless @silent

      warn e
      return -1, {}
    end

    # Prepares the request and handles the response
    #
    # +method+ is an implementation of Net::HTTP::Request (e.g. Net::HTTP::Post)
    #
    # +params+ is a Hash that will be converted to request parameters
    def request(method, url, extra_params, body, send_json, with_app_key=true)
      resp = nil
      connect do |conn|
        begin
          params = prepare_params(extra_params, url, with_app_key)
          req = prepare_request(method, url, params, body, send_json, with_app_key)
          resp = conn.request(req)
          if resp.code.to_i / 100 == 3
            resp = handle_redirect(conn, req, resp)
          end
          return handle_response(resp)
        rescue Exception => e
          suppress_error_if_silent e
        end
      end
    end

    def prepare_request(method, url, params, body, send_json, with_app_key)
      url_with_params = url + params
      req = method.new(url_with_params)
      req['User-Agent'] = USER_AGENT
      unless should_set_api_and_app_keys_in_params?(url)
        req['DD-API-KEY'] = @api_key
        req['DD-APPLICATION-KEY'] = @application_key if with_app_key
      end
      if send_json
        req.content_type = 'application/json'
        req.body = MultiJson.dump(body)
      end
      return req
    end

    def prepare_params(extra_params, url, with_app_key)
      if should_set_api_and_app_keys_in_params?(url)
        params = { api_key: @api_key }
        params[:application_key] = @application_key if with_app_key
      else
        params = {}
      end
      params = extra_params.merge params unless extra_params.nil?
      qs_params = params.map { |k, v| CGI.escape(k.to_s) + '=' + CGI.escape(v.to_s) }
      qs = '?' + qs_params.join('&')
      qs
    end

    def should_set_api_and_app_keys_in_params?(url)
      set_of_urls = Set.new ['/api/v1/series', '/api/v1/check_run', '/api/v1/events', '/api/v1/screen']
      return set_of_urls.include?(url)
    end

    def handle_response(resp)
      if resp.code.to_i == 204 || resp.body == '' || resp.body == 'null' || resp.body.nil?
        return resp.code, {}
      end
      begin
        return resp.code, MultiJson.load(resp.body)
      rescue
        is_json = resp.content_type == 'application/json'
        raise "Response Content-Type is not application/json but is #{resp.content_type}: " + resp.body unless is_json
        raise 'Invalid JSON Response: ' + resp.body
      end
    end

    def handle_redirect(conn, req, resp, retries=10)
      req.uri = URI.parse(resp.header['location'])
      new_response = conn.request(req)
      if retries > 1 && new_response.code.to_i / 100 == 3
        new_response = handle_redirect(conn, req, new_response, retries - 1)
      end
      new_response
    end
  end

  def Dogapi.find_datadog_host
    # allow env-based overriding, useful for tests
    ENV['DATADOG_HOST'] || 'https://api.datadoghq.com'
  end

  # Memoize the hostname as a module variable
  @@hostname = nil

  def Dogapi.find_localhost
    return @@hostname if @@hostname
    out, status = Open3.capture2('hostname', '-f', err: File::NULL)
    unless status.exitstatus.zero?
      begin
        out = Addrinfo.getaddrinfo(Socket.gethostname, nil, nil, nil, nil, Socket::AI_CANONNAME).first.canonname
      rescue SocketError
        out, status = Open3.capture2('hostname', err: File::NULL)
        raise SystemCallError, 'Both `hostname` and `hostname -f` failed.' unless status.exitstatus.zero?
      end
    end
    @@hostname = out.strip
  end

  def Dogapi.find_proxy
    ENV['DD_PROXY_HTTPS'] || ENV['dd_proxy_https'] ||
      ENV['DD_PROXY_HTTP'] || ENV['dd_proxy_http'] ||
      ENV['HTTPS_PROXY'] || ENV['https_proxy'] || ENV['HTTP_PROXY'] || ENV['http_proxy']
  end

  def Dogapi.validate_tags(tags)
    unless tags.is_a? Array
      raise ArgumentError, "The tags parameter needs to be an array of string. Current value: #{tags}"
    end
    tags.each do |tag|
      raise ArgumentError, "Each tag needs to be a string. Current value: #{tag}" unless tag.is_a? String
    end
  end

  # Very simplified hash with indifferent access - access to string or symbol
  # keys via symbols. E.g.:
  # my_hash = { 'foo' => 1 }
  # Dogapi.symbolized_access(my_hash)
  # my_hash[:foo] # => 1
  def Dogapi.symbolized_access(hash)
    hash.default_proc = proc { |h, k| h.key?(k.to_s) ? h[k.to_s] : nil }
    hash
  end
end
