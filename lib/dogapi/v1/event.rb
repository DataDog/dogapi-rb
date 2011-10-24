require 'dogapi'

module Dogapi
  class V1 # for namespacing

    # Event-specific client affording more granular control than the simple Dogapi::Client
    class EventService < Dogapi::APIService

      API_VERSION = "v1"

      # Records an Event with no duration
      def submit(event, scope=nil)
        scope = scope || Dogapi::Scope.new()
        params = {
          :api_key => @api_key
        }

        body = {
          :title => event.msg_title,
          :text => event.msg_text,
          :date_happened => event.date_happened,
          :priority => event.priority,
          :parent => event.parent,
          :tags => event.tags,
        }

        request(Net::HTTP::Post, '/api/v1/events', params, body, true)
      end
    end

  end
end
