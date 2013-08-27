require 'dogapi'

module Dogapi
  class V1 # for namespacing

    class UserService < Dogapi::APIService

      API_VERSION = "v1"

      def invite(emails, options = {})
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
    end

  end
end
