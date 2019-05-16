require 'dogapi'

module Dogapi
  class V1 # for namespacing

    class SyntheticService < Dogapi::APIService

      API_VERSION = 'v1'

      def synthetic(type, config, options = {})
        body = {
          'type' => type,
          'config' => config
        }.merge(options)

        request(Net::HTTP::Post, "/api/#{API_VERSION}/synthetics/tests", nil, body, true)
      end

      def update_synthetic(synthetic_id, config, options = {})
        body = {
          'config' => config
        }.merge(options)

        request(Net::HTTP::Put, "/api/#{API_VERSION}/synthetics/tests/#{synthetic_id}", nil, body, true)
      end

    end

  end
end
