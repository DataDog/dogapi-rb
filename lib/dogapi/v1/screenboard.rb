require 'dogapi'

module Dogapi
  class V1 # for namespacing

    class ScreenboardService < Dogapi::APIService

      API_VERSION = "v1"

      def create_screenboard(description)

        begin
          request(Net::HTTP::Post, "/api/#{API_VERSION}/screen", true, nil, description, true)
        rescue Exception => e
          suppress_error_if_silent e
        end
      end

      def update_screenboard(board_id, description)

        begin
          request(Net::HTTP::Put, "/api/#{API_VERSION}/screen/#{board_id}", true, nil, description, true)
        rescue Exception => e
          suppress_error_if_silent e
        end
      end

      def get_screenboard(board_id)
        begin
          request(Net::HTTP::Get, "/api/#{API_VERSION}/screen/#{board_id}", true, nil, nil, false)
        rescue Exception => e
          suppress_error_if_silent e
        end
      end

      def get_all_screenboards()
        begin
          request(Net::HTTP::Get, "/api/#{API_VERSION}/screen", true, nil, nil, false)
        rescue Exception => e
          suppress_error_if_silent e
        end
      end

      def delete_screenboard(board_id)
        begin
          request(Net::HTTP::Delete, "/api/#{API_VERSION}/screen/#{board_id}", true, nil, nil, false)
        rescue Exception => e
          suppress_error_if_silent e
        end
      end

      def share_screenboard(board_id)
        begin
          request(Net::HTTP::Get, "/api/#{API_VERSION}/screen/share/#{board_id}", true, nil, nil, false)
        rescue Exception => e
          suppress_error_if_silent e
        end
      end

      def revoke_screenboard(board_id)
        begin
          request(Net::HTTP::Delete, "/api/#{API_VERSION}/screen/share/#{board_id}", true, nil, nil, false)
        rescue Exception => e
          suppress_error_if_silent e
        end
      end

    end

  end
end
