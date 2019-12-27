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
  MONITOR_ID = 42
  MONITOR_TYPE = 'custom type'.freeze
  MONITOR_QUERY = 'avg(last_10m):avg:test.metric.metric{host:test.metric.host} > 5'.freeze
  DOWNTIME_SCOPE = 'host:vagrant-ubuntu-trusty-64'.freeze
  DOWNTIME_ID = 424_242_424_242
  MUTE_HOSTNAME = 'vagrant-ubuntu-trusty-32'.freeze
  MONITOR_GROUPS = [{ 'check_a' => 'group_x' }, { 'check_a' => 'group_y' }, { 'check_b' => 'ALL_GROUPS' }].freeze

  describe '#monitor' do
    it_behaves_like 'an api method with options',
                    :monitor, [MONITOR_TYPE, MONITOR_QUERY],
                    :post, '/monitor', 'type' => MONITOR_TYPE, 'query' => MONITOR_QUERY
  end

  describe '#update_monitor' do
    it_behaves_like 'an api method with options',
                    :update_monitor, [MONITOR_ID, MONITOR_QUERY],
                    :put, "/monitor/#{MONITOR_ID}", 'query' => MONITOR_QUERY
  end

  describe '#get_monitor' do
    it_behaves_like 'an api method with optional params',
                    :get_monitor, [MONITOR_ID],
                    :get, "/monitor/#{MONITOR_ID}", group_states: %w(custom all)
  end

  describe '#can_delete_monitors' do
    context 'with one id' do
      it_behaves_like 'an api method',
                      :can_delete_monitors, [MONITOR_ID],
                      :get, '/monitor/can_delete'
    end

    context 'with multiple ids' do
      it_behaves_like 'an api method',
                      :can_delete_monitors, [[MONITOR_ID, MONITOR_ID + 1, MONITOR_ID + 2]],
                      :get, '/monitor/can_delete'
    end
  end

  describe '#delete_monitor' do
    it_behaves_like 'an api method',
                    :delete_monitor, [MONITOR_ID],
                    :delete, "/monitor/#{MONITOR_ID}"
  end

  describe '#get_all_monitors' do
    it_behaves_like 'an api method with optional params',
                    :get_all_monitors, [],
                    :get, '/monitor', group_states: %w(custom all), tags: ['test', 'key:value'], name: 'test'
  end

  describe '#validate_monitor' do
    it_behaves_like 'an api method with options',
                    :validate_monitor, [MONITOR_TYPE, MONITOR_QUERY],
                    :post, '/monitor/validate', 'type' => MONITOR_TYPE, 'query' => MONITOR_QUERY
  end

  describe '#mute_monitors' do
    it_behaves_like 'an api method',
                    :mute_monitors, [],
                    :post, '/monitor/mute_all'
  end

  describe '#unmute_monitors' do
    it_behaves_like 'an api method',
                    :unmute_monitors, [],
                    :post, '/monitor/unmute_all'
  end

  describe '#mute_monitor' do
    it_behaves_like 'an api method',
                    :mute_monitor, [MONITOR_ID],
                    :post, "/monitor/#{MONITOR_ID}/mute", {}
  end

  describe '#unmute_monitor' do
    it_behaves_like 'an api method',
                    :unmute_monitor, [MONITOR_ID],
                    :post, "/monitor/#{MONITOR_ID}/unmute", {}
  end

  describe '#resolve_monitors' do
    it_behaves_like 'an api method with options',
                    :resolve_monitors, [MONITOR_GROUPS],
                    :post, '/monitor/bulk_resolve', 'resolve' => MONITOR_GROUPS
  end

  describe '#schedule_downtime' do
    it_behaves_like 'an api method with options',
                    :schedule_downtime, [DOWNTIME_SCOPE],
                    :post, '/downtime', 'scope' => DOWNTIME_SCOPE
  end

  describe '#update_downtime' do
    it_behaves_like 'an api method with options',
                    :update_downtime, [DOWNTIME_ID],
                    :put, "/downtime/#{DOWNTIME_ID}", {}
  end

  describe '#get_downtime' do
    it_behaves_like 'an api method',
                    :get_downtime, [DOWNTIME_ID],
                    :get, "/downtime/#{DOWNTIME_ID}"
  end

  describe '#cancel_downtime' do
    it_behaves_like 'an api method',
                    :cancel_downtime, [DOWNTIME_ID],
                    :delete, "/downtime/#{DOWNTIME_ID}"
  end

  describe '#cancel_downtime_by_scope' do
    it_behaves_like 'an api method',
                    :cancel_downtime_by_scope, [DOWNTIME_SCOPE],
                    :post, '/downtime/cancel/by_scope', 'scope' => DOWNTIME_SCOPE
  end

  describe '#get_all_downtimes' do
    it_behaves_like 'an api method with optional params',
                    :get_all_downtimes, [],
                    :get, '/downtime', current_only: true
  end

  describe '#mute_host' do
    it_behaves_like 'an api method with options',
                    :mute_host, [MUTE_HOSTNAME],
                    :post, "/host/#{MUTE_HOSTNAME}/mute", {}
  end

  describe '#unmute_host' do
    it_behaves_like 'an api method',
                    :unmute_host, [MUTE_HOSTNAME],
                    :post, "/host/#{MUTE_HOSTNAME}/unmute", {}
  end
end
