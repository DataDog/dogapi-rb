# Unless explicitly stated otherwise all files in this repository are licensed under the BSD-3-Clause License.
# This product includes software developed at Datadog (https://www.datadoghq.com/).
# Copyright 2011-Present Datadog, Inc.

module Dogapi
  class V1 # for namespacing
    class MonitorService < Dogapi::APIService
      API_VERSION = 'v1'

      def monitor(type, query, options = {})
        body = {
          'type' => type,
          'query' => query,
        }.merge options

        request(Net::HTTP::Post, "/api/#{API_VERSION}/monitor", nil, body, true)
      end

      def update_monitor(monitor_id, query = nil, options = {})
        body = {}.merge options
        unless query.nil?
          body = {
            'query' => query
          }.merge body
          warn '[DEPRECATION] query param is not required anymore and should be set to nil.'\
             ' To update the query, set it in the options parameter instead'
        end

        request(Net::HTTP::Put, "/api/#{API_VERSION}/monitor/#{monitor_id}", nil, body, true)
      end

      def get_monitor(monitor_id, options = {})
        extra_params = options.clone
        # :group_states is an optional list of statuses to filter returned
        # groups. If no value is given then no group states will be returned.
        # Possible values are: "all", "ok", "warn", "alert", "no data".

        if extra_params[:group_states].respond_to?(:join)
          extra_params[:group_states] = extra_params[:group_states].join(',')
        end

        request(Net::HTTP::Get, "/api/#{API_VERSION}/monitor/#{monitor_id}", extra_params, nil, false)
      end

      def can_delete_monitors(monitor_ids)
        extra_params =
          if monitor_ids.respond_to?(:join)
            { "monitor_ids" => monitor_ids.join(",") }
          else
            { "monitor_ids" => monitor_ids }
          end

        request(Net::HTTP::Get, "/api/#{API_VERSION}/monitor/can_delete", extra_params, nil, false)
      end

      def delete_monitor(monitor_id, options = {})
        request(Net::HTTP::Delete, "/api/#{API_VERSION}/monitor/#{monitor_id}", options, nil, false)
      end

      def get_all_monitors(options = {})
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

        request(Net::HTTP::Get, "/api/#{API_VERSION}/monitor", extra_params, nil, false)
      end

      def validate_monitor(type, query, options = {})
        body = {
          'type' => type,
          'query' => query,
        }.merge options

        request(Net::HTTP::Post, "/api/#{API_VERSION}/monitor/validate", nil, body, true)
      end

      def mute_monitors
        request(Net::HTTP::Post, "/api/#{API_VERSION}/monitor/mute_all", nil, nil, false)
      end

      def unmute_monitors
        request(Net::HTTP::Post, "/api/#{API_VERSION}/monitor/unmute_all", nil, nil, false)
      end

      def mute_monitor(monitor_id, options = {})
        request(Net::HTTP::Post, "/api/#{API_VERSION}/monitor/#{monitor_id}/mute", nil, options, true)
      end

      def unmute_monitor(monitor_id, options = {})
        request(Net::HTTP::Post, "/api/#{API_VERSION}/monitor/#{monitor_id}/unmute", nil, options, true)
      end

      def resolve_monitors(monitor_groups = [], options = {}, version = nil)
        body = {
          'resolve' => monitor_groups
        }.merge options

        # Currently not part of v1 at this time but adding future compatibility option
        endpoint = version.nil? ? '/api/monitor/bulk_resolve' : "/api/#{version}/monitor/bulk_resolve"

        request(Net::HTTP::Post, endpoint, nil, body, true)
      end

      def search_monitors(options = {})
        request(Net::HTTP::Get, "/api/#{API_VERSION}/monitor/search", options, nil, false)
      end

      def search_monitor_groups(options = {})
        request(Net::HTTP::Get, "/api/#{API_VERSION}/monitor/groups/search", options, nil, false)
      end

      #
      # DOWNTIMES

      def schedule_downtime(scope, options = {})
        body = {
          'scope' => scope
        }.merge options

        request(Net::HTTP::Post, "/api/#{API_VERSION}/downtime", nil, body, true)
      end

      def update_downtime(downtime_id, options = {})
        request(Net::HTTP::Put, "/api/#{API_VERSION}/downtime/#{downtime_id}", nil, options, true)
      end

      def get_downtime(downtime_id, options = {})
        request(Net::HTTP::Get, "/api/#{API_VERSION}/downtime/#{downtime_id}", options, nil, false)
      end

      def cancel_downtime(downtime_id)
        request(Net::HTTP::Delete, "/api/#{API_VERSION}/downtime/#{downtime_id}", nil, nil, false)
      end

      def cancel_downtime_by_scope(scope)
        request(Net::HTTP::Post, "/api/#{API_VERSION}/downtime/cancel/by_scope", nil, { 'scope' => scope }, true)
      end

      def get_all_downtimes(options = {})
        request(Net::HTTP::Get, "/api/#{API_VERSION}/downtime", options, nil, false)
      end

      #
      # HOST MUTING

      def mute_host(hostname, options = {})
        request(Net::HTTP::Post, "/api/#{API_VERSION}/host/#{hostname}/mute", nil, options, true)
      end

      def unmute_host(hostname)
        request(Net::HTTP::Post, "/api/#{API_VERSION}/host/#{hostname}/unmute", nil, {}, true)
      end
    end
  end
end
