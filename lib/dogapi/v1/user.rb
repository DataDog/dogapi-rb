# Unless explicitly stated otherwise all files in this repository are licensed under the BSD-3-Clause License.
# This product includes software developed at Datadog (https://www.datadoghq.com/).
# Copyright 2011-Present Datadog, Inc.

module Dogapi
  class V1 # for namespacing

    class UserService < Dogapi::APIService

      API_VERSION = 'v1'

      # <b>DEPRECATED:</b> Going forward, we're using a new and more restful API,
      # the new methods are get_user, create_user, update_user, disable_user
      def invite(emails, options= {})
        warn '[DEPRECATION] Dogapi::V1::UserService::invite has been deprecated '\
             'in favor of Dogapi::V1::UserService::create_user'
        body = {
          'emails' => emails,
        }.merge options

        request(Net::HTTP::Post, "/api/#{API_VERSION}/invite_users", nil, body, true)
      end

      # Create a user
      #
      # :description => Hash: user description containing 'handle' and 'name' properties
      def create_user(description= {})
        request(Net::HTTP::Post, "/api/#{API_VERSION}/user", nil, description, true)
      end

      # Retrieve user information
      #
      # :handle => String: user handle
      def get_user(handle)
        request(Net::HTTP::Get, "/api/#{API_VERSION}/user/#{handle}", nil, nil, false)
      end

      # Retrieve all users
      def get_all_users
        request(Net::HTTP::Get, "/api/#{API_VERSION}/user", nil, nil, false)
      end

      # Update a user
      #
      # :handle => String: user handle
      # :description => Hash: user description optionally containing 'name', 'email',
      # 'is_admin', 'disabled' properties
      def update_user(handle, description= {})
        request(Net::HTTP::Put, "/api/#{API_VERSION}/user/#{handle}", nil, description, true)
      end

      # Disable a user
      #
      # :handle => String: user handle
      def disable_user(handle)
        request(Net::HTTP::Delete, "/api/#{API_VERSION}/user/#{handle}", nil, nil, false)
      end

    end

  end
end
