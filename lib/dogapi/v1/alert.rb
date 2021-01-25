# Unless explicitly stated otherwise all files in this repository are licensed under the BSD-3-Clause License.
# This product includes software developed at Datadog (https://www.datadoghq.com/).
# Copyright 2011-Present Datadog, Inc.

module Dogapi
  class V1 # for namespacing

    class AlertService < Dogapi::APIService

      API_VERSION = 'v1'

      def alert(query, options = {})
        body = {
          'query' => query,
        }.merge options

        request(Net::HTTP::Post, "/api/#{API_VERSION}/alert", nil, body, true)
      end

      def update_alert(alert_id, query, options)
        body = {
          'query' => query,
        }.merge options

        request(Net::HTTP::Put, "/api/#{API_VERSION}/alert/#{alert_id}", nil, body, true)
      end

      def get_alert(alert_id)
        request(Net::HTTP::Get, "/api/#{API_VERSION}/alert/#{alert_id}", nil, nil, false)
      end

      def delete_alert(alert_id)
        request(Net::HTTP::Delete, "/api/#{API_VERSION}/alert/#{alert_id}", nil, nil, false)
      end

      def get_all_alerts
        request(Net::HTTP::Get, "/api/#{API_VERSION}/alert", nil, nil, false)
      end

      def mute_alerts
        request(Net::HTTP::Post, "/api/#{API_VERSION}/mute_alerts", nil, nil, false)
      end

      def unmute_alerts
        request(Net::HTTP::Post, "/api/#{API_VERSION}/unmute_alerts", nil, nil, false)
      end

    end

  end
end
