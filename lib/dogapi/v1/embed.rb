require 'dogapi'

module Dogapi
  class V1 # for namespacing

    # ================
    #    EMBED API
    # ================
    class EmbedService < Dogapi::APIService

      API_VERSION = "v1"

      # Get all embeds for the API user's org
      def get_all_embeds()
        begin
          request(Net::HTTP::Get, "/api/#{API_VERSION}/graph/embed", true, nil, nil, false)
        rescue Exception => e
          suppress_error_if_silent e
        end
      end

      # Get a specific embed
      #
      # :embed_id       => String: embed token for a specific embed
      # :size           => String: "small", "medium"(defualt), "large", or "xlarge".
      # :legend         => String: "yes" or "no"(default)
      # :template_vars  => String: variable name => variable value (any number of template vars)
      def get_embed(embed_id, description= {})
        begin
          request(Net::HTTP::Get, "/api/#{API_VERSION}/graph/embed/#{embed_id}", true, description, nil, false)
        rescue Exception => e
          suppress_error_if_silent e
        end
      end

      # Create an embeddable graph
      #
      # :graph_json  => JSON: graph definition
      # :timeframe   => String: representing the interval of the graph. Default is "1_hour"
      # :size        => String: representing the size of the graph. Default is "medium".
      # :legend      => String: flag representing whether a legend is displayed. Default is "no".
      # :title       => String: represents title of the graph. Default is "Embed created through API."
      def create_embed(graph_json, description= {})
        begin
          body = {
            :graph_json => graph_json,
          }.merge(description)

          request(Net::HTTP::Post, "/api/#{API_VERSION}/graph/embed", true, nil, body, true)
        rescue Exception => e
          suppress_error_if_silent e
        end
      end

      # Enable a specific embed
      #
      # :embed_id  => String: embed token for a specific embed
      def enable_embed(embed_id)
        begin
          request(Net::HTTP::Get, "/api/#{API_VERSION}/graph/embed/#{embed_id}/enable", true, nil, nil, false)
        rescue Exception => e
          suppress_error_if_silent e
        end
      end

      # Revoke a specific embed
      #
      # :embed_id  => String: embed token for a specific embed
      def revoke_embed(embed_id)
        begin
          request(Net::HTTP::Get, "/api/#{API_VERSION}/graph/embed/#{embed_id}/revoke", true, nil, nil, false)
        rescue Exception => e
          suppress_error_if_silent e
        end
      end

    end

  end
end
