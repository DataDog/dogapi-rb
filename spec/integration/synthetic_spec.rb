require_relative '../spec_helper'

describe Dogapi::Client do
  SYNTHETIC_ID = 123_456
  SYNTHETIC_TYPE = 'api'.freeze
  SYNTHETIC_CONFIG = {
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

  describe '#synthetic' do
    it_behaves_like 'an api method with options',
                    :synthetic, [SYNTHETIC_TYPE, SYNTHETIC_CONFIG],
                    :post, '/synthetics/tests', 'type' => SYNTHETIC_TYPE, 'config' => SYNTHETIC_CONFIG
  end

  describe '#update_synthetic' do
    it_behaves_like 'an api method with options',
                    :update_synthetic, [SYNTHETIC_ID, SYNTHETIC_CONFIG],
                    :put, "/synthetics/tests/#{SYNTHETIC_ID}", 'config' => SYNTHETIC_CONFIG
  end

  describe '#get_all_synthetics' do
    it_behaves_like 'an api method',
                    :get_all_synthetics, [],
                    :get, '/synthetics/tests'
  end
end
