# Unless explicitly stated otherwise all files in this repository are licensed under the BSD-3-Clause License.
# This product includes software developed at Datadog (https://www.datadoghq.com/).
# Copyright 2011-Present Datadog, Inc.

module Dogapi
  class V1 # for namespacing

    class DashService < Dogapi::APIService

      API_VERSION = 'v1'

      def create_dashboard(title, description, graphs, template_variables = nil, read_only = false)
        body = {
          :title => title,
          :description => description,
          :graphs => graphs,
          :template_variables => (template_variables or []),
          :read_only => read_only
        }

        request(Net::HTTP::Post, "/api/#{API_VERSION}/dash", nil, body, true)
      end

      def update_dashboard(dash_id, title, description, graphs, template_variables = nil, read_only = false)
        body = {
          :title => title,
          :description => description,
          :graphs => graphs,
          :template_variables => (template_variables or []),
          :read_only => read_only
        }

        request(Net::HTTP::Put, "/api/#{API_VERSION}/dash/#{dash_id}", nil, body, true)
      end

      def get_dashboard(dash_id)
        request(Net::HTTP::Get, "/api/#{API_VERSION}/dash/#{dash_id}", nil, nil, false)
      end

      def get_dashboards
        request(Net::HTTP::Get, "/api/#{API_VERSION}/dash", nil, nil, false)
      end

      def delete_dashboard(dash_id)
        request(Net::HTTP::Delete, "/api/#{API_VERSION}/dash/#{dash_id}", nil, nil, false)
      end

    end

  end
end
