require 'dogeapi'

module Dogeapi
  class V1 # for namespacing

    class SearchService < Dogeapi::APIService

      API_VERSION = "v1"

      def search(query)
        begin
          params = {
            :api_key => @api_key,
            :application_key => @application_key,
            :q => query
          }

          request(Net::HTTP::Get, "/api/#{API_VERSION}/search", params, nil, false)
        rescue Exception => e
          suppress_error_if_silent e
        end
      end

    end

  end
end
