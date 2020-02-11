require_relative '../spec_helper'

describe Dogapi::Client do
  SLO_ID = '42424242424242424242424242424242'.freeze
  SLO_TYPE = 'metric'.freeze
  SLO_NAME = 'test slo'.freeze
  SLO_DESCRIPTION = 'test slo description'.freeze
  SLO_QUERY_NUMERATOR = 'sum:test.metric.metric{type:good}.as_count()'.freeze
  SLO_QUERY_DENOMINATOR = 'sum:test.metric.metric{*}.as_count()'.freeze
  SLO_TAGS = ['type:test'].freeze
  SLO_THRESHOLDS = [{ timeframe: '7d', target: 90 }, { timeframe: '30d', target: 95 }].freeze

  describe '#create_service_level_objective' do
    it_behaves_like 'an api method',
                    :create_service_level_objective, [SLO_TYPE, SLO_NAME, SLO_THRESHOLDS, {
                      description: SLO_DESCRIPTION,
                      tags: SLO_TAGS,
                      numerator: SLO_QUERY_NUMERATOR,
                      denominator: SLO_QUERY_DENOMINATOR
                    }],
                    :post, '/slo', 'type' => SLO_TYPE, 'name' => SLO_NAME, 'thresholds' => SLO_THRESHOLDS,
                                   'query' => { numerator: SLO_QUERY_NUMERATOR, denominator: SLO_QUERY_DENOMINATOR },
                                   'tags' => SLO_TAGS, 'description' => SLO_DESCRIPTION
  end

  describe '#update_service_level_objective' do
    it_behaves_like 'an api method',
                    :update_service_level_objective, [SLO_ID, SLO_TYPE, { name: SLO_NAME }],
                    :put, "/slo/#{SLO_ID}", 'type' => SLO_TYPE, 'name' => SLO_NAME
  end

  describe '#get_service_level_objective' do
    it_behaves_like 'an api method',
                    :get_service_level_objective, [SLO_ID],
                    :get, "/slo/#{SLO_ID}"
  end

  describe '#get_service_level_objective_history' do
    it_behaves_like 'an api method with params',
                    :get_service_level_objective_history, [SLO_ID],
                    :get, "/slo/#{SLO_ID}/history", 'from_ts' => 0, 'to_ts' => 1_000_000
  end

  describe '#can_delete_service_level_objective' do
    it_behaves_like 'an api method with params',
                    :can_delete_service_level_objective, [],
                    :get, '/slo/can_delete', 'ids' => [SLO_ID]
  end

  describe '#search_service_level_objective' do
    it_behaves_like 'an api method with optional params',
                    :search_service_level_objective, [[SLO_ID]],
                    :get, '/slo/', 'ids' => SLO_ID
  end

  describe '#delete_service_level_objective' do
    it_behaves_like 'an api method',
                    :delete_service_level_objective, [SLO_ID],
                    :delete, "/slo/#{SLO_ID}"
  end

  describe '#delete_many_service_level_objective' do
    it_behaves_like 'an api method',
                    :delete_many_service_level_objective, [[SLO_ID]],
                    :delete, '/slo/', 'ids' => [SLO_ID]
  end

  describe '#delete_timeframes_service_level_objective' do
    it_behaves_like 'an api method',
                    :delete_timeframes_service_level_objective, [{ SLO_ID => ['7d'] }],
                    :post, '/slo/bulk_delete', SLO_ID => ['7d']
  end
end
