# Unless explicitly stated otherwise all files in this repository are licensed under the BSD-3-Clause License.
# This product includes software developed at Datadog (https://www.datadoghq.com/).
# Copyright 2011-Present Datadog, Inc.

module Dogapi
  class V1 # for namespacing

    class SearchService < Dogapi::APIService

      API_VERSION = 'v1'

      def search(query)
        # Deprecating search for hosts
        split_query = query.split(':')
        if split_query.length > 1 && split_query[0] == 'hosts'
          warn '[DEPRECATION] Dogapi::V1::SearchService::search has been '\
            'deprecated for hosts in favor of Dogapi::V1::HostsService::search'
        end

        extra_params = {
          :q => query
        }

        request(Net::HTTP::Get, "/api/#{API_VERSION}/search", extra_params, nil, false)
      end

    end

  end
end
