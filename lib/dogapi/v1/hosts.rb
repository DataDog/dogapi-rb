require 'dogapi'

module Dogapi
  class V1 # for namespacing

    # Hosts API
    class HostsService < Dogapi::APIService

      API_VERSION = 'v1'

      def search(options = {})
        request(Net::HTTP::Get, "/api/#{API_VERSION}/hosts", options, nil, false)
      end

      def totals
        request(Net::HTTP::Get, "/api/#{API_VERSION}/hosts/totals", nil, nil, true)
      end
    end

  end
end
