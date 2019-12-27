# encoding: utf-8

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

require_relative '../spec_helper'

describe Dogapi::Client do
  EVENT_ID = 123_456
  EVENT_START = Time.now.to_i - 10
  EVENT_END = EVENT_START + 5
  EVENT_OPTIONS = {
    msg_text: 'My event text',
    date_happened: EVENT_START,
    msg_title: 'My event title',
    priority: 'normal',
    parent: nil,
    tags: ['test:test'],
    aggregation_key: 'fasdfasffergeqgqe',
    alert_type: nil,
    event_type: nil,
    source_type_name: nil,
    title: 'My event title',
    text: 'My event text',
    host: 'data.dog',
    device: nil
  }.freeze
  EVENT = Dogapi::Event.new 'My event text', EVENT_OPTIONS
  STREAM_PARAMS = {
    priority: 'normal',
    sources: 'chef',
    tags: %w(fds fdsfsa)
  }.freeze

  describe '#emit_event' do
    it 'queries the api' do
      url = api_url + '/events'
      stub_request(:post, /#{url}/).to_return(body: '{}').then.to_raise(StandardError)
      expect(dog.send(:emit_event, EVENT)).to eq ['200', {}]

      body = MultiJson.dump(EVENT_OPTIONS)

      expect(WebMock).to have_requested(:post, url).with(
        query: { 'api_key' => api_key },
        body: body
      )
    end
  end

  describe '#get_event' do
    it_behaves_like 'an api method',
                    :get_event, [EVENT_ID],
                    :get, "/events/#{EVENT_ID}"
  end

  describe '#delete_event' do
    it_behaves_like 'an api method',
                    :delete_event, [EVENT_ID],
                    :delete, "/events/#{EVENT_ID}"
  end

  describe '#stream' do
    it 'queries the api with params' do
      url = api_url + '/events'
      stub_request(:get, /#{url}/).to_return(body: '{}').then.to_raise(StandardError)
      expect(dog.send(:stream, EVENT_START, EVENT_END, STREAM_PARAMS)).to eq ['200', {}]

      params = STREAM_PARAMS.merge(start: EVENT_START, end: EVENT_END)
      params.each { |k, v| params[k] = v.join(',') if v.is_a? Array }
      params.merge! default_query

      expect(WebMock).to have_requested(:get, url).with(
        query: params
      )
    end
  end
end
