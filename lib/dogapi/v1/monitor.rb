require 'dogapi'

module Dogapi
  class V1 # for namespacing

    class MonitorService < Dogapi::APIService

      API_VERSION = 'v1'

      def monitor(type, query, options = {})
        begin
          params = {
            :api_key => @api_key,
            :application_key => @application_key
          }

          body = {
            'type' => type,
            'query' => query,
          }.merge options

          request(Net::HTTP::Post, "/api/#{API_VERSION}/monitor", params, body, true)
        rescue Exception => e
          suppress_error_if_silent e
        end
      end

      def update_monitor(monitor_id, query, options)
        begin
          params = {
            :api_key => @api_key,
            :application_key => @application_key
          }

          body = {
            'query' => query,
          }.merge options

          request(Net::HTTP::Put, "/api/#{API_VERSION}/monitor/#{monitor_id}", params, body, true)
        rescue Exception => e
          suppress_error_if_silent e
        end
      end

      def get_monitor(monitor_id, options = {})
        begin
          params = {
            :api_key => @api_key,
            :application_key => @application_key
          }

          # :group_states is an optional list of statuses to filter returned
          # groups. If no value is given then no group states will be returned.
          # Possible values are: "all", "ok", "warn", "alert", "no data".
          if options[:group_states]
            params[:group_states] = options[:group_states].join(',')
            options.delete :group_states
          end

          request(Net::HTTP::Get, "/api/#{API_VERSION}/monitor/#{monitor_id}", params, nil, false)
        rescue Exception => e
          suppress_error_if_silent e
        end
      end

      def delete_monitor(monitor_id)
        begin
          params = {
            :api_key => @api_key,
            :application_key => @application_key
          }

          request(Net::HTTP::Delete, "/api/#{API_VERSION}/monitor/#{monitor_id}", params, nil, false)
        rescue Exception => e
          suppress_error_if_silent e
        end
      end

      def get_all_monitors(options = {})
        begin
          params = {
            :api_key => @api_key,
            :application_key => @application_key
          }

          # :group_states is an optional list of statuses to filter returned
          # groups. If no value is given then no group states will be returned.
          # Possible values are: "all", "ok", "warn", "alert", "no data".
          if options[:group_states]
            params[:group_states] = options[:group_states].join(',')
            options.delete :group_states
          end

          request(Net::HTTP::Get, "/api/#{API_VERSION}/monitor", params, nil, false)
        rescue Exception => e
          suppress_error_if_silent e
        end
      end

      def mute_monitors()
        begin
          params = {
            :api_key => @api_key,
            :application_key => @application_key
          }

          request(Net::HTTP::Post, "/api/#{API_VERSION}/monitor/mute_all", params, nil, false)
        rescue Exception => e
          suppress_error_if_silent e
        end
      end

      def unmute_monitors()
        begin
          params = {
            :api_key => @api_key,
            :application_key => @application_key
          }

          request(Net::HTTP::Post, "/api/#{API_VERSION}/monitor/unmute_all", params, nil, false)
        rescue Exception => e
          suppress_error_if_silent e
        end
      end

      def mute_monitor(monitor_id, options = {})
        begin
          params = {
            :api_key => @api_key,
            :application_key => @application_key
          }

          request(Net::HTTP::Post, "/api/#{API_VERSION}/monitor/#{monitor_id}/mute", params, options, true)
        rescue Exception => e
          suppress_error_if_silent e
        end
      end

      def unmute_monitor(monitor_id, options = {})
        begin
          params = {
            :api_key => @api_key,
            :application_key => @application_key
          }

          request(Net::HTTP::Post, "/api/#{API_VERSION}/monitor/#{monitor_id}/unmute", params, options, true)
        rescue Exception => e
          suppress_error_if_silent e
        end
      end

      #
      # DOWNTIMES

      def schedule_downtime(scope, start, options = {})
        begin
          params = {
            :api_key => @api_key,
            :application_key => @application_key
          }

          body = {
            'scope' => scope,
            'start' => start
          }.merge options

          request(Net::HTTP::Post, "/api/#{API_VERSION}/downtime", params, body, true)
        rescue Exception => e
          suppress_error_if_silent e
        end
      end

      def update_downtime(downtime_id, options = {})
        begin
          params = {
            :api_key => @api_key,
            :application_key => @application_key
          }

          request(Net::HTTP::Put, "/api/#{API_VERSION}/downtime/#{downtime_id}", params, options, true)
        rescue Exception => e
          suppress_error_if_silent e
        end
      end

      def get_downtime(downtime_id)
        begin
          params = {
            :api_key => @api_key,
            :application_key => @application_key
          }

          request(Net::HTTP::Get, "/api/#{API_VERSION}/downtime/#{downtime_id}", params, nil, false)
        rescue Exception => e
          suppress_error_if_silent e
        end
      end

      def cancel_downtime(downtime_id)
        begin
          params = {
            :api_key => @api_key,
            :application_key => @application_key
          }

          request(Net::HTTP::Delete, "/api/#{API_VERSION}/downtime/#{downtime_id}", params, nil, false)
        rescue Exception => e
          suppress_error_if_silent e
        end
      end

      def get_all_downtimes(options = {})
        begin
          params = {
            :api_key => @api_key,
            :application_key => @application_key
          }

          if options[:current_only]
            params[:current_only] = options[:current_only]
            options.delete :current_only
          end

          request(Net::HTTP::Get, "/api/#{API_VERSION}/downtime", params, nil, false)
        rescue Exception => e
          suppress_error_if_silent e
        end
      end

    end

  end
end
