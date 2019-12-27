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
