require_relative '../spec_helper'

describe Dogapi::Client do
  CONFIG = {
    project_id: "datadog-apitest",
    client_email: "email@example.com",
  }.freeze

  CREATE_CONFIG = {
    type: "service_account",
    project_id: "datadog-apitest",
    private_key_id: "123456789abcdefghi123456789abcdefghijklm",
    private_key: "fake_key",
    client_email: "email@example.com",
    client_id: "123456712345671234567",
    auth_uri: "fake_uri",
    token_uri: "fake_uri",
    auth_provider_x509_cert_url: "fake_url",
    client_x509_cert_url: "fake_url",
    host_filters: "api:test"
  }.freeze

  UPDATE_CONFIG = {
    project_id: "datadog-apitest",
    client_email: "email@example.com",
    host_filters: "api:test1,api:test2",
    automute: false
  }.freeze

  describe '#gcp_list' do
    it_behaves_like 'an api method',
                    :gcp_list, nil,
                    :get, "/integration/gcp"
  end

  describe '#create_gcp_integration' do
    it_behaves_like 'an api method',
                    :create_gcp_integration, [CREATE_CONFIG],
                    :post, "/integration/gcp", CREATE_CONFIG
  end

  describe '#update_gcp_integration' do
    it_behaves_like 'an api method',
                    :update_gcp_integration, [UPDATE_CONFIG],
                    :put, "/integration/gcp", UPDATE_CONFIG
  end

  describe '#delete_gcp_integration' do
    it_behaves_like 'an api method',
                    :delete_gcp_integration, [CONFIG],
                    :delete, "/integration/gcp", CONFIG
  end
end
