# Unless explicitly stated otherwise all files in this repository are licensed under the BSD-3-Clause License.
# This product includes software developed at Datadog (https://www.datadoghq.com/).
# Copyright 2011-Present Datadog, Inc.

require_relative '../spec_helper'

describe Dogapi::APIService do
  describe '#connect' do
    let(:url) { api_url + '/awesome' }
    let(:second_url) { 'http://app.example.com/api/v1/awesome' }

    context 'when only the default endpoint is used' do
      let(:service) { Dogapi::APIService.new api_key, app_key }
      context 'and it is up' do
        it 'only queries one endpoint' do
          stub_request(:get, /#{url}/).to_return(body: '{}').then.to_raise(StandardError)
          expect(service.request(Net::HTTP::Get, '/api/v1/awesome', nil, nil, true, true)).to eq(['200', {}])

          expect(WebMock).to have_requested(:get, url)
        end
      end
      context 'and it is down' do
        it 'only queries one endpoint' do
          stub_request(:get, /#{url}/).to_timeout
          expect(service.request(Net::HTTP::Get, '/api/v1/awesome', nil, nil, true, true)).to eq([-1, {}])

          expect(WebMock).to have_requested(:get, url)
        end
      end
    end
  end
end
