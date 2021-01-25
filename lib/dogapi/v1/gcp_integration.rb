# Unless explicitly stated otherwise all files in this repository are licensed under the BSD-3-Clause License.
# This product includes software developed at Datadog (https://www.datadoghq.com/).
# Copyright 2011-Present Datadog, Inc.

module Dogapi
  class V1 # for namespacing

    # GcpIntegrationService for user interaction with gcp configs.
    class GcpIntegrationService < Dogapi::APIService

      API_VERSION = 'v1'

      # Retrieve gcp integration information
      def gcp_integration_list
        request(Net::HTTP::Get, "/api/#{API_VERSION}/integration/gcp", nil, nil, false)
      end

      # Delete an gcp integration
      # :config => Hash: integration config.
      # config = {
      #   :project_id => 'datadog-sandbox',
      #   :client_email => 'email@example.com'
      # }
      #
      # dog = Dogapi::Client.new(api_key, app_key)
      #
      # puts dog.gcp_integration_delete(config)
      def gcp_integration_delete(config)
        request(Net::HTTP::Delete, "/api/#{API_VERSION}/integration/gcp", nil, config, true)
      end

      # Create an gcp integration
      # :config => Hash: integration config.
      # config = {
      #   :type => 'service_account',
      #   :project_id => '<PROJECT_ID>',
      #   :private_key_id => '<PRIVATE_KEY_ID>',
      #   :private_key => '<PRIVATE_KEY>',
      #   :client_email => '<CLIENT_EMAIL>',
      #   :client_id => '<CLIENT_ID>',
      #   :auth_uri => '<AUTH_URI>',
      #   :token_uri => '<TOKEN_URI>',
      #   :auth_provider_x509_cert_url => '<AUTH_PROVIDER_X509_CERT_URL>',
      #   :client_x509_cert_url => '<CLIENT_X509_CERT_URL>',
      #   :host_filters => '<KEY>:<VALUE>,<KEY>:<VALUE>,'
      # }
      #
      # dog = Dogapi::Client.new(api_key, app_key)
      #
      # puts dog.gcp_integration_create(config)
      def gcp_integration_create(config)
        request(Net::HTTP::Post, "/api/#{API_VERSION}/integration/gcp", nil, config, true)
      end

      # Update a configured gcp account.
      # :config => Hash: integration config.
      # config = {
      #   :project_id => '<PROJECT_ID>',
      #   :client_email => '<CLIENT_EMAIL>',
      #   :host_filters => '<KEY>:<VALUE>,<KEY>:<VALUE>,'
      #   :automute => true # takes a boolean and toggles GCE automuting
      # }
      #
      # dog = Dogapi::Client.new(api_key, app_key)
      #
      # puts dog.gcp_integration_update(config)
      def gcp_integration_update(config)
        request(Net::HTTP::Put, "/api/#{API_VERSION}/integration/gcp", nil, config, true)
      end

    end

  end
end
