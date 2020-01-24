require_relative '../spec_helper'

describe Dogapi::Client do
  SYNTHETICS_TEST_PUBLIC_ID = '84r-szk-xpt'
  SYNTHETICS_TESTS_PUBLIC_IDS = ['84r-szk-xpt', 'sti-s2m-ciz']
  NEW_STATUS = 'paused'
  SYNTHETICS_RESULT_ID = 123_456

  SYNTHETICS_TEST_TYPE = 'api'.freeze
  SYNTHETICS_TEST_CONFIG = {
    'assertions' => [
      {
        'operator' => 'is',
        'type' => 'statusCode',
        'target' => 403
      },
      {
        'operator' => 'is',
        'property' => 'content-type',
        'type' => 'header',
        'target' => 'text/html'
      },
      {
        'operator' => 'lessThan',
        'type' => 'responseTime',
        'target' => 2000
      }
    ],
    'request' => {
      'method' => 'GET',
      'url' => 'https://datadoghq.com',
      'timeout' => 30,
      'headers' => {
        'header1' => 'value1',
        'header2' => 'value2'
      },
      'body' => 'body to send with the request'
    }
  }.freeze

  SYNTHETICS_TEST_OPTIONS = {
    'locations' => [
      'aws:us-east-2',
      'aws:eu-central-1',
      'aws:ca-central-1'
    ],
    'options' => {
      'tick_every' => 60,
      'min_failure_duration' => 0,
      'min_location_failed' => 1,
      'follow_redirects' => true
    },
    'message' => 'Test with API',
    'name' => 'Test with API',
    'tags' => ['key1:value1', 'key2:value2']
  }.freeze

  describe '#create_synthetics_test' do
    it 'queries the api' do
      url = api_url + '/synthetics/tests'
      stub_request(:post, /#{url}/).to_return(body: '{}').then.to_raise(StandardError)
      expect(dog.send(:create_synthetics_test, SYNTHETICS_TEST_TYPE, SYNTHETICS_TEST_CONFIG,
                      SYNTHETICS_TEST_OPTIONS)).to eq ['200', {}]

      expect(WebMock).to have_requested(:post, url)
    end
  end

  describe '#update_synthetics_test' do
    it 'queries the api' do
      url = api_url + "/synthetics/tests/#{SYNTHETICS_TEST_PUBLIC_ID}"
      stub_request(:put, /#{url}/).to_return(body: '{}').then.to_raise(StandardError)
      expect(dog.send(:update_synthetics_test, SYNTHETICS_TEST_PUBLIC_ID, SYNTHETICS_TEST_TYPE,
                      SYNTHETICS_TEST_CONFIG, SYNTHETICS_TEST_OPTIONS)).to eq ['200', {}]

      expect(WebMock).to have_requested(:put, url)
    end
  end

  describe '#delete_synthetics_tests' do
    it_behaves_like 'an api method',
                    :delete_synthetics_tests, [SYNTHETICS_TESTS_PUBLIC_IDS],
                    :post, '/synthetics/tests/delete', 'public_ids' => SYNTHETICS_TESTS_PUBLIC_IDS
  end

  describe '#start_pause_synthetics_test' do
    it_behaves_like 'an api method',
                    :start_pause_synthetics_test, [SYNTHETICS_TEST_PUBLIC_ID, NEW_STATUS],
                    :put, "/synthetics/tests/#{SYNTHETICS_TEST_PUBLIC_ID}/status", 'new_status' => NEW_STATUS
  end

  describe '#get_all_synthetics_tests' do
    it_behaves_like 'an api method',
                    :get_all_synthetics_tests, [],
                    :get, '/synthetics/tests'
  end

  describe '#get_synthetics_test' do
    it_behaves_like 'an api method',
                    :get_synthetics_test, [SYNTHETICS_TEST_PUBLIC_ID],
                    :get, "/synthetics/tests/#{SYNTHETICS_TEST_PUBLIC_ID}"
  end

  describe '#get_synthetics_results' do
    it_behaves_like 'an api method',
                    :get_synthetics_results, [SYNTHETICS_TEST_PUBLIC_ID],
                    :get, "/synthetics/tests/#{SYNTHETICS_TEST_PUBLIC_ID}/results"
  end

  describe '#get_synthetics_result' do
    it 'queries the api' do
      url = api_url + "/synthetics/tests/#{SYNTHETICS_TEST_PUBLIC_ID}/results/#{SYNTHETICS_RESULT_ID}"
      stub_request(:get, /#{url}/).to_return(body: '{}').then.to_raise(StandardError)
      expect(dog.send(:get_synthetics_result, SYNTHETICS_TEST_PUBLIC_ID, SYNTHETICS_RESULT_ID)).to eq ['200', {}]

      expect(WebMock).to have_requested(:get, url)
    end
  end

  describe '#get_synthetics_devices' do
    it_behaves_like 'an api method',
                    :get_synthetics_devices, [],
                    :get, '/synthetics/browser/devices'
  end

  describe '#get_synthetics_locations' do
    it_behaves_like 'an api method',
                    :get_synthetics_locations, [],
                    :get, '/synthetics/locations'
  end
end
