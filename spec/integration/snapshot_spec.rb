# Unless explicitly stated otherwise all files in this repository are licensed under the BSD-3-Clause License.
# This product includes software developed at Datadog (https://www.datadoghq.com/).
# Copyright 2011-Present Datadog, Inc.

require_relative '../spec_helper'

describe Dogapi::Client do
  SNAP_QUERY = 'system.load.1{*}'.freeze
  START_TS = Time.now.to_i
  END_TS = START_TS + 10
  EVENT_QUERY = 'hotfixes'.freeze

  PARAMS = { metric_query: SNAP_QUERY, start: START_TS, end: END_TS }.freeze
  EXTENDED_PARAMS = PARAMS.merge(event_query: EVENT_QUERY)

  describe '#snapshot' do
    context 'when creating a simple graph' do
      it_behaves_like 'an api method with params',
                      :graph_snapshot, [],
                      :get, '/graph/snapshot', PARAMS
    end
    context 'when adding an event overlay' do
      it_behaves_like 'an api method with params',
                      :graph_snapshot, [],
                      :get, '/graph/snapshot', EXTENDED_PARAMS
    end
  end
end
