require 'dogapi'

module Dogapi
  class V1 # for namespacing

    class DashService < Dogapi::APIService

      API_VERSION = "v1"

      def create_dashboard(title, description, graphs, template_variables = nil)

        begin
          params = {
            :api_key => @api_key,
            :application_key => @application_key
          }

          body = {
            :title => title,
            :description => description,
            :graphs => graphs,
            :template_variables => (template_variables or [])
          }

          request(Net::HTTP::Post, "/api/#{API_VERSION}/dash", params, body, true)
        rescue Exception => e
          suppress_error_if_silent e
        end
      end

      def update_dashboard(dash_id, title, description, graphs, template_variables=nil)

        begin
          params = {
            :api_key => @api_key,
            :application_key => @application_key
          }

          body = {
            :title => title,
            :description => description,
            :graphs => graphs,
            :template_variables => (template_variables or [])
          }

          request(Net::HTTP::Put, "/api/#{API_VERSION}/dash/#{dash_id}", params, body, true)
        rescue Exception => e
          suppress_error_if_silent e
        end
      end

      def get_dashboard(dash_id)
        begin
          params = {
            :api_key => @api_key,
            :application_key => @application_key
          }

          request(Net::HTTP::Get, "/api/#{API_VERSION}/dash/#{dash_id}", params, nil, false)
        rescue Exception => e
          suppress_error_if_silent e
        end
      end

      def get_dashboards
        begin
          params = {
            :api_key => @api_key,
            :application_key => @application_key
          }

          request(Net::HTTP::Get, "/api/#{API_VERSION}/dash", params, nil, false)
        rescue Exception => e
          suppress_error_if_silent e
        end
      end

      def delete_dashboard(dash_id)
        begin
          params = {
            :api_key => @api_key,
            :application_key => @application_key
          }

          request(Net::HTTP::Delete, "/api/#{API_VERSION}/dash/#{dash_id}", params, nil, false)
        rescue Exception => e
          suppress_error_if_silent e
        end
      end

    end

  end
end
