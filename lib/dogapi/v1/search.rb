require 'dogapi'

module Dogapi
  class V1 # for namespacing

    class SearchService < Dogapi::APIService

      API_VERSION = "v1"

      def search(query)
        begin
          extra_params = {
            :q => query
          }

          request(Net::HTTP::Get, "/api/#{API_VERSION}/search", true, extra_params, nil, false)
        rescue Exception => e
          suppress_error_if_silent e
        end
      end

    end

  end
end
