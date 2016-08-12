require 'dogapi'

module Dogapi
  class V1 # for namespacing

    class CommentService < Dogapi::APIService

      API_VERSION = "v1"

      # Submit a comment.
      def comment(message, options = {})
        body = {
          'message' => message,
        }.merge options

        request(Net::HTTP::Post, "/api/#{API_VERSION}/comments", nil, body, true)
      end

      # Update a comment.
      def update_comment(comment_id, options = {})
        if options.empty?
          raise "Must update something."
        end

        request(Net::HTTP::Put, "/api/#{API_VERSION}/comments/#{comment_id}", nil, options, true)
      end

      def delete_comment(comment_id)
        request(Net::HTTP::Delete, "/api/#{API_VERSION}/comments/#{comment_id}", nil, nil, false)
      end

    end

  end
end
