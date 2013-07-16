require 'dogapi'

module Dogapi
  class V1 # for namespacing

    class ScreenboardService < Dogapi::APIService

      API_VERSION = "v1"

      def create_screenboard(description)

        begin
          params = {
            :api_key => @api_key,
            :application_key => @application_key
          }

          body = description

          request(Net::HTTP::Post, "/api/#{API_VERSION}/screen", params, description, true)
        rescue Exception => e
          suppress_error_if_silent e
        end
      end

      def update_screenboard(board_id, description)

        begin
          params = {
            :api_key => @api_key,
            :application_key => @application_key
          }

          body = description

          request(Net::HTTP::Put, "/api/#{API_VERSION}/screen/#{board_id}", params, body, true)
        rescue Exception => e
          suppress_error_if_silent e
        end
      end

      def get_screenboard(board_id)
        begin
          params = {
            :api_key => @api_key,
            :application_key => @application_key
          }

          request(Net::HTTP::Get, "/api/#{API_VERSION}/screen/#{board_id}", params, nil, false)
        rescue Exception => e
          suppress_error_if_silent e
        end
      end

      def delete_screenboard(board_id)
        begin
          params = {
            :api_key => @api_key,
            :application_key => @application_key
          }

          request(Net::HTTP::Delete, "/api/#{API_VERSION}/screen/#{board_id}", params, nil, false)
        rescue Exception => e
          suppress_error_if_silent e
        end
      end


      def share_screenboard(board_id)
        begin
          params = {
            :api_key => @api_key,
            :application_key => @application_key
          }

          request(Net::HTTP::Get, "/api/#{API_VERSION}/screen/share/#{board_id}", params, nil, false)
        rescue Exception => e
          suppress_error_if_silent e
        end
      end

    end

  end
end
