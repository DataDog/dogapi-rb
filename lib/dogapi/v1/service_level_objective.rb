# Unless explicitly stated otherwise all files in this repository are licensed under the BSD-3-Clause License.
# This product includes software developed at Datadog (https://www.datadoghq.com/).
# Copyright 2011-Present Datadog, Inc.

module Dogapi
  class V1 # for namespacing

    # Implements Service Level Objectives endpoints
    class ServiceLevelObjectiveService < Dogapi::APIService

      API_VERSION = 'v1'

      def create_service_level_objective(type, slo_name, thresholds, options = {})
        body = {
          type: type,
          name: slo_name,
          thresholds: thresholds
        }

        symbolized_options = Dogapi.symbolized_access(options)
        if type.to_s == 'metric'
          body[:query] = {
            numerator: symbolized_options[:numerator],
            denominator: symbolized_options[:denominator]
          }
        else
          body[:monitor_search] = symbolized_options[:monitor_search] if symbolized_options[:monitor_search]
          body[:monitor_ids] = symbolized_options[:monitor_ids] if symbolized_options[:monitor_ids]
          body[:groups] = symbolized_options[:groups] if symbolized_options[:groups]
        end
        body[:tags] = symbolized_options[:tags] if symbolized_options[:tags]
        body[:description] = symbolized_options[:description] if symbolized_options[:description]

        request(Net::HTTP::Post, "/api/#{API_VERSION}/slo", nil, body, true)
      end

      def update_service_level_objective(slo_id, type, options = {})
        body = {
          type: type
        }

        symbolized_options = Dogapi.symbolized_access(options)
        if type == 'metric'
          if symbolized_options[:numerator] && symbolized_options[:denominator]
            body[:query] = {
              numerator: symbolized_options[:numerator],
              denominator: symbolized_options[:denominator]
            }
          end
        else
          body[:monitor_search] = symbolized_options[:monitor_search] if symbolized_options[:monitor_search]
          body[:monitor_ids] = symbolized_options[:monitor_ids] if symbolized_options[:monitor_ids]
          body[:groups] = symbolized_options[:groups] if symbolized_options[:groups]
        end
        [:name, :thresholds, :tags, :description].each do |a|
          body[a] = symbolized_options[a] if symbolized_options[a]
        end

        request(Net::HTTP::Put, "/api/#{API_VERSION}/slo/#{slo_id}", nil, body, true)
      end

      def get_service_level_objective(slo_id)
        request(Net::HTTP::Get, "/api/#{API_VERSION}/slo/#{slo_id}", nil, nil, false)
      end

      def search_service_level_objective(slo_ids, query, offset, limit)
        params = {}
        params[:offset] = offset unless offset.nil?
        params[:limit] = limit unless limit.nil?
        if !slo_ids.nil?
          params[:ids] = slo_ids.join(',')
        else
          params[:query] = query
        end

        request(Net::HTTP::Get, "/api/#{API_VERSION}/slo/", params, nil, false)
      end

      def delete_service_level_objective(slo_id)
        request(Net::HTTP::Delete, "/api/#{API_VERSION}/slo/#{slo_id}", nil, nil, false)
      end

      def delete_many_service_level_objective(slo_ids)
        body = {
          ids: slo_ids
        }
        request(Net::HTTP::Delete, "/api/#{API_VERSION}/slo/", nil, body, true)
      end

      def delete_timeframes_service_level_objective(ops)
        # ops is a hash of slo_id: [<timeframe>] to delete
        request(Net::HTTP::Post, "/api/#{API_VERSION}/slo/bulk_delete", nil, ops, true)
      end

      def get_service_level_objective_history(slo_id, from_ts, to_ts)
        params = {
          from_ts: from_ts,
          to_ts: to_ts
        }
        request(Net::HTTP::Get, "/api/#{API_VERSION}/slo/#{slo_id}/history", params, nil, false)
      end

      def can_delete_service_level_objective(slo_ids)
        params = {}
        params[:ids] = if slo_ids.is_a? Array
                         slo_ids.join(',')
                       else
                         slo_ids
                       end
        request(Net::HTTP::Get, "/api/#{API_VERSION}/slo/can_delete", params, nil, false)
      end

    end
  end
end
