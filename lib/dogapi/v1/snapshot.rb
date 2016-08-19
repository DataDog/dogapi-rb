require 'dogapi'

module Dogapi
  class V1 # for namespacing

    class SnapshotService < Dogapi::APIService

      API_VERSION = "v1"

      def snapshot(metric_query, start_ts, end_ts, event_query=nil)
        extra_params = {
          :metric_query => metric_query,
          :start => start_ts,
          :end => end_ts,
        }

        extra_params[:event_query] = event_query if event_query

        request(Net::HTTP::Get, "/api/#{API_VERSION}/graph/snapshot", extra_params, nil, false)
      end

    end

  end
end
