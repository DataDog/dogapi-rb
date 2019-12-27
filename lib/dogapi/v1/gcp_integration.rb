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
