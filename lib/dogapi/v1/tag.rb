# Unless explicitly stated otherwise all files in this repository are licensed under the BSD-3-Clause License.
# This product includes software developed at Datadog (https://www.datadoghq.com/).
# Copyright 2011-Present Datadog, Inc.

module Dogapi
  class V1 # for namespacing

    #
    class TagService < Dogapi::APIService

      API_VERSION = 'v1'

      # Gets all tags in your org and the hosts tagged with them
      def get_all(source=nil)
        extra_params = {}
        if source
          extra_params['source'] = source
        end

        request(Net::HTTP::Get, '/api/' + API_VERSION + '/tags/hosts', extra_params, nil, false)
      end

      # Gets all tags for a given host
      def get(host_id, source=nil, by_source=false)
        extra_params = {}
        if source
          extra_params['source'] = source
        end
        if by_source
          extra_params['by_source'] = 'true'
        end

        request(Net::HTTP::Get, '/api/' + API_VERSION + '/tags/hosts/' + host_id.to_s, extra_params, nil, false)
      end

      # Adds a list of tags to a host
      def add(host_id, tags, source=nil)
        extra_params = {}
        if source
          extra_params['source'] = source
        end

        body = {
          :tags => tags
        }

        request(Net::HTTP::Post, '/api/' + API_VERSION + '/tags/hosts/' + host_id.to_s, extra_params, body, true)
      end

      # Remove all tags from a host and replace them with a new list
      def update(host_id, tags, source=nil)
        extra_params = {}
        if source
          extra_params['source'] = source
        end

        body = {
          :tags => tags
        }

        request(Net::HTTP::Put, '/api/' + API_VERSION + '/tags/hosts/' + host_id.to_s, extra_params, body, true)
      end

      # <b>DEPRECATED:</b> Spelling mistake temporarily preserved as an alias.
      def detatch(host_id)
        warn '[DEPRECATION] Dogapi::V1::TagService.detatch() is deprecated. Use `detach` instead.'
        detach(host_id)
      end

      # Remove all tags from a host
      def detach(host_id, source=nil)
        extra_params = {}
        if source
          extra_params['source'] = source
        end

        request(Net::HTTP::Delete, '/api/' + API_VERSION + '/tags/hosts/' + host_id.to_s, extra_params, nil, false)
      end

    end

  end
end
