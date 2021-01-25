# Unless explicitly stated otherwise all files in this repository are licensed under the BSD-3-Clause License.
# This product includes software developed at Datadog (https://www.datadoghq.com/).
# Copyright 2011-Present Datadog, Inc.

module Dogapi
  class V2 # for namespacing

    # Dashboard List API
    class DashboardListService < Dogapi::APIService

      API_VERSION = 'v2'
      RESOURCE_NAME = 'dashboard/lists/manual'
      SUB_RESOURCE_NAME = 'dashboards'

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
