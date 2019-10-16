require 'cgi'
require 'net/https'
require 'socket'
require 'uri'
require 'English'

require 'rubygems'
require 'multi_json'
require 'set'

module Dogapi

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
    def initialize(api_key, application_key, silent=true, timeout=nil, endpoint=nil)
      @api_key = api_key
      @application_key = application_key
      @api_host = endpoint || Dogapi.find_datadog_host()
      @silent = silent
      @timeout = timeout || 5
    end

    # Manages the HTTP connection
    def connect
      connection = Net::HTTP

      # After ruby 2.0 Net::HTTP looks for the env variable but not ruby 1.9
      if RUBY_VERSION < '2.0.0'
        proxy = ENV['HTTPS_PROXY'] || ENV['https_proxy'] || ENV['HTTP_PROXY'] || ENV['http_proxy']
        if proxy
          proxy_uri = URI.parse(proxy)
          connection = Net::HTTP::Proxy(proxy_uri.host, proxy_uri.port, proxy_uri.user, proxy_uri.password)
        end
      end

      uri = URI.parse(@api_host)
      session = connection.new(uri.host, uri.port)
      session.open_timeout = @timeout
      session.use_ssl = uri.scheme == 'https'
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
          current_url = url + prepare_params(extra_params, url, with_app_key)
          req = method.new(current_url)
          req['DD-API-KEY'] = @api_key
          req['DD-APPLICATION-KEY'] = @application_key if with_app_key

          if send_json
            req.content_type = 'application/json'
            req.body = MultiJson.dump(body)
          end

          resp = conn.request(req)
          return handle_response(resp)
        rescue Exception => e
          suppress_error_if_silent e
        end
      end
    end

    def prepare_params(extra_params, url, with_app_key)
      params = set_api_and_app_keys_in_params(url, with_app_key)
      params = extra_params.merge params unless extra_params.nil?
      qs_params = params.map { |k, v| CGI.escape(k.to_s) + '=' + CGI.escape(v.to_s) }
      qs = '?' + qs_params.join('&')
      qs
    end

    def set_api_and_app_keys_in_params(url, with_app_key)
      set_of_urls = Set.new ['/api/v1/series',
                             '/api/v1/check_run',
                             '/api/v1/events',
                             '/api/v1/screen']

      include_in_params = set_of_urls.include?(url)

      if include_in_params
        params = { api_key: @api_key }
        params[:application_key] = @application_key if with_app_key
      else
        params = {}
      end
      return params
    end

    def handle_response(resp)
      if resp.code == 204 || resp.body == '' || resp.body == 'null' || resp.body.nil?
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
  end

  def Dogapi.find_datadog_host
    # allow env-based overriding, useful for tests
    ENV['DATADOG_HOST'] || 'https://api.datadoghq.com'
  end

  # Memoize the hostname as a module variable
  @@hostname = nil

  def Dogapi.find_localhost
    @@hostname ||= %x[hostname -f].strip
  rescue SystemCallError
    raise $ERROR_INFO unless $ERROR_INFO.class.name == 'Errno::ENOENT'
    @@hostname = Addrinfo.getaddrinfo(Socket.gethostname, nil, nil, nil, nil, Socket::AI_CANONNAME).first.canonname
  end
end
