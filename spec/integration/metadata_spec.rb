require_relative '../spec_helper'

describe Dogapi::Client do
  METRIC_NAME = 'my.metric'.freeze

  describe '#get_metadata' do
    it_behaves_like 'an api method',
                    :get_metadata, [METRIC_NAME],
                    :get, '/metrics/' + METRIC_NAME
  end

  describe '#update_metadata' do
    it_behaves_like 'an api method with options',
                    :update_metadata, [METRIC_NAME],
                    :put, '/metrics/' + METRIC_NAME, {}
  end
end
