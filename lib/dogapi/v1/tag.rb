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
