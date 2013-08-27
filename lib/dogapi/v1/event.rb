require 'dogapi'

module Dogapi
  class V1 # for namespacing

    # Event-specific client affording more granular control than the simple Dogapi::Client
    class EventService < Dogapi::APIService

      API_VERSION = "v1"

      # Records an Event with no duration
      def post(event, scope=nil)
        begin
          scope = scope || Dogapi::Scope.new()
          params = {
            :api_key => @api_key
          }

          body = event.to_hash.merge({
            :title => event.msg_title,
            :text => event.msg_text,
            :date_happened => event.date_happened.to_i,
            :host => scope.host,
            :device => scope.device,
            :aggregation_key => event.aggregation_key.to_s
          })

          request(Net::HTTP::Post, '/api/v1/events', params, body, true)
        rescue Exception => e
          if @silent
            warn e
            return -1, {}
          else
            raise e
          end
        end
      end

      def get(id)
        begin
          params = {
            :api_key => @api_key,
            :application_key => @application_key
          }

          request(Net::HTTP::Get, '/api/' + API_VERSION + '/events/' + id.to_s, params, nil, false)
        rescue Exception => e
          if @silent
            warn e
            return -1, {}
          else
            raise e
          end
        end
      end

      def stream(start, stop, options = {})
        begin
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

          if options[:priority]
            params[:priority] = options[:priority]
          end
          if options[:sources]
            params[:sources] = options[:sources]
          end
          if options[:tags]
            tags = options[:tags]
            params[:tags] = tags.kind_of?(Array) ? tags.join(",") : tags
          end

          request(Net::HTTP::Get, '/api/' + API_VERSION + '/events', params, nil, false)
        rescue Exception => e
          if @silent
            warn e
            return -1, {}
          else
            raise e
          end
        end
      end

    end

  end
end
