require 'dogapi'

module Dogapi
  class V1 # for namespacing

    # Event-specific client affording more granular control than the simple Dogapi::Client
    class EventService < Dogapi::APIService

      API_VERSION = "v1"

      # Records an Event with no duration
      def post(event, scope=nil)
        scope = scope || Dogapi::Scope.new()
        params = {
          :api_key => @api_key
        }

        body = {
          :title => event.msg_title,
          :text => event.msg_text,
          :date_happened => event.date_happened.to_i,
          :priority => event.priority,
          :parent => event.parent,
          :tags => event.tags,
          :host => scope.host,
          :device => scope.device
        }

        request(Net::HTTP::Post, '/api/v1/events', params, body, true)
      end

      def get(id)
        params = {
          :api_key => @api_key,
          :application_key => @application_key
        }

        request(Net::HTTP::Get, '/api/' + API_VERSION + '/events/' + id.to_s, params, nil, false)
      end

      def stream(start, stop, options={})
        defaults = {
          :priority => nil,
          :sources => nil,
          :tags => nil
        }
        options = defaults.merge(options)

        params = {
          :api_key => @api_key,
          :application_key => @application_key,

          :start => start.to_i,
          :end => stop.to_i
        }

        if options[:priority].nil?
          params[:priority] = options[:priority]
        end
        if options[:sources].nil?
          params[:sources] = options[:sources]
        end
        if options[:tags].nil?
          params[:tags] = options[:tags]
        end

        request(Net::HTTP::Get, '/api/' + API_VERSION + '/events', params, nil, false)
      end

    end

  end
end
