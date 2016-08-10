require 'dogapi'

module Dogapi
  class V1 # for namespacing

    class AlertService < Dogapi::APIService

      API_VERSION = "v1"

      def alert(query, options = {})
        begin
          body = {
            'query' => query,
          }.merge options

          request(Net::HTTP::Post, "/api/#{API_VERSION}/alert", true, nil, body, true)
        rescue Exception => e
          suppress_error_if_silent e
        end
      end

      def update_alert(alert_id, query, options)
        begin
          body = {
            'query' => query,
          }.merge options

          request(Net::HTTP::Put, "/api/#{API_VERSION}/alert/#{alert_id}", true, nil, body, true)
        rescue Exception => e
          suppress_error_if_silent e
        end
      end

      def get_alert(alert_id)
        begin
          request(Net::HTTP::Get, "/api/#{API_VERSION}/alert/#{alert_id}", true, nil, nil, false)
        rescue Exception => e
          suppress_error_if_silent e
        end
      end

      def delete_alert(alert_id)
        begin
          request(Net::HTTP::Delete, "/api/#{API_VERSION}/alert/#{alert_id}", true, nil, nil, false)
        rescue Exception => e
          suppress_error_if_silent e
        end
      end

      def get_all_alerts
        begin
          request(Net::HTTP::Get, "/api/#{API_VERSION}/alert", true, nil, nil, false)
        rescue Exception => e
          suppress_error_if_silent e
        end
      end

      def mute_alerts
        begin
          request(Net::HTTP::Post, "/api/#{API_VERSION}/mute_alerts", true, nil, nil, false)
        rescue Exception => e
          suppress_error_if_silent e
        end
      end

      def unmute_alerts
        begin
          request(Net::HTTP::Post, "/api/#{API_VERSION}/unmute_alerts", true, nil, nil, false)
        rescue Exception => e
          suppress_error_if_silent e
        end
      end

    end

  end
end
