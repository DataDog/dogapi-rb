# Unless explicitly stated otherwise all files in this repository are licensed under the BSD-3-Clause License.
# This product includes software developed at Datadog (https://www.datadoghq.com/).
# Copyright 2011-Present Datadog, Inc.

module Dogapi
  class V1 # for namespacing

    # Event-specific client affording more granular control than the simple Dogapi::Client
    class MetricService < Dogapi::APIService

      API_VERSION = 'v1'

      def get(query, from, to)
        extra_params = {
          from: from.to_i,
          to: to.to_i,
          query: query
        }
        request(Net::HTTP::Get, '/api/' + API_VERSION + '/query', extra_params, nil, false)
      end

      def upload(metrics)
        body = {
          :series => metrics
        }
        request(Net::HTTP::Post, '/api/' + API_VERSION + '/series', nil, body, true, false)
      end

      def submit_to_api(metric, points, scope, options= {})
        payload = self.make_metric_payload(metric, points, scope, options)
        self.upload([payload])
      end

      def submit_to_buffer(metric, points, scope, options= {})
        payload = self.make_metric_payload(metric, points, scope, options)
        @buffer << payload
        return 200, {}
      end

      def flush_buffer()
        payload = @buffer
        @buffer = nil
        self.upload(payload)
      end

      def submit(*args)
        if @buffer
          submit_to_buffer(*args)
        else
          submit_to_api(*args)
        end
      end

      def switch_to_batched()
        @buffer = Array.new
      end

      def switch_to_single()
        @buffer = nil
      end

      def make_metric_payload(metric, points, scope, options)
        begin
          typ = options[:type] || 'gauge'

          if typ != 'gauge' && typ != 'counter' && typ != 'count' && typ != 'rate'
            raise ArgumentError, 'metric type must be gauge or counter or count or rate'
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
          suppress_error_if_silent e
        end
      end

      def get_active_metrics(from)
        params = {
          from: from.to_i
        }

        request(Net::HTTP::Get, '/api/' + API_VERSION + '/metrics', params, nil, false)
      end
    end
  end
end
