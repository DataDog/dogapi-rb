require 'dogapi'

module Dogapi
  class V1 # for namespacing

    # 
    class TagService < Dogapi::APIService

      API_VERSION = "v1"

      # Gets all tags in your org and the hosts tagged with them
      def get_all()
        params = {
          :api_key => @api_key,
          :application_key => @application_key
        }

        request(Net::HTTP::Get, '/api/' + API_VERSION + '/tags/hosts', params, nil, false)
      end

      # Gets all tags for a given host
      def get(host_id)
        params = {
          :api_key => @api_key,
          :application_key => @application_key
        }

        request(Net::HTTP::Get, '/api/' + API_VERSION + '/tags/hosts/' + host_id.to_s, params, nil, false)
      end

      # Adds a list of tags to a host
      def add(host_id, tags)
        params = {
          :api_key => @api_key,
          :application_key => @application_key
        }

        body = {
          :tags => tags
        }

        request(Net::HTTP::Post, '/api/' + API_VERSION + '/tags/hosts/' + host_id.to_s, params, body, true)
      end

      # Remove all tags from a host and replace them with a new list
      def update(host_id, tags)
        params = {
          :api_key => @api_key,
          :application_key => @application_key
        }

        body = {
          :tags => tags
        }

        request(Net::HTTP::Put, '/api/' + API_VERSION + '/tags/hosts/' + host_id.to_s, params, body, true)
      end

      # Remove all tags from a host
      def detach(host_id)
        params = {
          :api_key => @api_key,
          :application_key => @application_key
        }

        request(Net::HTTP::Delete, '/api/' + API_VERSION + '/tags/hosts/' + host_id.to_s, params, nil, false)
      end

    end

  end
end
