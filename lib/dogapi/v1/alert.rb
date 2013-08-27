require 'dogapi'

module Dogapi
  class V1 # for namespacing

    class AlertService < Dogapi::APIService

      API_VERSION = "v1"

      def alert(query, options = {})
        begin
          params = {
            :api_key => @api_key,
            :application_key => @application_key
          }

          body = {
            'query' => query,
          }.merge options

          request(Net::HTTP::Post, "/api/#{API_VERSION}/alert", params, body, true)
        rescue Exception => e
          suppress_error_if_silent e
        end
      end

      def update_alert(alert_id, query, options)
        begin
          params = {
            :api_key => @api_key,
            :application_key => @application_key
          }

          body = {
            'query' => query,
          }.merge options

          request(Net::HTTP::Put, "/api/#{API_VERSION}/alert/#{alert_id}", params, body, true)
        rescue Exception => e
          suppress_error_if_silent e
        end
      end

      def get_alert(alert_id)
        begin
          params = {
            :api_key => @api_key,
            :application_key => @application_key
          }

          request(Net::HTTP::Get, "/api/#{API_VERSION}/alert/#{alert_id}", params, nil, false)
        rescue Exception => e
          suppress_error_if_silent e
        end
      end

      def delete_alert(alert_id)
        begin
          params = {
            :api_key => @api_key,
            :application_key => @application_key
          }

          request(Net::HTTP::Delete, "/api/#{API_VERSION}/alert/#{alert_id}", params, nil, false)
        rescue Exception => e
          suppress_error_if_silent e
        end
      end

      def get_all_alerts()
        begin
          params = {
            :api_key => @api_key,
            :application_key => @application_key
          }

          request(Net::HTTP::Get, "/api/#{API_VERSION}/alert", params, nil, false)
        rescue Exception => e
          suppress_error_if_silent e
        end
      end

      def mute_alerts()
        begin
          params = {
            :api_key => @api_key,
            :application_key => @application_key
          }

          request(Net::HTTP::Post, "/api/#{API_VERSION}/mute_alerts", params, nil, false)
        rescue Exception => e
          suppress_error_if_silent e
        end
      end

      def unmute_alerts()
        begin
          params = {
            :api_key => @api_key,
            :application_key => @application_key
          }

          request(Net::HTTP::Post, "/api/#{API_VERSION}/unmute_alerts", params, nil, false)
        rescue Exception => e
          suppress_error_if_silent e
        end
      end

    end

  end
end
