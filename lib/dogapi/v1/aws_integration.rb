# Unless explicitly stated otherwise all files in this repository are licensed under the BSD-3-Clause License.
# This product includes software developed at Datadog (https://www.datadoghq.com/).
# Copyright 2011-Present Datadog, Inc.

module Dogapi
  class V1 # for namespacing

    # AwsIntegrationService for user interaction with AWS configs.
    class AwsIntegrationService < Dogapi::APIService

      API_VERSION = 'v1'

      # Retrieve AWS integration information
      def aws_integration_list
        request(Net::HTTP::Get, "/api/#{API_VERSION}/integration/aws", nil, nil, false)
      end

      # Create an AWS integration
      # :config => Hash: integration config.
      # config = {
      #   :account_id => '<AWS_ACCOUNT>',
      #   :host_tags => ['api:example'],
      #   :role_name => '<AWS_ROLE_NAME>'
      # }
      #
      # Access Key/Secret Access Key based accounts (GovCloud and China only)
      #
      # config = {
      #   :access_key_id => '<AWS_ACCESS_KEY_ID>',
      #   :host_tags => ['api:example'],
      #   :secret_access_key => '<AWS_SECRET_ACCESS_KEY>'
      # }
      #
      # dog = Dogapi::Client.new(api_key, app_key)
      #
      # puts dog.aws_integration_create(config)
      def aws_integration_create(config)
        request(Net::HTTP::Post, "/api/#{API_VERSION}/integration/aws", nil, config, true)
      end

      # Delete an integration
      # :config => Hash: integration config.
      # config = {
      #   :account_id => '<AWS_ACCOUNT>',
      #   :role_name => '<AWS_ROLE_NAME>'
      # }
      # Access Key/Secret Access Key based accounts (GovCloud and China only)
      #
      # config = {
      #   :access_key_id => '<AWS_ACCESS_KEY_ID>',
      # }
      #
      # dog = Dogapi::Client.new(api_key, app_key)
      #
      # puts dog.aws_integration_delete(config)
      def aws_integration_delete(config)
        request(Net::HTTP::Delete, "/api/#{API_VERSION}/integration/aws", nil, config, true)
      end

      # List available AWS namespaces
      def aws_integration_list_namespaces
        request(Net::HTTP::Get, "/api/#{API_VERSION}/integration/aws/available_namespace_rules", nil, nil, false)
      end

      # Generate new AWS external ID for a specific integrated account
      # :config => Hash: integration config.
      # config = {
      #   :account_id => '<AWS_ACCOUNT>',
      #   :role_name => '<AWS_ROLE_NAME>'
      # }
      #
      # dog = Dogapi::Client.new(api_key, app_key)
      #
      # puts dog.aws_integration_generate_external_id(config)
      def aws_integration_generate_external_id(config)
        request(Net::HTTP::Put, "/api/#{API_VERSION}/integration/aws/generate_new_external_id", nil, config, true)
      end

      # Update integrated AWS account.
      # :config => Hash: integration config.
      # config = {
      #   "account_id": '<EXISTING_AWS_ACCOUNT>',
      #   "role_name": '<EXISTING_AWS_ROLE_NAME>'
      # }
      #
      # new_config = {
      #   "account_id": '<NEW_AWS_ACCOUNT>',
      #   "host_tags": ['tag:example1,tag:example2'],
      #   "filter_tags": ['datadog:true']
      # }
      #
      # Access Key/Secret Access Key based accounts (GovCloud and China only)
      #
      # config = {
      #   "access_key_id": '<EXISTING_ACCESS_KEY_ID>',
      #   "secret_access_key": '<EXISTING_SECRET_ACCESS_KEY>'
      # }
      #
      # new_config = {
      #   "access_key_id": '<NEW_ACCESS_KEY_ID>',
      #   "host_tags": ['new:tags'],
      #   "filter_tags": ['datadog:true']
      # }
      #
      # dog = Dogapi::Client.new(api_key, app_key)

      # puts dog.aws_integration_update(config, new_config)
      def aws_integration_update(config, new_config)
        request(Net::HTTP::Put, "/api/#{API_VERSION}/integration/aws", config, new_config, true)
      end

    end

  end
end
