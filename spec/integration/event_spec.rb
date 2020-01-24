# encoding: utf-8

# Unless explicitly stated otherwise all files in this repository are licensed under the BSD-3-Clause License.
# This product includes software developed at Datadog (https://www.datadoghq.com/).
# Copyright 2011-Present Datadog, Inc.

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
