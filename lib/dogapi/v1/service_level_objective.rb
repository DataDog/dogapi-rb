require 'dogapi'

module Dogapi
  class V1 # for namespacing

    # Implements Service Level Objectives endpoints
    class ServiceLevelObjectiveService < Dogapi::APIService

      API_VERSION = 'v1'

      def create_service_level_objective(type, name, description = nil, tags = nil, thresholds = nil, numerator = nil,
                                         denominator = nil, monitor_ids = nil, monitor_search = nil, groups = nil)
        body = {
          type: type,
          name: name,
          thresholds: thresholds
        }
        if type == 'metric'
          body[:query] = {
            numerator: numerator,
            denominator: denominator
          }
        else
          body[:monitor_search] = monitor_search unless monitor_search.nil?
          body[:monitor_ids] = monitor_ids unless monitor_ids.nil?
          body[:groups] = groups unless groups.nil?
        end
        body[:tags] = tags unless tags.nil?
        body[:description] = description unless description.nil?

        request(Net::HTTP::Post, "/api/#{API_VERSION}/slo", nil, body, true)
      end

      def update_service_level_objective(slo_id, type, name = nil, description = nil, tags = nil, thresholds = nil,
                                         numerator = nil, denominator = nil, monitor_ids = nil, monitor_search = nil,
                                         groups = nil)
        body = {
          type: type
        }

        body[:name] = name unless name.nil?

        body[:thresholds] = thresholds unless thresholds.nil?

        if type == 'metric'
          if !numerator.nil? && !denominator.nil?
            body[:query] = {
              numerator: numerator,
              denominator: denominator
            }
          end
        else
          body[:monitor_search] = monitor_search unless monitor_search.nil?
          body[:monitor_ids] = monitor_ids unless monitor_ids.nil?
          body[:groups] = groups unless groups.nil?
        end
        body[:tags] = tags unless tags.nil?
        body[:description] = description unless description.nil?

        request(Net::HTTP::Put, "/api/#{API_VERSION}/slo/#{slo_id}", nil, body, true)
      end

      def get_service_level_objective(slo_id)
        request(Net::HTTP::Get, "/api/#{API_VERSION}/slo/#{slo_id}", nil, nil, false)
      end

      def search_service_level_objective(slo_ids = nil, query = nil, offset = nil, limit = nil)
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

    end
  end
end
