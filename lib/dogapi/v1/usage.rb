# Unless explicitly stated otherwise all files in this repository are licensed under the BSD-3-Clause License.
# This product includes software developed at Datadog (https://www.datadoghq.com/).
# Copyright 2011-Present Datadog, Inc.

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
