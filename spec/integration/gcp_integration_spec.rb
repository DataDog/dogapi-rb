# Unless explicitly stated otherwise all files in this repository are licensed under the BSD-3-Clause License.
# This product includes software developed at Datadog (https://www.datadoghq.com/).
# Copyright 2011-Present Datadog, Inc.

require_relative '../spec_helper'

describe Dogapi::Client do
  CONFIG = {
    project_id: 'datadog-apitest',
    client_email: 'email@example.com'
  }.freeze

  CREATE_CONFIG = {
    type: 'service_account',
    project_id: 'datadog-apitest',
    private_key_id: '123456789abcdefghi123456789abcdefghijklm',
    private_key: 'fake_key',
    client_email: 'email@example.com',
    client_id: '123456712345671234567',
    auth_uri: 'fake_uri',
    token_uri: 'fake_uri',
    auth_provider_x509_cert_url: 'fake_url',
    client_x509_cert_url: 'fake_url',
    host_filters: 'api:test'
  }.freeze

  UPDATE_CONFIG = {
    project_id: 'datadog-apitest',
    client_email: 'email@example.com',
    host_filters: 'api:test1,api:test2',
    automute: false
  }.freeze

  describe '#gcp_integration_list' do
    it_behaves_like 'an api method',
                    :gcp_integration_list, nil,
                    :get, '/integration/gcp'
  end

  describe '#gcp_integration_create' do
    it_behaves_like 'an api method',
                    :gcp_integration_create, [CREATE_CONFIG],
                    :post, '/integration/gcp', CREATE_CONFIG
  end

  describe '#gcp_integration_update' do
    it_behaves_like 'an api method',
                    :gcp_integration_update, [UPDATE_CONFIG],
                    :put, '/integration/gcp', UPDATE_CONFIG
  end

  describe '#gcp_integration_delete' do
    it_behaves_like 'an api method',
                    :gcp_integration_delete, [CONFIG],
                    :delete, '/integration/gcp', CONFIG
  end
end
