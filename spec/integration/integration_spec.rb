# Unless explicitly stated otherwise all files in this repository are licensed under the BSD-3-Clause License.
# This product includes software developed at Datadog (https://www.datadoghq.com/).
# Copyright 2011-Present Datadog, Inc.

require_relative '../spec_helper'

describe Dogapi::Client do
  SOURCE_TYPE_NAME = 'pagerduty'.freeze
  PAGERDUTY_SERVICES = {
    services: [
      {
        service_name: 'test_00',
        service_key: '<PAGERDUTY_SERVICE_KEY>'
      },
      {
        service_name: 'test_01',
        service_key: '<PAGERDUTY_SERVICE_KEY>'
      }
    ],
    subdomain: '<PAGERDUTY_SUB_DOMAIN>',
    schedules: ['<SCHEDULE_1>', '<SCHEDULE_2>'],
    api_token: '<PAGERDUTY_TOKEN>'
  }.freeze

  describe '#create_integration' do
    it_behaves_like 'an api method',
                    :create_integration, [SOURCE_TYPE_NAME, PAGERDUTY_SERVICES],
                    :post, "/integration/#{SOURCE_TYPE_NAME}", PAGERDUTY_SERVICES
  end

  describe '#get_integration' do
    it_behaves_like 'an api method',
                    :get_integration, [SOURCE_TYPE_NAME],
                    :get, "/integration/#{SOURCE_TYPE_NAME}"
  end

  describe '#update_integration' do
    it_behaves_like 'an api method',
                    :update_integration, [SOURCE_TYPE_NAME, PAGERDUTY_SERVICES],
                    :put, "/integration/#{SOURCE_TYPE_NAME}", PAGERDUTY_SERVICES
  end

  describe '#delete_integration' do
    it_behaves_like 'an api method',
                    :delete_integration, [SOURCE_TYPE_NAME],
                    :delete, "/integration/#{SOURCE_TYPE_NAME}"
  end
end
