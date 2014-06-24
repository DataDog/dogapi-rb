require 'dogapi'

module Dogapi
  class V1 # for namespacing

    # Event-specific client affording more granular control than the simple Dogapi::Client
    class MetricService < Dogapi::APIService

      API_VERSION = "v1"

      def upload(metrics)
        begin
          params = {
            :api_key => @api_key
          }
          body = {
            :series => metrics
          }
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

      def submit_to_api(metric, points, scope, options = {})
        payload = self.make_metric_payload(metric, points, scope, options)
        self.upload([payload])
      end

      def submit_to_buffer(metric, points, scope, options = {})
        payload = self.make_metric_payload(metric, points, scope, options)
        @buffer << payload
      end

      def flush_buffer()
        self.upload(@buffer)
        @buffer = nil
      end

      alias :submit :submit_to_api

      def switch_to_batched()
        alias :submit :submit_to_buffer
        @buffer = Array.new
      end

      def switch_to_single()
        @buffer = nil
        alias :submit :submit_to_api
      end

      def make_metric_payload(metric, points, scope, options)
        begin
          typ = options[:type] || "gauge"

          if typ != "gauge" && typ != "counter"
            raise ArgumentError, "metric type must be gauge or counter"
          end

          metric_payload = {
            :metric => metric,
            :points => points,
            :type => typ,
            :host => scope.host,
            :device => scope.device
          }

          # Add tags if there are any
          if not options[:tags].nil?
            metric_payload[:tags] = options[:tags]
          end

          return metric_payload
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
