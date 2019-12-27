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
