require 'dogapi'

module Dogapi
  class V1 # for namespacing

    # Event-specific client affording more granular control than the simple Dogapi::Client
    class EventService < Dogapi::APIService

      API_VERSION = "v1"
      MAX_BODY_LENGTH = 4000
      MAX_TITLE_LENGTH = 100

      # Records an Event with no duration
      def post(event, scope=nil)
        begin
          scope = scope || Dogapi::Scope.new()
          body = event.to_hash.merge({
            :title => event.msg_title[0..MAX_TITLE_LENGTH - 1],
            :text => event.msg_text[0..MAX_BODY_LENGTH - 1],
            :date_happened => event.date_happened.to_i,
            :host => scope.host,
            :device => scope.device,
            :aggregation_key => event.aggregation_key.to_s
          })

          request(Net::HTTP::Post, '/api/v1/events', false, nil, body, true)
        rescue Exception => e
          suppress_error_if_silent e
        end
      end

      def get(id)
        begin
          request(Net::HTTP::Get, '/api/' + API_VERSION + '/events/' + id.to_s, true, nil, nil, false)
        rescue Exception => e
          suppress_error_if_silent e
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

          extra_params = {
            :start => start.to_i,
            :end => stop.to_i
          }

          if options[:priority]
            extra_params[:priority] = options[:priority]
          end
          if options[:sources]
            extra_params[:sources] = options[:sources]
          end
          if options[:tags]
            tags = options[:tags]
            extra_params[:tags] = tags.kind_of?(Array) ? tags.join(",") : tags
          end

          request(Net::HTTP::Get, '/api/' + API_VERSION + '/events', true, extra_params, nil, false)
        rescue Exception => e
          suppress_error_if_silent e
        end
      end

    end

  end
end
