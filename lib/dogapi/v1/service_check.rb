# Unless explicitly stated otherwise all files in this repository are licensed under the BSD-3-Clause License.
# This product includes software developed at Datadog (https://www.datadoghq.com/).
# Copyright 2011-Present Datadog, Inc.

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
