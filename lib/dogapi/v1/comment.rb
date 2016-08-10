require 'dogapi'

module Dogapi
  class V1 # for namespacing

    class CommentService < Dogapi::APIService

      API_VERSION = "v1"

      # Submit a comment.
      def comment(message, options = {})
        begin
          body = {
            'message' => message,
          }.merge options

          request(Net::HTTP::Post, "/api/#{API_VERSION}/comments", true, nil, body, true)
        rescue Exception => e
          suppress_error_if_silent e
        end
      end

      # Update a comment.
      def update_comment(comment_id, options = {})
        begin
          if options.empty?
            raise "Must update something."
          end

          request(Net::HTTP::Put, "/api/#{API_VERSION}/comments/#{comment_id}", true, nil, options, true)
        rescue Exception => e
          suppress_error_if_silent e
        end
      end

      def delete_comment(comment_id)
        begin
          request(Net::HTTP::Delete, "/api/#{API_VERSION}/comments/#{comment_id}", true, nil, nil, false)
        rescue Exception => e
          suppress_error_if_silent e
        end
      end

    end

  end
end
