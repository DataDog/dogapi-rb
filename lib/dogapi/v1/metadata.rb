# Unless explicitly stated otherwise all files in this repository are licensed under the BSD-3-Clause License.
# This product includes software developed at Datadog (https://www.datadoghq.com/).
# Copyright 2011-Present Datadog, Inc.

module Dogapi
  class V1

    class MetadataService < Dogapi::APIService

      API_VERSION = 'v1'

      def get(metric_name)
        request(Net::HTTP::Get, "/api/#{API_VERSION}/metrics/#{metric_name}", nil, nil, false)
      end

      def update(metric_name, options = {})
        request(Net::HTTP::Put, "/api/#{API_VERSION}/metrics/#{metric_name}", nil, options, true)
      end
    end

  end
end
