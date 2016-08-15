require_relative '../spec_helper'

describe Dogapi::APIService do
  describe '#connect' do
    context 'when only the default endpoint is used' do
      it 'only queries one endpoint' do
        service = Dogapi::APIService.new api_key, app_key
        url = api_url + '/awesome'

        stub_request(:get, /#{url}/).to_return(body: '{}').then.to_raise(StandardError)
        expect(service.request(Net::HTTP::Get, '/api/v1/awesome', nil, nil, true, true)).to eq(['200', {}])

        expect(WebMock).to have_requested(:get, url).with(
          query: default_query
        )
      end
    end

    context 'when multiple endpoints are used' do
      it 'queries both endpoints' do
        endpoints = { 'http://app.datadoghq.com' => [[api_key, app_key]],
                      'http://app.example.com' => [%w(api_key2 app_key2)] }
        service = Dogapi::APIService.new api_key, app_key, true, nil, endpoints

        url = api_url + '/awesome'
        second_url = 'http://app.example.com/api/v1/awesome'

        stub_request(:get, /#{url}/).to_return(body: '{}').then.to_raise(StandardError)
        stub_request(:get, /#{second_url}/).to_return(body: '{}').then.to_raise(StandardError)
        expect(service.request(Net::HTTP::Get, '/api/v1/awesome', nil, nil, true, true)).to eq(
          [['200', {}], ['200', {}]]
        )

        expect(WebMock).to have_requested(:get, url).with(
          query: default_query
        )
        expect(WebMock).to have_requested(:get, second_url).with(
          query: { api_key: 'api_key2', application_key: 'app_key2' }
        )
      end
    end

    context 'when multiple keys are used' do
      it 'queries both endpoints' do
        endpoints = { 'http://app.datadoghq.com' => [[api_key, app_key], %w(api_key2 app_key2)] }
        service = Dogapi::APIService.new api_key, app_key, true, nil, endpoints

        url = api_url + '/awesome'

        stub_request(:get, /#{url}/).to_return(body: '{}').times(2).then.to_raise(StandardError)
        expect(service.request(Net::HTTP::Get, '/api/v1/awesome', nil, nil, true, true)).to eq(
          [['200', {}], ['200', {}]]
        )

        expect(WebMock).to have_requested(:get, url).with(
          query: default_query
        )
        expect(WebMock).to have_requested(:get, url).with(
          query: { api_key: 'api_key2', application_key: 'app_key2' }
        )
      end
    end

    context 'when multiple endpoints and multiple keys are used' do
      it 'queries both endpoints' do
        endpoints = { 'http://app.datadoghq.com' => [[api_key, app_key], %w(api_key2 app_key2)],
                      'http://app.example.com' => [%w(api_key3 app_key3)] }
        service = Dogapi::APIService.new api_key, app_key, true, nil, endpoints

        url = api_url + '/awesome'
        second_url = 'http://app.example.com/api/v1/awesome'

        stub_request(:get, /#{url}/).to_return(body: '{}').times(2).then.to_raise(StandardError)
        stub_request(:get, /#{second_url}/).to_return(body: '{}').then.to_raise(StandardError)
        expect(service.request(Net::HTTP::Get, '/api/v1/awesome', nil, nil, true, true)).to eq(
          [['200', {}], ['200', {}], ['200', {}]]
        )

        expect(WebMock).to have_requested(:get, url).with(
          query: default_query
        )
        expect(WebMock).to have_requested(:get, url).with(
          query: { api_key: 'api_key2', application_key: 'app_key2' }
        )
        expect(WebMock).to have_requested(:get, second_url).with(
          query: { api_key: 'api_key3', application_key: 'app_key3' }
        )
      end
    end
  end
end
