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
    def initialize(api_host=find_datadog_host)
      @host = api_host
    end

    # Manages the HTTP connection
    def connect(api_key=nil, host=nil)

      @api_key = api_key
      host = host || @host

      uri = URI.parse(host)
      session = Net::HTTP.new(uri.host, uri.port)
      if 'https' == uri.scheme
        session.use_ssl = true
        session.verify_mode = OpenSSL::SSL::VERIFY_PEER
        if File.directory? '/etc/ssl/certs'
          session.ca_path = '/etc/ssl/certs'
        end
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

  private

  def Dogapi.find_datadog_host
    ENV['DATADOG_HOST'] rescue nil
  end

  def Dogapi.find_api_key
    ENV['DATADOG_KEY'] rescue nil
  end

  def Dogapi.find_localhost
    Socket.gethostname
  end
end
