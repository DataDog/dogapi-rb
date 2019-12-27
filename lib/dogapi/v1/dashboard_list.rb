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

    # Dashboard List API
    class DashboardListService < Dogapi::APIService

      API_VERSION = 'v1'
      RESOURCE_NAME = 'dashboard/lists/manual'
      SUB_RESOURCE_NAME = 'dashboards'

      def create(name)
        body = {
          name: name
        }

        request(Net::HTTP::Post, "/api/#{API_VERSION}/#{RESOURCE_NAME}", nil, body, true)
      end

      def update(resource_id, name)
        body = {
          name: name
        }

        request(Net::HTTP::Put, "/api/#{API_VERSION}/#{RESOURCE_NAME}/#{resource_id}", nil, body, true)
      end

      def get(resource_id)
        request(Net::HTTP::Get, "/api/#{API_VERSION}/#{RESOURCE_NAME}/#{resource_id}", nil, nil, false)
      end

      def all
        request(Net::HTTP::Get, "/api/#{API_VERSION}/#{RESOURCE_NAME}", nil, nil, false)
      end

      def delete(resource_id)
        request(Net::HTTP::Delete, "/api/#{API_VERSION}/#{RESOURCE_NAME}/#{resource_id}", nil, nil, false)
      end

      def get_items(resource_id)
        request(
          Net::HTTP::Get,
          "/api/#{API_VERSION}/#{RESOURCE_NAME}/#{resource_id}/#{SUB_RESOURCE_NAME}",
          nil,
          nil,
          false
        )
      end

      def add_items(resource_id, dashboards)
        body = {
          dashboards: dashboards
        }

        request(
          Net::HTTP::Post,
          "/api/#{API_VERSION}/#{RESOURCE_NAME}/#{resource_id}/#{SUB_RESOURCE_NAME}",
          nil,
          body,
          true
        )
      end

      def update_items(resource_id, dashboards)
        body = {
          dashboards: dashboards
        }

        request(
          Net::HTTP::Put,
          "/api/#{API_VERSION}/#{RESOURCE_NAME}/#{resource_id}/#{SUB_RESOURCE_NAME}",
          nil,
          body,
          true
        )
      end

      def delete_items(resource_id, dashboards)
        body = {
          dashboards: dashboards
        }

        request(
          Net::HTTP::Delete,
          "/api/#{API_VERSION}/#{RESOURCE_NAME}/#{resource_id}/#{SUB_RESOURCE_NAME}",
          nil,
          body,
          true
        )
      end

    end

  end
end
