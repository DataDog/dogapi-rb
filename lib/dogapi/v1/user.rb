require 'dogapi'

module Dogapi
  class V1 # for namespacing

    class UserService < Dogapi::APIService

      API_VERSION = "v1"

      # <b>DEPRECATED:</b> Going forward, we're using a new and more restful API,
      # the new methods are get_user, create_user, update_user, disable_user
      def invite(emails, options = {})
        warn "[DEPRECATION] Dogapi::V1::UserService::invite has been deprecated in favor of Dogapi::V1::UserService::create_user"
        begin
          params = {
            :api_key => @api_key,
            :application_key => @application_key
          }

          body = {
            'emails' => emails,
          }.merge options

          request(Net::HTTP::Post, "/api/#{API_VERSION}/invite_users", params, body, true)
        rescue Exception => e
          suppress_error_if_silent e
        end
      end

      # Create a user
      #
      # :description => Hash: user description containing 'handle' and 'name' properties
      def create_user(description = {})
        begin
          params = {
            :api_key => @api_key,
            :application_key => @application_key
          }

          request(Net::HTTP::Post, "/api/#{API_VERSION}/user", params, description, true)
        rescue Exception => e
          suppress_error_if_silent e
        end
      end

      # Retrieve user information
      #
      # :handle => String: user handle
      def get_user(handle)
        begin
          params = {
            :api_key => @api_key,
            :application_key => @application_key
          }

          request(Net::HTTP::Get, "/api/#{API_VERSION}/user/#{handle}", params, nil, false)
        rescue Exception => e
          suppress_error_if_silent e
        end
      end

      # Retrieve all users
      def get_all_users()
        begin
          params = {
            :api_key => @api_key,
            :application_key => @application_key
          }

          request(Net::HTTP::Get, "/api/#{API_VERSION}/user", params, nil, false)
        rescue Exception => e
          suppress_error_if_silent e
        end
      end

      # Update a user
      #
      # :handle => String: user handle
      # :description => Hash: user description optionally containing 'name', 'email',
      # 'is_admin', 'disabled' properties
      def update_user(handle, description = {})
        begin
          params = {
            :api_key => @api_key,
            :application_key => @application_key
          }

          request(Net::HTTP::Put, "/api/#{API_VERSION}/user/#{handle}", params, description, true)
        rescue Exception => e
          suppress_error_if_silent e
        end
      end

      # Disable a user
      #
      # :handle => String: user handle
      def disable_user(handle)
        begin
          params = {
            :api_key => @api_key,
            :application_key => @application_key
          }

          request(Net::HTTP::Delete, "/api/#{API_VERSION}/user/#{handle}", params, nil, false)
        rescue Exception => e
          suppress_error_if_silent e
        end
      end

    end

  end
end
