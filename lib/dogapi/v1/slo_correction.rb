require 'dogapi'

module Dogapi
  class V1 # for namespacing

    # Implements Service Level Objectives correction endpoints.
    class SLOCorrectionService < Dogapi::APIService
      API_VERSION = 'v1'

      def get_all_slo_corrections
        request(Net::HTTP::Get, "/api/#{API_VERSION}/slo/#{slo_correction_id}", nil, nil, false)
      end

      # Get an SLO correction object for a given SLO correction id.
      #
      # URL:
      #     GET /api/v1/slo/correction/{slo_correction_id}
      #
      # Response:
      #     {
      #         "data": {
      #             "type": "correction",
      #             "id": "<public_id>",
      #             "attributes": {
      #                 "slo_id": <slo_id>,
      #                 "creator": {
      #                     "data": {
      #                         "type": "users",
      #                         "id": "<uuid>",
      #                         "attributes": {
      #                             "uuid": "<uuid>"
      #                         }
      #                     }
      #                 }
      #             }
      #         }
      #     }
      def get_slo_correction(slo_correction_id)
        request(Net::HTTP::Get, "/api/#{API_VERSION}/slo/correction/#{slo_correction_id}", nil, nil, false)
      end

      def create_slo_correction(slo_id, timezone, category, options = {})
        body = {
          slo_id: slo_id,
          timezone: timezone,
          category: category
        }

        symbolized_options = Dogapi.symbolized_access(options)
        [:description, :start_dt, :end_dt, :creator_uuid].each do |a|
          body[a] = symbolized_options[a] if symbolized_options[a]
        end

        request(Net::HTTP::Post, "/api/#{API_VERSION}/slo/correction", nil, body, true)
      end

      def update_slo_correction(slo_correction_id, options = {})
        body = {}

        symbolized_options = Dogapi.symbolized_access(options)
        [:description, :start_dt, :end_dt, :category, :timezone, :creator_uuid].each do |a|
          body[a] = symbolized_options[a] if symbolized_options[a]
        end

        request(Net::HTTP::Put, "/api/#{API_VERSION}/slo/#{slo_correction_id}", nil, body, true)
      end

      def delete_slo_correction(slo_correction_id)
        request(Net::HTTP::Delete, "/api/#{API_VERSION}/slo/#{slo_correction_id}", nil, nil, false)
      end
    end
  end
end
