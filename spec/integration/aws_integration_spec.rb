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

  describe '#create_aws_integration' do
    it_behaves_like 'an api method',
                    :create_aws_integration, [CONFIG],
                    :post, "/integration/aws", CONFIG
  end

  describe '#aws_list' do
    it_behaves_like 'an api method',
                    :aws_list, nil,
                    :get, "/integration/aws"
  end

  describe '#list_aws_namespaces' do
    it_behaves_like 'an api method',
                    :list_aws_namespaces, nil,
                    :get, "/integration/aws/available_namespace_rules"
  end

  describe '#generate_external_id' do
    it_behaves_like 'an api method',
                    :generate_external_id, [CONFIG],
                    :put, "/integration/aws/generate_new_external_id", CONFIG
  end

  describe '#update_aws_account' do
    it_behaves_like 'an api method with params and body',
                    :update_aws_account, [CONFIG, UPDATE_CONFIG],
                    :put, "/integration/aws", CONFIG, UPDATE_CONFIG
  end

  describe '#delete_aws_integration' do
    it_behaves_like 'an api method',
                    :delete_aws_integration, [CONFIG],
                    :delete, "/integration/aws", CONFIG
  end
end
