require 'dogapi'

module Dogapi
  class V1 # for namespacing

    class MonitorService < Dogapi::APIService

      API_VERSION = 'v1'

      def monitor(type, query, options = {})
        begin
          body = {
            'type' => type,
            'query' => query,
          }.merge options

          request(Net::HTTP::Post, "/api/#{API_VERSION}/monitor", true, nil, body, true)
        rescue Exception => e
          suppress_error_if_silent e
        end
      end

      def update_monitor(monitor_id, query, options)
        begin
          body = {
            'query' => query,
          }.merge options

          request(Net::HTTP::Put, "/api/#{API_VERSION}/monitor/#{monitor_id}", true, nil, body, true)
        rescue Exception => e
          suppress_error_if_silent e
        end
      end

      def get_monitor(monitor_id, options = {})
        begin
          # :group_states is an optional list of statuses to filter returned
          # groups. If no value is given then no group states will be returned.
          # Possible values are: "all", "ok", "warn", "alert", "no data".
          extra_params = {}
          extra_params[:group_states] = options[:group_states].join(',') if options[:group_states]

          request(Net::HTTP::Get, "/api/#{API_VERSION}/monitor/#{monitor_id}", true, extra_params, nil, false)
        rescue Exception => e
          suppress_error_if_silent e
        end
      end

      def delete_monitor(monitor_id)
        begin
          request(Net::HTTP::Delete, "/api/#{API_VERSION}/monitor/#{monitor_id}", true, nil, nil, false)
        rescue Exception => e
          suppress_error_if_silent e
        end
      end

      def get_all_monitors(options = {})
        begin
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

          request(Net::HTTP::Get, "/api/#{API_VERSION}/monitor", true, extra_params, nil, false)
        rescue Exception => e
          suppress_error_if_silent e
        end
      end

      def mute_monitors
        begin
          request(Net::HTTP::Post, "/api/#{API_VERSION}/monitor/mute_all", true, nil, nil, false)
        rescue Exception => e
          suppress_error_if_silent e
        end
      end

      def unmute_monitors
        begin
          request(Net::HTTP::Post, "/api/#{API_VERSION}/monitor/unmute_all", true, nil, nil, false)
        rescue Exception => e
          suppress_error_if_silent e
        end
      end

      def mute_monitor(monitor_id, options = {})
        begin
          request(Net::HTTP::Post, "/api/#{API_VERSION}/monitor/#{monitor_id}/mute", true, nil, options, true)
        rescue Exception => e
          suppress_error_if_silent e
        end
      end

      def unmute_monitor(monitor_id, options = {})
        begin
          request(Net::HTTP::Post, "/api/#{API_VERSION}/monitor/#{monitor_id}/unmute", true, nil, options, true)
        rescue Exception => e
          suppress_error_if_silent e
        end
      end

      #
      # DOWNTIMES

      def schedule_downtime(scope, options = {})
        begin
          body = {
            'scope' => scope
          }.merge options

          request(Net::HTTP::Post, "/api/#{API_VERSION}/downtime", true, nil, body, true)
        rescue Exception => e
          suppress_error_if_silent e
        end
      end

      def update_downtime(downtime_id, options = {})
        begin
          request(Net::HTTP::Put, "/api/#{API_VERSION}/downtime/#{downtime_id}", true, nil, options, true)
        rescue Exception => e
          suppress_error_if_silent e
        end
      end

      def get_downtime(downtime_id)
        begin
          request(Net::HTTP::Get, "/api/#{API_VERSION}/downtime/#{downtime_id}", true, nil, nil, false)
        rescue Exception => e
          suppress_error_if_silent e
        end
      end

      def cancel_downtime(downtime_id)
        begin
          request(Net::HTTP::Delete, "/api/#{API_VERSION}/downtime/#{downtime_id}", true, nil, nil, false)
        rescue Exception => e
          suppress_error_if_silent e
        end
      end

      def get_all_downtimes(options = {})
        begin
          extra_params = {}
          if options[:current_only]
            extra_params[:current_only] = options[:current_only]
            options.delete :current_only
          end

          request(Net::HTTP::Get, "/api/#{API_VERSION}/downtime", true, extra_params, nil, false)
        rescue Exception => e
          suppress_error_if_silent e
        end
      end

      #
      # HOST MUTING

      def mute_host(hostname, options = {})
        begin
          request(Net::HTTP::Post, "/api/#{API_VERSION}/host/#{hostname}/mute", true, nil, options, true)
        rescue Exception => e
          suppress_error_if_silent e
        end
      end
      def unmute_host(hostname)
        begin
          request(Net::HTTP::Post, "/api/#{API_VERSION}/host/#{hostname}/unmute", true, nil, {}, true)
        rescue Exception => e
          suppress_error_if_silent e
        end
      end
    end

  end
end
