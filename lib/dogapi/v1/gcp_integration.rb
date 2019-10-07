require 'dogapi'

module Dogapi
  class V1 # for namespacing

    # GcpIntegrationService for user interaction with gcp configs.
    class GcpIntegrationService < Dogapi::APIService

      API_VERSION = 'v1'

      # Retrieve gcp integration information
      def gcp_list
        request(Net::HTTP::Get, "/api/#{API_VERSION}/integration/gcp", nil, nil, false)
      end

      # Delete an gcp integration
      # :config => Hash: integration config.
    #   def delete_gcp_integration(config)
    #     request(Net::HTTP::Delete, "/api/#{API_VERSION}/integration/gcp", nil, config, true)
    #   end

      # Create an gcp integration
      # :config => Hash: integration config.
    #   def create_gcp_integration(config)
    #     request(Net::HTTP::Post, "/api/#{API_VERSION}/integration/gcp", nil, config, true)
    #   end

      # Update an gcp integrations host filters
      # :config => Hash: integration config.
    #   def update_gcp_host_filters(config)
    #     request(Net::HTTP::Post, "/api/#{API_VERSION}/integration/gcp/host_filters", nil, config, true)
    #   end

      # Update a configured gcp account.
      # :config => Hash: integration config.
    #   def update_gcp_integration(config)
    #     request(Net::HTTP::Put, "/api/#{API_VERSION}/integration/gcp", nil, config, true)
    #   end

    end

  end
end
