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

  # Superclass that deals with the details of communicating with the DataDog API
  class Service
    def initialize(api_key, api_host=Dogapi.find_datadog_host)
      @api_key = api_key
      @host = api_host
    end

    # Manages the HTTP connection
    def connect
      uri = URI.parse(@host)
      session = Net::HTTP.new(uri.host, uri.port)
      if 'https' == uri.scheme
        session.use_ssl = true
        # FIXME - turn off SSL verification for now until we can spend
        # some time figuring out how to find certs across platforms.
        # - matt 10/06/2011
        session.verify_mode = OpenSSL::SSL::VERIFY_NONE
      end
      session.start do |conn|
        yield(conn)
      end
    end

    # Prepares the request and handles the response
    #
    # +method+ is an implementation of Net::HTTP::Request (e.g. Net::HTTP::Post)
    #
    # +params+ is a Hash that will be converted to request parameters
    def request(method, url, params)
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

  class APIService
    def initialize(api_key, application_key)
      @api_key = api_key
      @application_key = application_key
      @api_host = Dogapi.find_datadog_host()
    end

    # Manages the HTTP connection
    def connect
      uri = URI.parse(@api_host)
      session = Net::HTTP.new(uri.host, uri.port)
      if 'https' == uri.scheme
        session.use_ssl = true
        # FIXME - turn off SSL verification for now until we can spend
        # some time figuring out how to find certs across platforms.
        # - matt 10/06/2011
        session.verify_mode = OpenSSL::SSL::VERIFY_NONE
      end
      session.start do |conn|
        yield(conn)
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
          qs_params = params.map { |k,v| k.to_s + "=" + v.to_s }
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

        if resp.code != '204'
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

  def Dogapi.find_localhost
    Socket.gethostname
  end
end
