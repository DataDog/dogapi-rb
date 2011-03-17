require 'cgi'
require 'net/http'
require 'pp'
require 'socket'
require 'uri'

require 'rubygems'
require 'json'

module Dogapi

  def Dogapi.find_datadog_host
    ENV['DATADOG_HOST'] rescue nil
  end

  def Dogapi.find_api_key
    ENV['DATADOG_KEY'] rescue nil
  end

  def Dogapi.find_localhost
    Socket.gethostname
  end

  class Scope
    attr_reader :host, :device
    def initialize(host=nil, device=nil)
      @host = host
      @device = device
    end
  end

  class Service
    def initialize(api_host=find_datadog_host)
      @host = api_host
    end

    def connect(api_key=nil, host=nil)

      @api_key = api_key
      host = host || @host

      uri = URI.parse(host)
      Net::HTTP.start(uri.host, uri.port) do |conn|
        if 'https' == uri.scheme
          conn.use_ssl = true
        end
        yield(conn)
      end
    end

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
          params[:series] = JSON.parse(params[:series])
          request_string = params.pretty_inspect
          error_string = resp_obj['error']
          raise "Failed request\n#{request_string}#{error_string}"
        end
      end
      resp_obj
    end
  end
end
