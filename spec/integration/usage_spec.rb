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
