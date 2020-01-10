require_relative '../spec_helper'

describe Dogapi::Client do
  SYNTHETICS_TEST_PUBLIC_ID = '84r-szk-xpt'
  SYNTHETICS_TESTS_PUBLIC_IDS = ['84r-szk-xpt', 'sti-s2m-ciz']
  NEW_STATUS = 'paused'
  SYNTHETICS_RESULT_ID = 123_456
  SYNTHETICS_TYPE = 'api'.freeze
  SYNTHETIC_TEST_CONFIG = {
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

  describe '#create_test' do
    it_behaves_like 'an api method with options',
                    :create_test, [SYNTHETICS_TYPE, SYNTHETIC_TEST_CONFIG],
                    :post, '/synthetics/tests', 'type' => SYNTHETICS_TYPE, 'config' => SYNTHETIC_TEST_CONFIG
  end

  describe '#edit_test' do
    it_behaves_like 'an api method with options',
                    :edit_test, [SYNTHETICS_TEST_PUBLIC_ID, SYNTHETIC_TEST_CONFIG],
                    :put, "/synthetics/tests/#{SYNTHETICS_TEST_PUBLIC_ID}", 'config' => SYNTHETIC_TEST_CONFIG
  end

  describe '#delete_tests' do
    it_behaves_like 'an api method with options',
                    :delete_tests, [SYNTHETICS_TESTS_PUBLIC_IDS],
                    :post, '/synthetics/tests/delete', 'public_ids' => SYNTHETICS_TESTS_PUBLIC_IDS
  end

  describe '#star_pause_test' do
    it_behaves_like 'an api method with options',
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
    it_behaves_like 'an api method',
                    :get_result, [SYNTHETICS_TEST_PUBLIC_ID, SYNTHETICS_RESULT_ID],
                    :get, "/synthetics/tests/#{SYNTHETICS_TEST_PUBLIC_ID}/results#{SYNTHETICS_RESULT_ID}"
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
