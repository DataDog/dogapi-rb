require 'net/http'

require 'rubygems'
require 'json'

module Dogapi

  class MetricService < Dogapi::Service

    API_VERSION = "1.0.0"

    def submit(api_key, scope, metric, points)
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
