require 'dogapi'

module Dogapi
  class V1 # for namespacing

    # AwsIntegrationService for user interaction with AWS configs.
    class AzureIntegrationService < Dogapi::APIService

      API_VERSION = 'v1'

      # Retrieve Azure integration information
      def azure_list
        request(Net::HTTP::Get, "/api/#{API_VERSION}/integration/azure", nil, nil, false)
      end

      # Create an AWS integration
      # :config => Hash: integration config.
    #   def create_aws_integration(config)
    #     request(Net::HTTP::Post, "/api/#{API_VERSION}/integration/aws", nil, config, true)
    #   end

      # Delete an integration
      # :config => Hash: integration config.
    #   def delete_aws_integration(config)
    #     request(Net::HTTP::Delete, "/api/#{API_VERSION}/integration/aws", nil, config, true)
    #   end

      # List available AWS namespaces
    #   def list_aws_namespaces
    #     request(Net::HTTP::Get, "/api/#{API_VERSION}/integration/aws/available_namespace_rules", nil, nil, false)
    #   end

      # Generate new AWS external ID for a specific integrated account
      # :config => Hash: integration config.
    #   def generate_external_id(config)
    #     request(Net::HTTP::Put, "/api/#{API_VERSION}/integration/aws/generate_new_external_id", nil, config, true)
    #   end

      # Update integrated AWS account
      # :config => Hash: integration config. Not working atm
    #   def update_aws_account(config)
    #     request(Net::HTTP::Put, "/api/#{API_VERSION}/integration/aws", nil, config, true)
    #   end

    end

  end
end
