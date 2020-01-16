# Unless explicitly stated otherwise all files in this repository are licensed under the BSD-3-Clause License.
# This product includes software developed at Datadog (https://www.datadoghq.com/).
# Copyright 2011-Present Datadog, Inc.

require_relative '../spec_helper'

describe Dogapi::Client do
  DASH_ID = 424_242
  TITLE = 'My awesome dashboard'.freeze
  DESCRIPTION = 'Lorem ipsum'.freeze
  GRAPHS = [{
    'definition' => {
      'events' => [],
      'requests ' => [
        { 'q' => 'avg:system.mem.free{*}' }
      ],
      'viz' => 'timeseries'
    },
    'title' => 'Average Memory Free'
  }].freeze
  TEMPLATE_VARIABLES = [{
    'name' => 'host1',
    'prefix' => 'host',
    'default' => 'host:my-host'
  }].freeze
  READ_ONLY = false

  DASH_BODY = {
    title: TITLE,
    description: DESCRIPTION,
    graphs: GRAPHS,
    template_variables: TEMPLATE_VARIABLES,
    read_only: READ_ONLY
  }.freeze
  DASH_ARGS = DASH_BODY.values

  describe '#create_dashboard' do
    it_behaves_like 'an api method',
                    :create_dashboard, DASH_ARGS,
                    :post, '/dash', DASH_BODY
  end

  describe '#update_dashboard' do
    it_behaves_like 'an api method',
                    :update_dashboard, [DASH_ID] + DASH_ARGS,
                    :put, "/dash/#{DASH_ID}", DASH_BODY
  end

  describe '#get_dashboard' do
    it_behaves_like 'an api method',
                    :get_dashboard, [DASH_ID],
                    :get, "/dash/#{DASH_ID}"
  end

  describe '#get_dashboards' do
    it_behaves_like 'an api method',
                    :get_dashboards, [],
                    :get, '/dash'
  end

  describe '#delete_dashboard' do
    it_behaves_like 'an api method',
                    :delete_dashboard, [DASH_ID],
                    :delete, "/dash/#{DASH_ID}"
  end
end
