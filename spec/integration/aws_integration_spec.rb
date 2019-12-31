# Unless explicitly stated otherwise all files in this repository are licensed under the BSD-3-Clause License.
# This product includes software developed at Datadog (https://www.datadoghq.com/).
# Copyright 2011-Present Datadog, Inc.

require_relative '../spec_helper'

describe Dogapi::Client do
  CONFIG = {
    account_id: '123456789101',
    role_name: 'DatadogApiTestRole'
  }.freeze

  UPDATE_CONFIG = {
    account_id: '123456789102',
    filter_tags: ['datadog:true'],
    host_tags: ['api:test'],
    role_name: 'DatadogApiTestRole'
  }.freeze

  describe '#aws_integration_create' do
    it_behaves_like 'an api method',
                    :aws_integration_create, [CONFIG],
                    :post, '/integration/aws', CONFIG
  end

  describe '#aws_integration_list' do
    it_behaves_like 'an api method',
                    :aws_integration_list, nil,
                    :get, '/integration/aws'
  end

  describe '#aws_integration_list_namespaces' do
    it_behaves_like 'an api method',
                    :aws_integration_list_namespaces, nil,
                    :get, '/integration/aws/available_namespace_rules'
  end

  describe '#aws_integration_generate_external_id' do
    it_behaves_like 'an api method',
                    :aws_integration_generate_external_id, [CONFIG],
                    :put, '/integration/aws/generate_new_external_id', CONFIG
  end

  describe '#aws_integration_update' do
    it_behaves_like 'an api method with params and body',
                    :aws_integration_update, [CONFIG, UPDATE_CONFIG],
                    :put, '/integration/aws', CONFIG, UPDATE_CONFIG
  end

  describe '#aws_integration_delete' do
    it_behaves_like 'an api method',
                    :aws_integration_delete, [CONFIG],
                    :delete, '/integration/aws', CONFIG
  end
end
