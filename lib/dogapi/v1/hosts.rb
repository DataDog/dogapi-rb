require 'dogapi'

module Dogapi
  class V1 # for namespacing

    # Hosts API
    class HostsService < Dogapi::APIService

      API_VERSION = 'v1'

      def get_all(options = {})
        request(Net::HTTP::Get, "/api/#{API_VERSION}/hosts", nil, options, true)
      end

      def totals
        request(Net::HTTP::Get, "/api/#{API_VERSION}/hosts/totals", nil, nil, true)
      end
    end

  end
end
