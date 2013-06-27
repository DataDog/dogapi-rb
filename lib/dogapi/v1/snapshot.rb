require 'dogapi'

module Dogapi
  class V1 # for namespacing

    class SnapshotService < Dogapi::APIService

      API_VERSION = "v1"

      def snapshot(metric_query, start_ts, end_ts, event_query=nil)
        begin
          params = {
            :api_key => @api_key,
            :application_key => @application_key,
            :metric_query => metric_query,
            :start => start_ts,
            :end => end_ts,
            :event_query => event_query
          }

          request(Net::HTTP::Get, "/api/#{API_VERSION}/graph/snapshot", params, nil, false)
        rescue Exception => e
          suppress_error_if_silent e
        end
      end

    end

  end
end
