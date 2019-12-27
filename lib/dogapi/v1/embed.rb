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

    # ================
    #    EMBED API
    # ================
    class EmbedService < Dogapi::APIService

      API_VERSION = 'v1'

      # Get all embeds for the API user's org
      def get_all_embeds()
        request(Net::HTTP::Get, "/api/#{API_VERSION}/graph/embed", nil, nil, false)
      end

      # Get a specific embed
      #
      # :embed_id       => String: embed token for a specific embed
      # :size           => String: "small", "medium"(defualt), "large", or "xlarge".
      # :legend         => String: "yes" or "no"(default)
      # :template_vars  => String: variable name => variable value (any number of template vars)
      def get_embed(embed_id, description= {})
        request(Net::HTTP::Get, "/api/#{API_VERSION}/graph/embed/#{embed_id}", description, nil, false)
      end

      # Create an embeddable graph
      #
      # :graph_json  => JSON: graph definition
      # :timeframe   => String: representing the interval of the graph. Default is "1_hour"
      # :size        => String: representing the size of the graph. Default is "medium".
      # :legend      => String: flag representing whether a legend is displayed. Default is "no".
      # :title       => String: represents title of the graph. Default is "Embed created through API."
      def create_embed(graph_json, description= {})
        body = {
          :graph_json => graph_json,
        }.merge(description)

        request(Net::HTTP::Post, "/api/#{API_VERSION}/graph/embed", nil, body, true)
      end

      # Enable a specific embed
      #
      # :embed_id  => String: embed token for a specific embed
      def enable_embed(embed_id)
        request(Net::HTTP::Get, "/api/#{API_VERSION}/graph/embed/#{embed_id}/enable", nil, nil, false)
      end

      # Revoke a specific embed
      #
      # :embed_id  => String: embed token for a specific embed
      def revoke_embed(embed_id)
        request(Net::HTTP::Get, "/api/#{API_VERSION}/graph/embed/#{embed_id}/revoke", nil, nil, false)
      end

    end

  end
end
