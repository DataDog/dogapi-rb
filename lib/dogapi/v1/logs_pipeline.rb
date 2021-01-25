# Unless explicitly stated otherwise all files in this repository are licensed under the BSD-3-Clause License.
# This product includes software developed at Datadog (https://www.datadoghq.com/).
# Copyright 2011-Present Datadog, Inc.

module Dogapi
  class V1 # for namespacing
    class LogsPipelineService < Dogapi::APIService
      API_VERSION = 'v1'

      def create_logs_pipeline(name, filter, options = {})
        body = {
          'name' => name,
          'filter' => filter
        }.merge options

        request(Net::HTTP::Post, "/api/#{API_VERSION}/logs/config/pipelines", nil, body, true)
      end

      def get_logs_pipeline(pipeline_id)
        request(Net::HTTP::Get, "/api/#{API_VERSION}/logs/config/pipelines/#{pipeline_id}", nil, nil, false)
      end

      def get_all_logs_pipelines
        request(Net::HTTP::Get, "/api/#{API_VERSION}/logs/config/pipelines", nil, nil, false)
      end

      def update_logs_pipeline(pipeline_id, name, filter, options = {})
        body = {
          'name' => name,
          'filter' => filter
        }.merge options

        request(Net::HTTP::Put, "/api/#{API_VERSION}/logs/config/pipelines/#{pipeline_id}", nil, body, true)
      end

      def delete_logs_pipeline(pipeline_id)
        request(Net::HTTP::Delete, "/api/#{API_VERSION}/logs/config/pipelines/#{pipeline_id}", nil, nil, false)
      end
    end
  end
end
