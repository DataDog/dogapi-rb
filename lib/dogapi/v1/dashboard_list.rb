require 'dogapi'

module Dogapi
  class V1 # for namespacing

    # Dashboard List API
    class DashboardListService < Dogapi::APIService

      API_VERSION = 'v1'

      def create_dashboard_list(name)
        body = {
          name: name
        }

        request(Net::HTTP::Post, "/api/#{API_VERSION}/dashboard/lists/manual", nil, body, true)
      end

      def update_dashboard_list(dashboard_list_id, name)
        body = {
          name: name
        }

        request(Net::HTTP::Put, "/api/#{API_VERSION}/dashboard/lists/manual/#{dashboard_list_id}", nil, body, true)
      end

      def get_dashboard_list(dashboard_list_id)
        request(Net::HTTP::Get, "/api/#{API_VERSION}/dashboard/lists/manual/#{dashboard_list_id}", nil, nil, false)
      end

      def all_dashboard_lists
        request(Net::HTTP::Get, "/api/#{API_VERSION}/dashboard/lists/manual", nil, nil, false)
      end

      def delete_dashboard_list(dashboard_list_id)
        request(Net::HTTP::Delete, "/api/#{API_VERSION}/dashboard/lists/manual/#{dashboard_list_id}", nil, nil, false)
      end

      def get_dashboards_for_dashboard_list(dashboard_list_id)
        request(
          Net::HTTP::Get,
          "/api/#{API_VERSION}/dashboard/lists/manual/#{dashboard_list_id}/dashboards",
          nil,
          nil,
          false
        )
      end

      def add_dashboards_to_dashboard_list(dashboard_list_id, dashboards)
        body = {
          dashboards: dashboards
        }

        request(
          Net::HTTP::Post,
          "/api/#{API_VERSION}/dashboard/lists/manual/#{dashboard_list_id}/dashboards",
          nil,
          body,
          true
        )
      end

      def update_dashboards_of_dashboard_list(dashboard_list_id, dashboards)
        body = {
          dashboards: dashboards
        }

        request(
          Net::HTTP::Put,
          "/api/#{API_VERSION}/dashboard/lists/manual/#{dashboard_list_id}/dashboards",
          nil,
          body,
          true
        )
      end

      def delete_dashboards_from_dashboard_list(dashboard_list_id, dashboards)
        body = {
          dashboards: dashboards
        }

        request(
          Net::HTTP::Delete,
          "/api/#{API_VERSION}/dashboard/lists/manual/#{dashboard_list_id}/dashboards",
          nil,
          body,
          true
        )
      end

    end

  end
end
