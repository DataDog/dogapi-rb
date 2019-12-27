# Copyright (c) 2010-2020, Datadog <opensource@datadoghq.com>
#
# Redistribution and use in source and binary forms, with or without modification, are permitted provided that the
# following conditions are met:
#
# 1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following
# disclaimer.
#
# 2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following
# disclaimer in the documentation and/or other materials provided with the distribution.
#
# 3. Neither the name of the copyright holder nor the names of its contributors may be used to endorse or promote
# products derived from this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES,
# INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
# SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
# SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
# WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

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

  describe '#azure_integration_list' do
    it_behaves_like 'an api method',
                    :azure_integration_list, nil,
                    :get, '/integration/azure'
  end

  describe '#azure_integration_create' do
    it_behaves_like 'an api method',
                    :azure_integration_create, [CREATE_CONFIG],
                    :post, '/integration/azure', CREATE_CONFIG
  end

  describe '#azure_integration_update_host_filters' do
    it_behaves_like 'an api method',
                    :azure_integration_update_host_filters, [UPDATE_HF_CONFIG],
                    :post, '/integration/azure/host_filters', UPDATE_HF_CONFIG
  end

  describe '#azure_integration_update' do
    it_behaves_like 'an api method',
                    :azure_integration_update, [UPDATE_CONFIG],
                    :put, '/integration/azure', UPDATE_CONFIG
  end

  describe '#azure_integration_delete' do
    it_behaves_like 'an api method',
                    :azure_integration_delete, [CONFIG],
                    :delete, '/integration/azure', CONFIG
  end
end
