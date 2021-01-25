# Unless explicitly stated otherwise all files in this repository are licensed under the BSD-3-Clause License.
# This product includes software developed at Datadog (https://www.datadoghq.com/).
# Copyright 2011-Present Datadog, Inc.

module Dogapi
  class V1 # for namespacing

    # Event-specific client affording more granular control than the simple Dogapi::Client
    class EventService < Dogapi::APIService

      API_VERSION = 'v1'
      MAX_BODY_LENGTH = 4000
      MAX_TITLE_LENGTH = 100

      # Records an Event with no duration
      def post(event, scope=nil)
        scope = scope || Dogapi::Scope.new()
        body = event.to_hash.merge({
          :title => event.msg_title[0..MAX_TITLE_LENGTH - 1],
          :text => event.msg_text[0..MAX_BODY_LENGTH - 1],
          :date_happened => event.date_happened.to_i,
          :host => scope.host,
          :device => scope.device,
          :aggregation_key => event.aggregation_key.to_s
        })

        request(Net::HTTP::Post, '/api/v1/events', nil, body, true, false)
      end

      def get(id)
        request(Net::HTTP::Get, '/api/' + API_VERSION + '/events/' + id.to_s, nil, nil, false)
      end

      def delete(id)
        request(Net::HTTP::Delete, '/api/' + API_VERSION + '/events/' + id.to_s, nil, nil, false)
      end

      def stream(start, stop, options= {})
        defaults = {
          :priority => nil,
          :sources => nil,
          :tags => nil
        }
        options = defaults.merge(options)

        extra_params = {
          :start => start.to_i,
          :end => stop.to_i
        }

        if options[:priority]
          extra_params[:priority] = options[:priority]
        end
        if options[:sources]
          extra_params[:sources] = options[:sources]
        end
        if options[:tags]
          tags = options[:tags]
          extra_params[:tags] = tags.kind_of?(Array) ? tags.join(',') : tags
        end

        request(Net::HTTP::Get, '/api/' + API_VERSION + '/events', extra_params, nil, false)
      end

    end

  end
end
