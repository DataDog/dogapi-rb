require 'dogapi'

module Dogapi
  class V1 # for namespacing

    class ServiceLevelObjectiveService < Dogapi::APIService

      API_VERSION = 'v1'

      def create_service_level_objective(type, name, description=nil, tags = nil, thresholds=nil, numerator=nil, denominator=nil, monitor_ids=nil, monitor_search=nil)
        body = {
            :type => type,
            :name => name,
            :thresholds => thresholds,
        }
        if type == 'metric'
          body[:query] = {
              :numerator => numerator,
              :denominator => denominator,
          }
        else
          if !monitor_search.nil?
            body[:monitor_search] = monitor_search
          else
            body[:monitor_ids] = monitor_ids
          end
        end
        if !tags.nil?
          body[:tags] = tags
        end
        if !description.nil?
          body[:description] = description
        end

        request(Net::HTTP::Post, "/api/#{API_VERSION}/slo", nil, body, true)
      end

      def update_service_level_objective(slo_id, type, name=nil, description=nil, tags = nil, thresholds=nil, numerator=nil, denominator=nil, monitor_ids=nil, monitor_search=nil)
        body = {
            :type => type,

        }

        if !name.nil?
          body[:name] = name
        end

        if !thresholds.nil?
          body[:thresholds] = thresholds
        end

        if type == 'metric'
          body[:query] = {
              :numerator => numerator,
              :denominator => denominator,
          }
        else
          if !monitor_search.nil?
            body[:monitor_search] = monitor_search
          else
            body[:monitor_ids] = monitor_ids
          end
        end
        if !tags.nil?
          body[:tags] = tags
        end
        if !description.nil?
          body[:description] = description
        end

        request(Net::HTTP::Put, "/api/#{API_VERSION}/slo/#{slo_id}", nil, body, true)
      end

      def get_service_level_objective(slo_id)
        request(Net::HTTP::Get, "/api/#{API_VERSION}/slo/#{slo_id}", nil, nil, false)
      end

      def search_service_level_objective(slo_ids=nil, query=nil, offset=0, limit=100)
        params = {
            :offset => offset,
            :limit => limit
        }
        if !slo_ids.nil?
          params[:ids] = slo_ids
        else
          params[:query] = query
        end

        request(Net::HTTP::Get, "/api/#{API_VERSION}/slo/", params, nil, false)
      end

      def delete_service_level_objective(slo_id)
        request(Net::HTTP::Delete, "/api/#{API_VERSION}/slo/#{slo_id}", nil, nil, false)
      end

      def delete_many_service_level_objective(slo_ids)
        body = [
            :ids => slo_ids
        ]
        request(Net::HTTP::Delete, "/api/#{API_VERSION}/slo/", nil, body, true)
      end

      def delete_timeframes_service_level_objective(ops)
        # ops is a hash of slo_id: [<timeframe>] to delete
        request(Net::HTTP::POST, "/api/#{API_VERSION}/slo/bulk_delete", nil, ops, true)
      end

    end
  end
end

