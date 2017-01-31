require 'dogapi'

module Dogapi
  class V1

    class MetadataService < Dogapi::APIService

      API_VERSION = 'v1'

      def get(metric_name)
        request(Net::HTTP::Get, "/api/#{API_VERSION}/metrics/#{metric_name}", nil, nil, false)
      end

      def update(metric_name, options = {})
        request(Net::HTTP::Put, "/api/#{API_VERSION}/metrics/#{metric_name}", nil, options, true)
      end
    end

  end
end
