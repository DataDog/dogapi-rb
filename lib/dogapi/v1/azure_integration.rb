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

require 'dogapi'

module Dogapi
  class V1 # for namespacing

    # AzureIntegrationService for user interaction with Azure configs.
    class AzureIntegrationService < Dogapi::APIService

      API_VERSION = 'v1'

      # Retrieve Azure integration information
      def azure_integration_list
        request(Net::HTTP::Get, "/api/#{API_VERSION}/integration/azure", nil, nil, false)
      end

      # Delete an Azure integration
      # :config => Hash: integration config.
      # config = {
      #   :tenant_name => '<TENANT_NAME>',
      #   :client_id => '<CLIENT_ID>'
      # }
      #
      # dog = Dogapi::Client.new(api_key, app_key)
      #
      # puts dog.azure_integration_delete(config)
      def azure_integration_delete(config)
        request(Net::HTTP::Delete, "/api/#{API_VERSION}/integration/azure", nil, config, true)
      end

      # Create an Azure integration
      # :config => Hash: integration config.
      # config = {
      #   :tenant_name => '<TENANT_NAME>',
      #   :host_filters => 'new:filter',
      #   :client_id => '<CLIENT_ID>',
      #   :client_secret => '<CLIENT_SECRET>'
      # }
      #
      # dog = Dogapi::Client.new(api_key, app_key)
      #
      # puts dog.azure_integration_create(config)
      def azure_integration_create(config)
        request(Net::HTTP::Post, "/api/#{API_VERSION}/integration/azure", nil, config, true)
      end

      # Update an Azure integrations host filters
      # :config => Hash: integration config.
      # config = {
      #   :tenant_name => '<TENANT_NAME>',
      #   :host_filters => 'new:filter',
      #   :client_id => '<CLIENT_ID>'
      # }
      #
      # dog = Dogapi::Client.new(api_key, app_key)
      #
      # puts dog.azure_integration_update_host_filters(config)
      def azure_integration_update_host_filters(config)
        request(Net::HTTP::Post, "/api/#{API_VERSION}/integration/azure/host_filters", nil, config, true)
      end

      # Update a configured Azure account.
      # :config => Hash: integration config.
      # config = {
      #   :tenant_name => '<TENANT_NAME>',
      #   :new_tenant_name => '<NEW_TENANT_NAME>',
      #   :host_filters => '<KEY>:<VALUE>,<KEY>:<VALUE>',
      #   :client_id => '<CLIENT_ID>',
      #   :new_client_id => '<NEW_CLIENT_ID>'
      # }
      #
      # dog = Dogapi::Client.new(api_key, app_key)
      #
      # puts dog.azure_integration_update(config)
      def azure_integration_update(config)
        request(Net::HTTP::Put, "/api/#{API_VERSION}/integration/azure", nil, config, true)
      end

    end

  end
end
