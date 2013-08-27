require 'dogapi'

module Dogapi
  class V1 # for namespacing

    class CommentService < Dogapi::APIService

      API_VERSION = "v1"

      # Submit a comment.
      def comment(message, options = {})
        begin
          params = {
            :api_key => @api_key,
            :application_key => @application_key
          }

          body = {
            'message' => message,
          }.merge options

          request(Net::HTTP::Post, "/api/#{API_VERSION}/comments", params, body, true)
        rescue Exception => e
          suppress_error_if_silent e
        end
      end

      # Update a comment.
      def update_comment(comment_id, options = {})
        begin
          params = {
            :api_key => @api_key,
            :application_key => @application_key
          }

          if options.empty?
            raise "Must update something."
          end

          request(Net::HTTP::Put, "/api/#{API_VERSION}/comments/#{comment_id}", params, options, true)
        rescue Exception => e
          suppress_error_if_silent e
        end
      end

      def delete_comment(comment_id)
        begin
          params = {
            :api_key => @api_key,
            :application_key => @application_key
          }

          request(Net::HTTP::Delete, "/api/#{API_VERSION}/comments/#{comment_id}", params, nil, false)
        rescue Exception => e
          suppress_error_if_silent e
        end
      end

    end

  end
end
