# Copyright (c) 2010-2020, Datadog <opensource@datadoghq.com>
#
# Redistribution and use in source and binary forms, with or without modification, are permitted provided that the
# following conditions are met:
#
# 1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following
# disclaimer.
#
# 2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following
# disclaimer in the documentation and/or other materials provided with the distribution.
#
# 3. Neither the name of the copyright holder nor the names of its contributors may be used to endorse or promote
# products derived from this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES,
# INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
# SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
# SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
# WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

require 'dogapi'

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
