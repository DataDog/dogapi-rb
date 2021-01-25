# Unless explicitly stated otherwise all files in this repository are licensed under the BSD-3-Clause License.
# This product includes software developed at Datadog (https://www.datadoghq.com/).
# Copyright 2011-Present Datadog, Inc.

module Dogapi
  class V1 # for namespacing

    # Hosts API
    class HostsService < Dogapi::APIService

      API_VERSION = 'v1'

      def search(options = {})
        request(Net::HTTP::Get, "/api/#{API_VERSION}/hosts", options, nil, true)
      end

      def totals
        request(Net::HTTP::Get, "/api/#{API_VERSION}/hosts/totals", nil, nil, true)
      end
    end

  end
end
