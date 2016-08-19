require 'dogapi'

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

      def update_monitor(monitor_id, query, options)
        body = {
          'query' => query,
        }.merge options

        request(Net::HTTP::Put, "/api/#{API_VERSION}/monitor/#{monitor_id}", nil, body, true)
      end

      def get_monitor(monitor_id, options = {})
        # :group_states is an optional list of statuses to filter returned
        # groups. If no value is given then no group states will be returned.
        # Possible values are: "all", "ok", "warn", "alert", "no data".
        extra_params = {}
        extra_params[:group_states] = options[:group_states].join(',') if options[:group_states]

        request(Net::HTTP::Get, "/api/#{API_VERSION}/monitor/#{monitor_id}", extra_params, nil, false)
      end

      def delete_monitor(monitor_id)
        request(Net::HTTP::Delete, "/api/#{API_VERSION}/monitor/#{monitor_id}", nil, nil, false)
      end

      def get_all_monitors(options = {})
        extra_params = {}
        # :group_states is an optional list of statuses to filter returned
        # groups. If no value is given then no group states will be returned.
        # Possible values are: "all", "ok", "warn", "alert", "no data".
        if options[:group_states]
          extra_params[:group_states] = options[:group_states]
          extra_params[:group_states] = extra_params[:group_states].join(',') if extra_params[:group_states].respond_to?(:join)
        end

        # :tags is an optional list of scope tags to filter the list of monitors
        # returned. If no value is given, then all monitors, regardless of
        # scope, will be returned.
        if options[:tags]
          extra_params[:tags] = options[:tags]
          extra_params[:tags] = extra_params[:tags].join(',') if extra_params[:tags].respond_to?(:join)
        end

        request(Net::HTTP::Get, "/api/#{API_VERSION}/monitor", extra_params, nil, false)
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

      def get_downtime(downtime_id)
        request(Net::HTTP::Get, "/api/#{API_VERSION}/downtime/#{downtime_id}", nil, nil, false)
      end

      def cancel_downtime(downtime_id)
        request(Net::HTTP::Delete, "/api/#{API_VERSION}/downtime/#{downtime_id}", nil, nil, false)
      end

      def get_all_downtimes(options = {})
        extra_params = {}
        if options[:current_only]
          extra_params[:current_only] = options[:current_only]
          options.delete :current_only
        end

        request(Net::HTTP::Get, "/api/#{API_VERSION}/downtime", extra_params, nil, false)
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
