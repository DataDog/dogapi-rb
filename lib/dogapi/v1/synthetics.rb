# Unless explicitly stated otherwise all files in this repository are licensed under the BSD-3-Clause License.
# This product includes software developed at Datadog (https://www.datadoghq.com/).
# Copyright 2011-Present Datadog, Inc.

module Dogapi
  class V1 # for namespacing
    # SyntheticsService is the class responsible for dealing with the synthetics
    class SyntheticsService < Dogapi::APIService

      API_VERSION = 'v1'

      # Create a synthetics test: POST /v1/synthetics/tests/
      def create_synthetics_test(type, config, options = {})
        body = {
          'type' => type,
          'config' => config
        }.merge(options)

        request(Net::HTTP::Post, "/api/#{API_VERSION}/synthetics/tests", nil, body, true)
      end

      # Edit a synthetics test: PUT /v1/synthetics/tests/<SYNTHETICS_TEST_PUBLIC_ID>
      def update_synthetics_test(test_id, type, config, options = {})
        body = {
          'type' => type,
          'config' => config
        }.merge(options)

        request(Net::HTTP::Put, "/api/#{API_VERSION}/synthetics/tests/#{test_id}", nil, body, true)
      end

      # Delete synthetics tests
      def delete_synthetics_tests(test_ids)
        body = {
          'public_ids' => test_ids
        }
        request(Net::HTTP::Post, "/api/#{API_VERSION}/synthetics/tests/delete", nil, body, true)
      end

      # Start of pause a synthetics test: POST /v1/synthetics/tests/<SYNTHETICS_TEST_PUBLIC_ID>/status
      def start_pause_synthetics_test(test_id, new_status)
        body = {
          'new_status' => new_status
        }
        request(Net::HTTP::Put, "/api/#{API_VERSION}/synthetics/tests/#{test_id}/status", nil, body, true)
      end

      # Get all synthetics tests: GET /v1/synthetics/tests
      def get_all_synthetics_tests
        request(Net::HTTP::Get, "/api/#{API_VERSION}/synthetics/tests", nil, nil, false)
      end

      # Get info on a synthetics test: GET /v1/synthetics/tests/<SYNTHETICS_TEST_PUBLIC_ID>
      def get_synthetics_test(test_id)
        request(Net::HTTP::Get, "/api/#{API_VERSION}/synthetics/tests/#{test_id}", nil, nil, false)
      end

      # Get the most recent results for a synthetics test: GET /v1/synthetics/tests/<SYNTHETICS_TEST_PUBLIC_ID>/results
      def get_synthetics_results(test_id)
        request(Net::HTTP::Get, "/api/#{API_VERSION}/synthetics/tests/#{test_id}/results", nil, nil, false)
      end

      # Get a specific result for a synthetics test:
      # GET /v1/synthetics/tests/<SYNTHETICS_TEST_PUBLIC_ID>/results/<RESULT_ID>
      def get_synthetics_result(test_id, result_id)
        request(Net::HTTP::Get, "/api/#{API_VERSION}/synthetics/tests/#{test_id}/results/#{result_id}", nil, nil, false)
      end

      # Get devices for browser checks: GET /v1/synthetics/browser/devices
      def get_synthetics_devices
        request(Net::HTTP::Get, "/api/#{API_VERSION}/synthetics/browser/devices", nil, nil, false)
      end

      # Get available locations: GET /v1/synthetics/locations
      def get_synthetics_locations
        request(Net::HTTP::Get, "/api/#{API_VERSION}/synthetics/locations", nil, nil, false)
      end

    end

  end
end
