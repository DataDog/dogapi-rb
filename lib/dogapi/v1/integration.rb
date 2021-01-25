# Unless explicitly stated otherwise all files in this repository are licensed under the BSD-3-Clause License.
# This product includes software developed at Datadog (https://www.datadoghq.com/).
# Copyright 2011-Present Datadog, Inc.

module Dogapi
  class V1 # for namespacing

    class IntegrationService < Dogapi::APIService

      API_VERSION = 'v1'

      # Create an integration
      #
      # :source_type_name => String: the name of an integration source
      # :config => Hash: integration config that varies based on the source type.
      # See https://docs.datadoghq.com/api/#integrations.
      def create_integration(source_type_name, config)
        request(Net::HTTP::Post, "/api/#{API_VERSION}/integration/#{source_type_name}", nil, config, true)
      end

      # Update an integration
      #
      # :source_type_name => String: the name of an integration source
      # :config => Hash: integration config that varies based on the source type.
      # source type (https://docs.datadoghq.com/api/#integrations)
      def update_integration(source_type_name, config)
        request(Net::HTTP::Put, "/api/#{API_VERSION}/integration/#{source_type_name}", nil, config, true)
      end

      # Retrieve integration information
      #
      # :source_type_name => String: the name of an integration source
      def get_integration(source_type_name)
        request(Net::HTTP::Get, "/api/#{API_VERSION}/integration/#{source_type_name}", nil, nil, false)
      end

      # Delete an integration
      #
      # :source_type_name => String: the name of an integration source
      def delete_integration(source_type_name)
        request(Net::HTTP::Delete, "/api/#{API_VERSION}/integration/#{source_type_name}", nil, nil, false)
      end

    end

  end
end
