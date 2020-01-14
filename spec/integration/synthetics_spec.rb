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
    'tick_every' => 60,
    'min_failure_duration' => 0,
    'min_location_failed' => 1,
    'follow_redirects' => true
  }.freeze

  SYNTHETICS_LOCATIONS = [
    'aws:us-east-2',
    'aws:eu-central-1',
    'aws:ca-central-1'
  ].freeze
  SYNTHETICS_TEST_MESSAGE = 'Test with API'.freeze
  SYNTHETICS_TEST_NAME = 'Test with API'.freeze
  SYNTHETICS_TEST_TAGS = ['key1:value1', 'key2:value2'].freeze

  describe '#create_test' do
    it 'queries the api' do
      url = api_url + '/synthetics/tests'
      stub_request(:post, /#{url}/).to_return(body: '{}').then.to_raise(StandardError)
      expect(dog.send(:create_test, SYNTHETICS_TEST_TYPE, SYNTHETICS_TEST_CONFIG, SYNTHETICS_LOCATIONS,
                      SYNTHETICS_TEST_MESSAGE, SYNTHETICS_TEST_NAME, SYNTHETICS_TEST_TAGS,
                      SYNTHETICS_TEST_OPTIONS)).to eq ['200', {}]

      expect(WebMock).to have_requested(:post, url)
    end
  end

  describe '#edit_test' do
    it 'queries the api' do
      url = api_url + "/synthetics/tests/#{SYNTHETICS_TEST_PUBLIC_ID}"
      stub_request(:put, /#{url}/).to_return(body: '{}').then.to_raise(StandardError)
      expect(dog.send(:edit_test, SYNTHETICS_TEST_TYPE, SYNTHETICS_TEST_CONFIG, SYNTHETICS_LOCATIONS,
                      SYNTHETICS_TEST_MESSAGE, SYNTHETICS_TEST_NAME, SYNTHETICS_TEST_TAGS,
                      SYNTHETICS_TEST_OPTIONS)).to eq ['200', {}]

      expect(WebMock).to have_requested(:put, url)
    end
  end

  describe '#delete_tests' do
    it_behaves_like 'an api method',
                    :delete_tests, [SYNTHETICS_TESTS_PUBLIC_IDS],
                    :post, '/synthetics/tests/delete', 'public_ids' => SYNTHETICS_TESTS_PUBLIC_IDS
  end

  describe '#star_pause_test' do
    it_behaves_like 'an api method',
                    :star_pause_test, [SYNTHETICS_TEST_PUBLIC_ID, NEW_STATUS],
                    :post, "/synthetics/tests/#{SYNTHETICS_TEST_PUBLIC_ID}/status", 'new_status' => NEW_STATUS
  end

  describe '#get_all_tests' do
    it_behaves_like 'an api method',
                    :get_all_tests, [],
                    :get, '/synthetics/tests'
  end

  describe '#get_test' do
    it_behaves_like 'an api method',
                    :get_test, [SYNTHETICS_TEST_PUBLIC_ID],
                    :get, "/synthetics/tests/#{SYNTHETICS_TEST_PUBLIC_ID}"
  end

  describe '#get_results' do
    it_behaves_like 'an api method',
                    :get_results, [SYNTHETICS_TEST_PUBLIC_ID],
                    :get, "/synthetics/tests/#{SYNTHETICS_TEST_PUBLIC_ID}/results"
  end

  describe '#get_result' do
    it 'queries the api' do
      url = api_url + "/synthetics/tests/#{SYNTHETICS_TEST_PUBLIC_ID}/results/#{SYNTHETICS_RESULT_ID}"
      stub_request(:get, /#{url}/).to_return(body: '{}').then.to_raise(StandardError)
      expect(dog.send(:get_result, SYNTHETICS_TEST_PUBLIC_ID, SYNTHETICS_RESULT_ID)).to eq ['200', {}]

      expect(WebMock).to have_requested(:get, url)
    end
  end

  describe '#get_devices' do
    it_behaves_like 'an api method',
                    :get_devices, [],
                    :get, '/synthetics/browser/devices'
  end

  describe '#get_locations' do
    it_behaves_like 'an api method',
                    :get_locations, [],
                    :get, '/synthetics/locations'
  end
end
