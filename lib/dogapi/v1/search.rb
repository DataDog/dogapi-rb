require 'dogapi'

module Dogapi
  class V1 # for namespacing

    class SearchService < Dogapi::APIService

      API_VERSION = "v1"

      def search(query)
        extra_params = {
          :q => query
        }

        request(Net::HTTP::Get, "/api/#{API_VERSION}/search", extra_params, nil, false)
      end

    end

  end
end
