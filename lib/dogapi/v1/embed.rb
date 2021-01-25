# Unless explicitly stated otherwise all files in this repository are licensed under the BSD-3-Clause License.
# This product includes software developed at Datadog (https://www.datadoghq.com/).
# Copyright 2011-Present Datadog, Inc.

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
