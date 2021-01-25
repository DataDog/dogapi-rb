# Unless explicitly stated otherwise all files in this repository are licensed under the BSD-3-Clause License.
# This product includes software developed at Datadog (https://www.datadoghq.com/).
# Copyright 2011-Present Datadog, Inc.

module Dogapi
  class V1 # for namespacing

    class ScreenboardService < Dogapi::APIService

      API_VERSION = 'v1'

      def create_screenboard(description)
        request(Net::HTTP::Post, "/api/#{API_VERSION}/screen", nil, description, true)
      end

      def update_screenboard(board_id, description)
        request(Net::HTTP::Put, "/api/#{API_VERSION}/screen/#{board_id}", nil, description, true)
      end

      def get_screenboard(board_id)
        request(Net::HTTP::Get, "/api/#{API_VERSION}/screen/#{board_id}", nil, nil, false)
      end

      def get_all_screenboards()
        request(Net::HTTP::Get, "/api/#{API_VERSION}/screen", nil, nil, false)
      end

      def delete_screenboard(board_id)
        request(Net::HTTP::Delete, "/api/#{API_VERSION}/screen/#{board_id}", nil, nil, false)
      end

      def share_screenboard(board_id)
        request(Net::HTTP::Post, "/api/#{API_VERSION}/screen/share/#{board_id}", nil, nil, false)
      end

      def revoke_screenboard(board_id)
        request(Net::HTTP::Delete, "/api/#{API_VERSION}/screen/share/#{board_id}", nil, nil, false)
      end

    end

  end
end
