# Copyright (c) 2010-2020, Datadog <opensource@datadoghq.com>
#
# Redistribution and use in source and binary forms, with or without modification, are permitted provided that the
# following conditions are met:
#
# 1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following
# disclaimer.
#
# 2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following
# disclaimer in the documentation and/or other materials provided with the distribution.
#
# 3. Neither the name of the copyright holder nor the names of its contributors may be used to endorse or promote
# products derived from this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES,
# INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
# SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
# SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
# WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

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
