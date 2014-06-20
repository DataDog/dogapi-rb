require 'cgi'
require 'net/https'
require 'pp'
require 'socket'
require 'uri'

require 'rubygems'
require 'json'

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
      warn "[DEPRECATION] Dogapi::Service has been deprecated in favor of the newer V1 services"
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
      warn "[DEPRECATION] Dogapi::Service has been deprecated in favor of the newer V1 services"
      if !params.has_key? :api_key
        params[:api_key] = @api_key
      end

      resp_obj = nil
      connect do |conn|
        req = method.new(url)
        req.set_form_data params
        resp = conn.request(req)
        begin
          resp_obj = JSON.parse(resp.body)
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
    def initialize(api_key, application_key, silent=true, timeout=nil)
      @api_key = api_key
      @application_key = application_key
      @api_host = Dogapi.find_datadog_host()
      @silent = silent
      @timeout = timeout || 5
    end

    # Manages the HTTP connection
    def connect
      connection = Net::HTTP

      # After ruby 2.0 Net::HTTP looks for the env variable but not ruby 1.9
      if RUBY_VERSION < "2.0.0"
        proxy = ENV["HTTPS_PROXY"] || ENV["https_proxy"] || ENV["HTTP_PROXY"] || ENV["http_proxy"]
        if proxy
          proxy_uri = URI.parse(proxy)
          connection = Net::HTTP::Proxy(proxy_uri.host, proxy_uri.port, proxy_uri.user, proxy_uri.password)
        end
      end

      uri = URI.parse(@api_host)
      session = connection.new(uri.host, uri.port)
      session.use_ssl = uri.scheme == 'https'
      session.start do |conn|
        conn.read_timeout = @timeout
        yield(conn)
      end
    end

    def suppress_error_if_silent(e)
      if @silent
        warn e
        return -1, {}
      else
        raise e
      end
    end

    # Prepares the request and handles the response
    #
    # +method+ is an implementation of Net::HTTP::Request (e.g. Net::HTTP::Post)
    #
    # +params+ is a Hash that will be converted to request parameters
    def request(method, url, params, body, send_json)
      resp_obj = nil
      resp = nil
      connect do |conn|
        if params and params.size > 0
          qs_params = params.map { |k, v| k.to_s + "=" + v.to_s }
          qs = "?" + qs_params.join("&")
          url = url + qs
        end

        req = method.new(url)

        if send_json
          req.content_type = 'application/json'
          req.body = JSON.generate(body)
        end

        resp = conn.request(req)
        resp_str = resp.body

        if resp.code != 204 and resp.body != '' and resp.body != 'null' and resp.body != nil
          begin
            resp_obj = JSON.parse(resp.body)
          rescue
            raise 'Invalid JSON Response: ' + resp.body
          end
        else
          resp_obj = {}
        end
      end
      return resp.code, resp_obj
    end
  end

  def Dogapi.find_datadog_host
    # allow env-based overriding, useful for tests
    ENV["DATADOG_HOST"] || "https://app.datadoghq.com"
  end

  # Memoize the hostname as a module variable
  @@hostname = nil

  def Dogapi.find_localhost
    begin
      # prefer hostname -f over Socket.gethostname
      @@hostname ||= %x[hostname -f].strip
    rescue
      raise "Cannot determine local hostname via hostname -f"
    end
  end

end
