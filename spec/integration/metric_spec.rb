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
  METRIC_QUERY = 'avg(last_10m):avg:test.metric.metric{host:test.metric.host} > 5'.freeze
  FROM = Time.now
  TO = FROM + 10
  METRIC = 'test.metric'.freeze
  POINTS = [[FROM, 10], [TO, 20.0]].freeze

  EMIT_BODY = {
    'series' => [{
      'metric' => 'test.metric',
      'points' => [[FROM.to_i, 10.0], [TO.to_i, 20.0]],
      'type' => 'gauge',
      'host' => 'data.dog',
      'device' => nil
    }]
  }.freeze

  BATCH_BODY = {
    'series' => [{
      'metric' => 'test.metric',
      'points' => [[FROM.to_i, 10.0]],
      'type' => 'gauge',
      'host' => 'data.dog',
      'device' => nil
    }, {
      'metric' => 'test.metric',
      'points' => [[TO.to_i, 20.0]],
      'type' => 'gauge',
      'host' => 'data.dog',
      'device' => nil
    }]
  }.freeze

  METRIC_PARAMS = { query: METRIC_QUERY, from: FROM.to_i, to: TO.to_i }.freeze
  ACTIVE_METRICS_PARAMS = { from: FROM.to_i }.freeze

  describe '#emit_point' do
    it 'queries the api' do
      url = api_url + '/series'
      stub_request(:post, /#{url}/).to_return(body: '{}').then.to_raise(StandardError)
      points = Marshal.load(Marshal.dump(POINTS[0]))
      expect(dog.send(:emit_points, METRIC, [points])).to eq ['200', {}]

      body = Marshal.load(Marshal.dump(EMIT_BODY))
      body['series'][0]['points'] = [body['series'][0]['points'][0]]
      body = MultiJson.dump(body)

      expect(WebMock).to have_requested(:post, url).with(
        query: { 'api_key' => api_key },
        body: body
      )
    end
  end

  describe '#emit_points' do
    it 'queries the api' do
      url = api_url + '/series'
      stub_request(:post, /#{url}/).to_return(body: '{}').then.to_raise(StandardError)
      points = Marshal.load(Marshal.dump(POINTS))
      expect(dog.send(:emit_points, METRIC, points)).to eq ['200', {}]

      body = MultiJson.dump(EMIT_BODY)

      expect(WebMock).to have_requested(:post, url).with(
        query: { 'api_key' => api_key },
        body: body
      )
    end
  end

  describe '#get_points' do
    it_behaves_like 'an api method with params',
                    :get_points, [],
                    :get, '/query', METRIC_PARAMS
  end

  describe '#batch_metrics' do
    it 'queries the api' do
      url = api_url + '/series'
      stub_request(:post, /#{url}/).to_return(body: '{}').then.to_raise(StandardError)
      points = Marshal.load(Marshal.dump(POINTS))
      dog.batch_metrics do
        dog.emit_points(METRIC, points[0, 1].clone)
        dog.emit_points(METRIC, points[1, 1].clone)
      end

      body = MultiJson.dump(BATCH_BODY)

      expect(WebMock).to have_requested(:post, url).with(
        query: { 'api_key' => api_key },
        body: body
      )
    end
  end

  describe '#get_active_metrics' do
    it_behaves_like 'an api method with params',
                    :get_active_metrics, [],
                    :get, '/metrics', ACTIVE_METRICS_PARAMS
  end
end
