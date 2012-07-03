require 'dogapi'

module Dogapi
  class V1 # for namespacing

    # Event-specific client affording more granular control than the simple Dogapi::Client
    class MetricService < Dogapi::APIService

      API_VERSION = "v1"

      # Records an Event with no duration
      def submit(metric, points, scope, options={})
        begin
          params = {
            :api_key => @api_key
          }
          typ = options[:type] || "gauge"

          if typ != "gauge" && typ == "counter"
            raise ArgumentError, "metric type must be gauge or counter"
          end

          body = { :series => [
              {
                :metric => metric,
                :points => points,
                :type => typ,
                :host => scope.host,
                :device => scope.device
              }
            ]
          }


          # Add tags if there are any
          if not options[:tags].nil?
            body[:series][0][:tags] = options[:tags]
          end

          request(Net::HTTP::Post, '/api/' + API_VERSION + '/series', params, body, true)
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
