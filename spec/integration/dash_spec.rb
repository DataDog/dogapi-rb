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

  DASH_BODY = {
    title: TITLE,
    description: DESCRIPTION,
    graphs: GRAPHS,
    template_variables: TEMPLATE_VARIABLES
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
