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

    class UsageService < Dogapi::APIService

      API_VERSION = 'v1'

      # Retrieve hourly host usage information
      #
      # :start_hr => String: Datetime ISO-8601 UTC YYYY-MM-DDThh, for usage beginning at this hour
      # :end_hr => String: Datetime ISO-8601 UTC YYYY-MM-DDThh, default start_hr+1d, for usage ending BEFORE this hour
      def get_hosts_usage(start_hr, end_hr = nil)
        params = {
          start_hr: start_hr
        }

        params['end_hr'] = end_hr if end_hr

        request(Net::HTTP::Get, "/api/#{API_VERSION}/usage/hosts", params, nil, false)
      end

      # Retrieve hourly logs usage information
      #
      # :start_hr => String: Datetime ISO-8601 UTC YYYY-MM-DDThh, for usage beginning at this hour
      # :end_hr => String: Datetime ISO-8601 UTC YYYY-MM-DDThh, default start_hr+1d, for usage ending BEFORE this hour
      def get_logs_usage(start_hr, end_hr = nil)
        params = {
          start_hr: start_hr
        }

        params['end_hr'] = end_hr if end_hr

        request(Net::HTTP::Get, "/api/#{API_VERSION}/usage/logs", params, nil, false)
      end

      # Retrieve hourly custom metrics usage information
      #
      # :start_hr => String: Datetime ISO-8601 UTC YYYY-MM-DDThh, for usage beginning at this hour
      # :end_hr => String: Datetime ISO-8601 UTC YYYY-MM-DDThh, default start_hr+1d, for usage ending BEFORE this hour
      def get_custom_metrics_usage(start_hr, end_hr = nil)
        params = {
          start_hr: start_hr
        }

        params['end_hr'] = end_hr if end_hr

        request(Net::HTTP::Get, "/api/#{API_VERSION}/usage/timeseries", params, nil, false)
      end

      # Retrieve hourly trace search usage information
      #
      # :start_hr => String: Datetime ISO-8601 UTC YYYY-MM-DDThh, for usage beginning at this hour
      # :end_hr => String: Datetime ISO-8601 UTC YYYY-MM-DDThh, default start_hr+1d, for usage ending BEFORE this hour
      def get_traces_usage(start_hr, end_hr = nil)
        params = {
          start_hr: start_hr
        }

        params['end_hr'] = end_hr if end_hr

        request(Net::HTTP::Get, "/api/#{API_VERSION}/usage/traces", params, nil, false)
      end

      # Retrieve hourly synthetics usage information
      #
      # :start_hr => String: Datetime ISO-8601 UTC YYYY-MM-DDThh, for usage beginning at this hour
      # :end_hr => String: Datetime ISO-8601 UTC YYYY-MM-DDThh, default start_hr+1d, for usage ending BEFORE this hour
      def get_synthetics_usage(start_hr, end_hr = nil)
        params = {
          start_hr: start_hr
        }

        params['end_hr'] = end_hr if end_hr

        request(Net::HTTP::Get, "/api/#{API_VERSION}/usage/synthetics", params, nil, false)
      end

      # Retrieve hourly fargate usage information
      #
      # :start_hr => String: Datetime ISO-8601 UTC YYYY-MM-DDThh, for usage beginning at this hour
      # :end_hr => String: Datetime ISO-8601 UTC YYYY-MM-DDThh, default start_hr+1d, for usage ending BEFORE this hour
      def get_fargate_usage(start_hr, end_hr = nil)
        params = {
          start_hr: start_hr
        }

        params['end_hr'] = end_hr if end_hr

        request(Net::HTTP::Get, "/api/#{API_VERSION}/usage/fargate", params, nil, false)
      end
    end
  end
end
