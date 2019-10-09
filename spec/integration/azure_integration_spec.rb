require_relative '../spec_helper'

describe Dogapi::Client do
  CONFIG = {
    tenant_name: 'testc44-1234-5678-9101-cc00736ftest',
    client_id: 'testc7f6-1234-5678-9101-3fcbf464test'
  }.freeze

  CREATE_CONFIG = {
    tenant_name: 'testc44-1234-5678-9101-cc00736ftest',
    host_filters: 'api:test',
    client_id: 'testc7f6-1234-5678-9101-3fcbf464test',
    client_secret: 'testingx./Sw*g/Y33t..R1cH+hScMDt'
  }.freeze

  UPDATE_HF_CONFIG = {
    tenant_name: 'testc44-1234-5678-9101-cc00736ftest',
    host_filters: 'api:test1,api:test2',
    client_id: 'testc7f6-1234-5678-9101-3fcbf464test'
  }.freeze

  UPDATE_CONFIG = {
    tenant_name: 'testc44-1234-5678-9101-cc00736ftest',
    new_tenant_name: '1234abcd-1234-5678-9101-abcd1234abcd',
    host_filters: 'api:test3',
    client_id: 'testc7f6-1234-5678-9101-3fcbf464test',
    new_client_id: 'abcd1234-5678-1234-5678-1234abcd5678'
  }.freeze

  describe '#azure_list' do
    it_behaves_like 'an api method',
                    :azure_list, nil,
                    :get, "/integration/azure"
  end

  describe '#create_azure_integration' do
    it_behaves_like 'an api method',
                    :create_azure_integration, [CREATE_CONFIG],
                    :post, "/integration/azure", CREATE_CONFIG
  end

  describe '#update_azure_host_filters' do
    it_behaves_like 'an api method',
                    :update_azure_host_filters, [UPDATE_HF_CONFIG],
                    :post, "/integration/azure/host_filters", UPDATE_HF_CONFIG
  end

  describe '#update_azure_integration' do
    it_behaves_like 'an api method',
                    :update_azure_integration, [UPDATE_CONFIG],
                    :put, "/integration/azure", UPDATE_CONFIG
  end

  describe '#delete_azure_integration' do
    it_behaves_like 'an api method',
                    :delete_azure_integration, [CONFIG],
                    :delete, "/integration/azure", CONFIG
  end
end
