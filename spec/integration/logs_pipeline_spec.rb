# Unless explicitly stated otherwise all files in this repository are licensed under the BSD-3-Clause License.
# This product includes software developed at Datadog (https://www.datadoghq.com/).
# Copyright 2011-Present Datadog, Inc.

require_relative '../spec_helper'

describe Dogapi::Client do
  LOGS_PIPELINE_ID = '42'
  LOGS_PIPELINE_NAME =  'my logs pipeline'.freeze
  LOGS_PIPELINE_FILTER = { 'query' => 'source:my-app' }.freeze

  describe '#create_logs_pipeline' do
    it_behaves_like 'an api method with options',
                    :create_logs_pipeline, [LOGS_PIPELINE_NAME, LOGS_PIPELINE_FILTER],
                    :post, '/logs/config/pipelines', 'name' => LOGS_PIPELINE_NAME,
                                                     'filter' => LOGS_PIPELINE_FILTER
  end

  describe '#get_logs_pipeline' do
    it_behaves_like 'an api method',
                    :get_logs_pipeline, [LOGS_PIPELINE_ID],
                    :get, "/logs/config/pipelines/#{LOGS_PIPELINE_ID}"
  end

  describe '#get_all_logs_pipelines' do
    it_behaves_like 'an api method',
                    :get_all_logs_pipelines, [],
                    :get, '/logs/config/pipelines'
  end

  describe '#update_logs_pipeline' do
    it_behaves_like 'an api method with options',
                    :update_logs_pipeline, [LOGS_PIPELINE_ID, LOGS_PIPELINE_NAME, LOGS_PIPELINE_FILTER],
                    :put, "/logs/config/pipelines/#{LOGS_PIPELINE_ID}", 'name' => LOGS_PIPELINE_NAME,
                                                                        'filter' => LOGS_PIPELINE_FILTER
  end

  describe '#delete_logs_pipeline' do
    it_behaves_like 'an api method',
                    :delete_logs_pipeline, [LOGS_PIPELINE_ID],
                    :delete, "/logs/config/pipelines/#{LOGS_PIPELINE_ID}"
  end
end
