# Unless explicitly stated otherwise all files in this repository are licensed under the BSD-3-Clause License.
# This product includes software developed at Datadog (https://www.datadoghq.com/).
# Copyright 2011-Present Datadog, Inc.

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
