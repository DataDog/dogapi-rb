require 'dogapi'

module Dogapi
  class V1 # for namespacing
    class MonitorService < Dogapi::APIService
      API_VERSION = 'v1'

      def monitor(type, query, options = {})
        retry_params = options.delete(:retry_params) {|_| {}}
        body = {
          'type' => type,
          'query' => query,
        }.merge options

        request(Net::HTTP::Post, "/api/#{API_VERSION}/monitor", nil, body, true, retry_params)
      end

      def update_monitor(monitor_id, query = nil, options = {})
        retry_params = options.delete(:retry_params) {|_| {}}
        body = {}.merge options
        unless query.nil?
          body = {
            'query' => query
          }.merge body
          warn '[DEPRECATION] query param is not required anymore and should be set to nil.'\
             ' To update the query, set it in the options parameter instead'
        end

        request(Net::HTTP::Put, "/api/#{API_VERSION}/monitor/#{monitor_id}", nil, body, true, retry_params)
      end

      def get_monitor(monitor_id, options = {})
        retry_params = options.delete(:retry_params) {|_| {}}
        extra_params = options.clone
        # :group_states is an optional list of statuses to filter returned
        # groups. If no value is given then no group states will be returned.
        # Possible values are: "all", "ok", "warn", "alert", "no data".

        if extra_params[:group_states].respond_to?(:join)
          extra_params[:group_states] = extra_params[:group_states].join(',')
        end

        request(Net::HTTP::Get, "/api/#{API_VERSION}/monitor/#{monitor_id}", extra_params, nil, false, retry_params)
      end

      def can_delete_monitors(monitor_ids, options = {})
        retry_params = options.delete(:retry_params) {|_| {}}
        extra_params =
          if monitor_ids.respond_to?(:join)
            { "monitor_ids" => monitor_ids.join(",") }
          else
            { "monitor_ids" => monitor_ids }
          end

        request(Net::HTTP::Get, "/api/#{API_VERSION}/monitor/can_delete", extra_params, nil, false, retry_params)
      end

      def delete_monitor(monitor_id, options = {})
        retry_params = options.delete(:retry_params) {|_| {}}
        request(Net::HTTP::Delete, "/api/#{API_VERSION}/monitor/#{monitor_id}", nil, nil, false, retry_params)
      end

      def get_all_monitors(options = {})
        retry_params = options.delete(:retry_params) {|_| {}}
        extra_params = options.clone
        # :group_states is an optional list of statuses to filter returned
        # groups. If no value is given then no group states will be returned.
        # Possible values are: "all", "ok", "warn", "alert", "no data".
        if extra_params[:group_states].respond_to?(:join)
          extra_params[:group_states] = extra_params[:group_states].join(',')
        end

        # :tags is an optional list of scope tags to filter the list of monitors
        # returned. If no value is given, then all monitors, regardless of
        # scope, will be returned.
        extra_params[:tags] = extra_params[:tags].join(',') if extra_params[:tags].respond_to?(:join)

        request(Net::HTTP::Get, "/api/#{API_VERSION}/monitor", extra_params, nil, false, retry_params)
      end

      def validate_monitor(type, query, options = {})
        retry_params = options.delete(:retry_params) {|_| {}}
        body = {
          'type' => type,
          'query' => query,
        }.merge options

        request(Net::HTTP::Post, "/api/#{API_VERSION}/monitor/validate", nil, body, true, retry_params)
      end

      def mute_monitors(options = {})
        retry_params = options.delete(:retry_params) {|_| {}}
        request(Net::HTTP::Post, "/api/#{API_VERSION}/monitor/mute_all", nil, nil, false, retry_params)
      end

      def unmute_monitors(options = {})
        retry_params = options.delete(:retry_params) {|_| {}}
        request(Net::HTTP::Post, "/api/#{API_VERSION}/monitor/unmute_all", nil, nil, false, retry_params)
      end

      def mute_monitor(monitor_id, options = {})
        retry_params = options.delete(:retry_params) {|_| {}}
        request(Net::HTTP::Post, "/api/#{API_VERSION}/monitor/#{monitor_id}/mute", nil, options, true, retry_params)
      end

      def unmute_monitor(monitor_id, options = {})
        retry_params = options.delete(:retry_params) {|_| {}}
        request(Net::HTTP::Post, "/api/#{API_VERSION}/monitor/#{monitor_id}/unmute", nil, options, true, retry_params)
      end

      def resolve_monitors(monitor_groups = [], options = {}, version = nil)
        retry_params = options.delete(:retry_params) {|_| {}}
        body = {
          'resolve' => monitor_groups
        }.merge options

        # Currently not part of v1 at this time but adding future compatibility option
        endpoint = version.nil? ? '/api/monitor/bulk_resolve' : "/api/#{version}/monitor/bulk_resolve"

        request(Net::HTTP::Post, endpoint, nil, body, true, retry_params)
      end

      def search_monitors(options = {})
        retry_params = options.delete(:retry_params) {|_| {}}
        request(Net::HTTP::Get, "/api/#{API_VERSION}/monitor/search", options, nil, false, retry_params)
      end

      def search_monitor_groups(options = {})
        retry_params = options.delete(:retry_params) {|_| {}}
        request(Net::HTTP::Get, "/api/#{API_VERSION}/monitor/groups/search", options, nil, false, retry_params)
      end

      #
      # DOWNTIMES

      def schedule_downtime(scope, options = {})
        retry_params = options.delete(:retry_params) {|_| {}}
        body = {
          'scope' => scope
        }.merge options

        request(Net::HTTP::Post, "/api/#{API_VERSION}/downtime", nil, body, true, retry_params)
      end

      def update_downtime(downtime_id, options = {})
        retry_params = options.delete(:retry_params) {|_| {}}
        request(Net::HTTP::Put, "/api/#{API_VERSION}/downtime/#{downtime_id}", nil, options, true, retry_params)
      end

      def get_downtime(downtime_id, options = {})
        retry_params = options.delete(:retry_params) {|_| {}}
        request(Net::HTTP::Get, "/api/#{API_VERSION}/downtime/#{downtime_id}", nil, nil, false, retry_params)
      end

      def cancel_downtime(downtime_id, options = {})
        retry_params = options.delete(:retry_params) {|_| {}}
        request(Net::HTTP::Delete, "/api/#{API_VERSION}/downtime/#{downtime_id}", nil, nil, false, retry_params)
      end

      def cancel_downtime_by_scope(scope, options = {})
        retry_params = options.delete(:retry_params) {|_| {}}
        request(Net::HTTP::Post, "/api/#{API_VERSION}/downtime/cancel/by_scope", nil, { 'scope' => scope }, false, retry_params)
      end

      def get_all_downtimes(options = {})
        retry_params = options.delete(:retry_params) {|_| {}}
        request(Net::HTTP::Get, "/api/#{API_VERSION}/downtime", options, nil, false, retry_params)
      end

      #
      # HOST MUTING

      def mute_host(hostname, options = {})
        retry_params = options.delete(:retry_params) {|_| {}}
        request(Net::HTTP::Post, "/api/#{API_VERSION}/host/#{hostname}/mute", nil, options, true, retry_params)
      end

      def unmute_host(hostname, options = {})
        retry_params = options.delete(:retry_params) {|_| {}}
        request(Net::HTTP::Post, "/api/#{API_VERSION}/host/#{hostname}/unmute", nil, {}, true, retry_params)
      end
    end
  end
end
