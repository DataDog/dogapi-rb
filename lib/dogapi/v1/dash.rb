require 'dogapi'

module Dogapi
  class V1 # for namespacing

    class DashService < Dogapi::APIService

      API_VERSION = "v1"

      def create_dashboard(title, description, graphs, template_variables = nil)
        body = {
          :title => title,
          :description => description,
          :graphs => graphs,
          :template_variables => (template_variables or [])
        }

        request(Net::HTTP::Post, "/api/#{API_VERSION}/dash", nil, body, true)
      end

      def update_dashboard(dash_id, title, description, graphs, template_variables=nil)
        body = {
          :title => title,
          :description => description,
          :graphs => graphs,
          :template_variables => (template_variables or [])
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
