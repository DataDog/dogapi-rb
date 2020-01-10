require_relative '../spec_helper'

describe Dogapi::Client do
  SYNTHETICS_TEST_PUBLIC_ID = "84r-szk-xpt"
  SYNTHETIC_TYPE = 'api'.freeze
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
                    :synthetic, [SYNTHETIC_TYPE, SYNTHETIC_TEST_CONFIG],
                    :post, '/synthetics/tests', 'type' => SYNTHETIC_TYPE, 'config' => SYNTHETIC_TEST_CONFIG
  end

  describe '#edit_test' do
    it_behaves_like 'an api method with options',
                    :edit_test, [SYNTHETICS_TEST_PUBLIC_ID, SYNTHETIC_TEST_CONFIG],
                    :put, "/synthetics/tests/#{SYNTHETICS_TEST_PUBLIC_ID}", 'config' => SYNTHETIC_TEST_CONFIG
  end

  describe '#get_all_tests' do
    it_behaves_like 'an api method',
                    :get_all_tests, [],
                    :get, '/synthetics/tests'
  end

  describe '#get_test' do
  it_behaves_like 'an api method',
                    :get_test, [],
                    :get, "/synthetics/tests/#{SYNTHETICS_TEST_PUBLIC_ID}"
  end

end
