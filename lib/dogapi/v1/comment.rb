# Unless explicitly stated otherwise all files in this repository are licensed under the BSD-3-Clause License.
# This product includes software developed at Datadog (https://www.datadoghq.com/).
# Copyright 2011-Present Datadog, Inc.

module Dogapi
  class V1 # for namespacing

    class CommentService < Dogapi::APIService

      API_VERSION = 'v1'

      # Submit a comment.
      def comment(message, options = {})
        body = {
          'message' => message,
        }.merge options

        request(Net::HTTP::Post, "/api/#{API_VERSION}/comments", nil, body, true)
      end

      # Update a comment.
      def update_comment(comment_id, options = {})
        request(Net::HTTP::Put, "/api/#{API_VERSION}/comments/#{comment_id}", nil, options, true)
      end

      def delete_comment(comment_id)
        request(Net::HTTP::Delete, "/api/#{API_VERSION}/comments/#{comment_id}", nil, nil, false)
      end

    end

  end
end
