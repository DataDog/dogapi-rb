# Unless explicitly stated otherwise all files in this repository are licensed under the BSD-3-Clause License.
# This product includes software developed at Datadog (https://www.datadoghq.com/).
# Copyright 2011-Present Datadog, Inc.

require 'spec_helper'
require 'capistrano/datadog'
require 'benchmark'

describe 'Capistrano' do
  context 'Reporter' do
    context 'report' do
      before(:each) do
        @task = {
          name: 'ATask',
          roles: [],
          stage: 'AStage',
          application: 'MyApp',
          logs: [],
          hosts: []
        }
        @reporter = Capistrano::Datadog.reporter
      end

      it 'normally works with float timing' do
        @task[:timing] = 9.99999
        expected = @task[:timing].round(2)
        @reporter.instance_variable_set(:@tasks, [@task])
        event = @reporter.report.first.first
        expect(event.msg_title).to include("with capistrano in #{expected} secs")
      end

      it 'handles non-numeric timing' do
        @task[:timing] = nil
        @reporter.instance_variable_set(:@tasks, [@task])
        event = @reporter.report.first.first
        expect(event.msg_title).to include('with capistrano in n/a secs')
      end
    end
  end
end
