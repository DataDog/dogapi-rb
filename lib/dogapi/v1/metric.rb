require 'dogapi'

module Dogapi
  class V1 # for namespacing

    # Event-specific client affording more granular control than the simple Dogapi::Client
    class MetricService < Dogapi::APIService

      API_VERSION = "v1"

      # Records an Event with no duration
      def submit(metric, points, scope, options={})
        params = {
          :api_key => @api_key
        }
        type = options[:type] || "gauge"

        body = { :series => [
            {
              :metric => metric,
              :points => points,
              :type => type,
              :host => scope.host,
              :device => scope.device
            }
          ]
        }
        #puts 'POSTING ' + body.inspect
        request(Net::HTTP::Post, '/api/' + API_VERSION + '/series', params, body, true)
      end
    end

  end
end
