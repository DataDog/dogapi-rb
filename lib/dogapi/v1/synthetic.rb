require 'dogapi'

module Dogapi
  class V1 # for namespacing
    # SyntheticService is the class responsible for dealing with the synthetics
    class SyntheticService < Dogapi::APIService

      API_VERSION = 'v1'

      def create_test(type, config, options = {})
        body = {
          'type' => type,
          'config' => config
        }.merge(options)

        request(Net::HTTP::Post, "/api/#{API_VERSION}/synthetics/tests", nil, body, true)
      end

      def update_test(test_id, config, options = {})
        body = {
          'config' => config
        }.merge(options)

        request(Net::HTTP::Put, "/api/#{API_VERSION}/synthetics/tests/#{test_id}", nil, body, true)
      end

      def get_all_tests
        request(Net::HTTP::Get, "/api/#{API_VERSION}/synthetics/tests", nil, nil, false)
      end

      def get_test(test_id)
        request(Net::HTTP::Get, "/api/#{API_VERSION}/synthetics/tests/#{test_id}", nil, nil, false)
      end

      def get_results(test_id)
        request(Net::HTTP::Get, "/api/#{API_VERSION}/synthetics/tests/#{test_id}/results", nil, nil, false)
      end

      def get_result(test_id, result_id)
        request(Net::HTTP::Get, "/api/#{API_VERSION}/synthetics/tests/#{test_id}/results/#{result_id}", nil, nil, false)
      end

      def get_devices
        request(Net::HTTP::Get, "/api/#{API_VERSION}/synthetics/browser/devices", nil, nil, false)
      end

      def get_locations
        request(Net::HTTP::Get, "/api/#{API_VERSION}/synthetics/locations", nil, nil, false)
      end

    end
    
  end
end
