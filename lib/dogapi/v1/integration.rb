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
