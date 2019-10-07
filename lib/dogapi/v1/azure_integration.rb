require 'dogapi'

module Dogapi
  class V1 # for namespacing

    # AzureIntegrationService for user interaction with Azure configs.
    class AzureIntegrationService < Dogapi::APIService

      API_VERSION = 'v1'

      # Retrieve Azure integration information
      def azure_list
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
      # puts dog.delete_azure_integration(config)
      def delete_azure_integration(config)
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
      # puts dog.create_azure_integration(config)
      def create_azure_integration(config)
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
      # puts dog.update_azure_host_filters(config)
      def update_azure_host_filters(config)
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
      # puts dog.update_azure_integration(config)
      def update_azure_integration(config)
        request(Net::HTTP::Put, "/api/#{API_VERSION}/integration/azure", nil, config, true)
      end

    end

  end
end
