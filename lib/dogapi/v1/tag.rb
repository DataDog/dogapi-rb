require 'dogapi'

module Dogapi
  class V1 # for namespacing

    # 
    class TagService < Dogapi::APIService

      API_VERSION = "v1"

      # Gets all tags in your org and the hosts tagged with them
      def get_all(source=nil)
        begin
          params = {
            :api_key => @api_key,
            :application_key => @application_key
          }
          if source
            params['source'] = source
          end

          request(Net::HTTP::Get, '/api/' + API_VERSION + '/tags/hosts', params, nil, false)
        rescue Exception => e
          if @silent
            warn e
            return -1, {}
          else
            raise e
          end
        end
      end

      # Gets all tags for a given host
      def get(host_id, source=nil, by_source=false)
        begin
          params = {
            :api_key => @api_key,
            :application_key => @application_key
          }
          if source
            params['source'] = source
          end
          if by_source
            params['by_source'] = 'true'
          end

          request(Net::HTTP::Get, '/api/' + API_VERSION + '/tags/hosts/' + host_id.to_s, params, nil, false)
        rescue Exception => e
          if @silent
            warn e
            return -1, {}
          else
            raise e
          end
        end
      end

      # Adds a list of tags to a host
      def add(host_id, tags, source=nil)
        begin
          params = {
            :api_key => @api_key,
            :application_key => @application_key
          }
          if source
            params['source'] = source
          end

          body = {
            :tags => tags
          }

          request(Net::HTTP::Post, '/api/' + API_VERSION + '/tags/hosts/' + host_id.to_s, params, body, true)
        rescue Exception => e
          if @silent
            warn e
            return -1, {}
          else
            raise e
          end
        end
      end

      # Remove all tags from a host and replace them with a new list
      def update(host_id, tags, source=nil)
        begin
          params = {
            :api_key => @api_key,
            :application_key => @application_key
          }
          if source
            params['source'] = source
          end

          body = {
            :tags => tags
          }

          request(Net::HTTP::Put, '/api/' + API_VERSION + '/tags/hosts/' + host_id.to_s, params, body, true)
        rescue Exception => e
          if @silent
            warn e
            return -1, {}
          else
            raise e
          end
        end
      end

      # <b>DEPRECATED:</b> Spelling mistake temporarily preserved as an alias.
      def detatch(host_id)
        warn "[DEPRECATION] Dogapi::V1::TagService.detatch() is deprecated. Use `detach` instead."
        detach(host_id)
      end

      # Remove all tags from a host
      def detach(host_id, source=nil)
        begin
          params = {
            :api_key => @api_key,
            :application_key => @application_key
          }
          if source
            params['source'] = source
          end

          request(Net::HTTP::Delete, '/api/' + API_VERSION + '/tags/hosts/' + host_id.to_s, params, nil, false)
        rescue Exception => e
          if @silent
            warn e
            return -1, {}
          else
            raise e
          end
        end
      end

    end

  end
end
