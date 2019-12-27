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
  ALERT_ID = 42
  QUERY = 'avg(last_10m):avg:test.metric.metric{host:test.metric.host} > 5'.freeze

  describe '#alert' do
    it_behaves_like 'an api method with options',
                    :alert, [QUERY],
                    :post, '/alert', 'query' => QUERY
  end

  describe '#update_alert' do
    it_behaves_like 'an api method with options',
                    :update_alert, [ALERT_ID, QUERY],
                    :put, "/alert/#{ALERT_ID}", 'query' => QUERY
  end

  describe '#get_alert' do
    it_behaves_like 'an api method',
                    :get_alert, [ALERT_ID],
                    :get, "/alert/#{ALERT_ID}"
  end

  describe '#delete_alert' do
    it_behaves_like 'an api method',
                    :delete_alert, [ALERT_ID],
                    :delete, "/alert/#{ALERT_ID}"
  end

  describe '#get_all_alerts' do
    it_behaves_like 'an api method',
                    :get_all_alerts, [],
                    :get, '/alert'
  end

  describe '#mute_alerts' do
    it_behaves_like 'an api method',
                    :mute_alerts, [], :post,
                    '/mute_alerts'
  end

  describe '#unmute_alerts' do
    it_behaves_like 'an api method',
                    :unmute_alerts, [],
                    :post, '/unmute_alerts'
  end
end
