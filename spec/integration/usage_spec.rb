require_relative '../spec_helper'

describe Dogapi::Client do
  USAGE_PARAMS = {
    start_hr: (Time.now - (3600 * 24)).utc.strftime('%Y-%m-%dT%H'),
    end_hr: Time.now.utc.strftime('%Y-%m-%dT%H')
  }.freeze

  describe '#get_hosts_usage' do
    it_behaves_like 'an api method with params',
                    :get_hosts_usage, [],
                    :get, '/usage/hosts', USAGE_PARAMS
  end

  describe '#get_logs_usage' do
    it_behaves_like 'an api method with params',
                    :get_logs_usage, [],
                    :get, '/usage/logs', USAGE_PARAMS
  end

  describe '#get_custom_metrics_usage' do
    it_behaves_like 'an api method with params',
                    :get_custom_metrics_usage, [],
                    :get, '/usage/timeseries', USAGE_PARAMS
  end

  describe '#get_traces_usage' do
    it_behaves_like 'an api method with params',
                    :get_traces_usage, [],
                    :get, '/usage/traces', USAGE_PARAMS
  end

  describe '#get_synthetics_usage' do
    it_behaves_like 'an api method with params',
                    :get_synthetics_usage, [],
                    :get, '/usage/synthetics', USAGE_PARAMS
  end

  describe '#get_fargate_usage' do
    it_behaves_like 'an api method with params',
                    :get_fargate_usage, [],
                    :get, '/usage/fargate', USAGE_PARAMS
  end
end
