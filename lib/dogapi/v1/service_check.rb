require 'dogapi'

module Dogapi
  class V1

    class ServiceCheckService < Dogapi::APIService

      API_VERSION = 'v1'

      def service_check(check, host, status, options = {})
        begin
          body = {
            'check' => check,
            'host_name' => host,
            'status' => status
          }.merge options

          request(Net::HTTP::Post, "/api/#{API_VERSION}/check_run", true, nil, body, true)
        rescue Exception => e
          suppress_error_if_silent e
        end
      end

    end

  end
end
