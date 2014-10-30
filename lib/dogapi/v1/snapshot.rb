require 'uri'
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

      def snapshot_from_def(graph_def, start_ts, end_ts)
        begin
          params = {
            :api_key => @api_key,
            :application_key => @application_key,
            :graph_def => graph_def,
            :start => start_ts,
            :end => end_ts
          }

          request(Net::HTTP::Get, "/api/#{API_VERSION}/graph/snapshot", params, nil, false)
        rescue Exception => e
          suppress_error_if_silent e
        end
      end

      def snapshot_status(snapshot_url)
        begin
          snap_path = URI.parse(snapshot_url).path
          snap_path = snap_path.split('/snapshot/view/')[1].split('.png')[0]
          url = "/api/#{API_VERSION}/graph/snapshot_status/#{snap_path}"
          params = {
            :api_key => @api_key,
            :application_key => @application_key
          }
          request(Net::HTTP::Get, url, params, nil, false)
        rescue Exception => e
          suppress_error_if_silent e
        end
      end

    end

  end
end
