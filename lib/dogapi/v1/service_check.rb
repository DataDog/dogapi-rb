require 'dogapi'

module Dogapi
  class V1

    class ServiceCheckService < Dogapi::APIService

      API_VERSION = 'v1'

      def service_check(check, host, status, options = {})
        body = {
          'check' => check,
          'host_name' => host,
          'status' => status
        }.merge options

        request(Net::HTTP::Post, "/api/#{API_VERSION}/check_run", nil, body, true)
      end

    end

  end
end
