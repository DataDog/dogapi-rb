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
  DASHBOARD_ID = '3er-f8j-eus'.freeze
  TITLE = 'My awesome dashboard'.freeze
  WIDGETS = [{
    'definition' => {
      'requests ' => [
        { 'q' => 'avg:system.mem.free{*}' }
      ],
      'title' => 'Average Memory Free',
      'type' => 'timeseries'
    },
    'id' => 1234
  }].freeze
  LAYOUT_TYPE = 'ordered'.freeze
  DESCRIPTION = 'Lorem ipsum'.freeze
  IS_READ_ONLY = true
  NOTIFY_LIST = ['user@domain.com'].freeze
  TEMPLATE_VARIABLES = [{
    'name' => 'host1',
    'prefix' => 'host',
    'default' => 'my-host'
  }].freeze

  REQUIRED_ARGS = {
    title: TITLE,
    widgets: WIDGETS,
    layout_type: LAYOUT_TYPE
  }.freeze

  OPTIONS = {
    description: DESCRIPTION,
    is_read_only: IS_READ_ONLY,
    notify_list: NOTIFY_LIST,
    template_variables: TEMPLATE_VARIABLES
  }
  DASHBOARD_ARGS = REQUIRED_ARGS.values + [OPTIONS]
  DASHBOARD_PAYLOAD = REQUIRED_ARGS.merge(OPTIONS)

  describe '#create_board' do
    it_behaves_like 'an api method',
                    :create_board, DASHBOARD_ARGS,
                    :post, '/dashboard', DASHBOARD_PAYLOAD
  end

  describe '#update_board' do
    it_behaves_like 'an api method',
                    :update_board, [DASHBOARD_ID] + DASHBOARD_ARGS,
                    :put, "/dashboard/#{DASHBOARD_ID}", DASHBOARD_PAYLOAD
  end

  describe '#get_board' do
    it_behaves_like 'an api method',
                    :get_board, [DASHBOARD_ID],
                    :get, "/dashboard/#{DASHBOARD_ID}"
  end

  describe '#get_all_boards' do
    it_behaves_like 'an api method',
                    :get_all_boards, [],
                    :get, '/dashboard'
  end

  describe '#delete_board' do
    it_behaves_like 'an api method',
                    :delete_board, [DASHBOARD_ID],
                    :delete, "/dashboard/#{DASHBOARD_ID}"
  end
end
