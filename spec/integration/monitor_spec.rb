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
                    :post, '/downtime/cancel/by_scope'
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
