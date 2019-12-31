# Unless explicitly stated otherwise all files in this repository are licensed under the BSD-3-Clause License.
# This product includes software developed at Datadog (https://www.datadoghq.com/).
# Copyright 2011-Present Datadog, Inc.

require 'net/http'

require 'rubygems'
require 'multi_json'

module Dogapi

  # <b>DEPRECATED:</b> Going forward, use the V1 services. This legacy service will be
  # removed in an upcoming release.
  class MetricService < Dogapi::Service

    API_VERSION = '1.0.0'

    # <b>DEPRECATED:</b> Going forward, use the V1 services. This legacy service will be
    # removed in an upcoming release.
    def submit(api_key, scope, metric, points)
      warn '[DEPRECATION] Dogapi::MetricService.submit() has been deprecated in favor of the newer V1 services'
      series = [{
        :host    =>  scope.host,
        :device  =>  scope.device,
        :metric  =>  metric,
        :points  =>  points.map { |p| [p[0].to_i, p[1]] }
      }]

      params = {
        :api_key      =>  api_key,
        :api_version  =>  API_VERSION,
        :series       =>  series.to_json
      }

      request Net::HTTP::Post, '/series/submit', params
    end
  end
end
