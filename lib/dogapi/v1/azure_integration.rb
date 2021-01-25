# Unless explicitly stated otherwise all files in this repository are licensed under the BSD-3-Clause License.
# This product includes software developed at Datadog (https://www.datadoghq.com/).
# Copyright 2011-Present Datadog, Inc.

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
