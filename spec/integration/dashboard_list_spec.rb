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
  RESOURCE_NAME = 'dashboard/lists/manual'.freeze
  SUB_RESOURCE_NAME = 'dashboards'.freeze

  DASHBOARD_LIST_ID = 1_234_567
  DASHBOARD_LIST_NAME = 'My new dashboard list'.freeze
  DASHBOARDS = [
    {
      'type' => 'custom_timeboard',
      'id' => 1234
    },
    {
      'type' => 'custom_screenboard',
      'id' => 1234
    }
  ].freeze

  DASHBOARD_LIST_BODY = {
    name: DASHBOARD_LIST_NAME
  }.freeze

  DASHBOARD_LIST_WITH_DASHES_BODY = {
    dashboards: DASHBOARDS
  }.freeze

  describe '#create_dashboard_list' do
    it_behaves_like 'an api method',
                    :create_dashboard_list, [DASHBOARD_LIST_NAME],
                    :post, "/#{RESOURCE_NAME}", DASHBOARD_LIST_BODY
  end

  describe '#update_dashboard_list' do
    it_behaves_like 'an api method',
                    :update_dashboard_list, [DASHBOARD_LIST_ID] + [DASHBOARD_LIST_NAME],
                    :put, "/#{RESOURCE_NAME}/#{DASHBOARD_LIST_ID}", DASHBOARD_LIST_BODY
  end

  describe '#get_dashboard_list' do
    it_behaves_like 'an api method',
                    :get_dashboard_list, [DASHBOARD_LIST_ID],
                    :get, "/#{RESOURCE_NAME}/#{DASHBOARD_LIST_ID}"
  end

  describe '#get_all_dashboard_lists' do
    it_behaves_like 'an api method',
                    :get_all_dashboard_lists, [],
                    :get, "/#{RESOURCE_NAME}"
  end

  describe '#delete_dashboard_list' do
    it_behaves_like 'an api method',
                    :delete_dashboard_list, [DASHBOARD_LIST_ID],
                    :delete, "/#{RESOURCE_NAME}/#{DASHBOARD_LIST_ID}"
  end

  describe '#add_items_to_dashboard_list' do
    it_behaves_like 'an api method',
                    :add_items_to_dashboard_list, [DASHBOARD_LIST_ID] + [DASHBOARDS],
                    :post, "/#{RESOURCE_NAME}/#{DASHBOARD_LIST_ID}/#{SUB_RESOURCE_NAME}",
                    DASHBOARD_LIST_WITH_DASHES_BODY
  end

  describe '#update_items_of_dashboard_list' do
    it_behaves_like 'an api method',
                    :update_items_of_dashboard_list, [DASHBOARD_LIST_ID] + [DASHBOARDS],
                    :put, "/#{RESOURCE_NAME}/#{DASHBOARD_LIST_ID}/#{SUB_RESOURCE_NAME}",
                    DASHBOARD_LIST_WITH_DASHES_BODY
  end

  describe '#delete_items_from_dashboard_list' do
    it_behaves_like 'an api method',
                    :delete_items_from_dashboard_list, [DASHBOARD_LIST_ID] + [DASHBOARDS],
                    :delete, "/#{RESOURCE_NAME}/#{DASHBOARD_LIST_ID}/#{SUB_RESOURCE_NAME}",
                    DASHBOARD_LIST_WITH_DASHES_BODY
  end

  describe '#get_items_of_dashboard_list' do
    it_behaves_like 'an api method',
                    :get_items_of_dashboard_list, [DASHBOARD_LIST_ID],
                    :get, "/#{RESOURCE_NAME}/#{DASHBOARD_LIST_ID}/#{SUB_RESOURCE_NAME}"
  end
end

describe Dogapi::ClientV2 do
  RESOURCE_NAME = 'dashboard/lists/manual'.freeze
  SUB_RESOURCE_NAME = 'dashboards'.freeze

  DASHBOARD_LIST_ID = 1_234_567
  DASHBOARD_LIST_NAME = 'My new dashboard list'.freeze
  DASHBOARDS = [
    {
      'type' => 'custom_timeboard',
      'id' => 1234
    },
    {
      'type' => 'custom_screenboard',
      'id' => 1234
    }
  ].freeze

  describe '#add_items_to_dashboard_list' do
    it_behaves_like 'an api v2 method',
                    :add_items_to_dashboard_list, [DASHBOARD_LIST_ID] + [DASHBOARDS],
                    :post, "/#{RESOURCE_NAME}/#{DASHBOARD_LIST_ID}/#{SUB_RESOURCE_NAME}",
                    DASHBOARD_LIST_WITH_DASHES_BODY
  end

  describe '#update_items_of_dashboard_list' do
    it_behaves_like 'an api v2 method',
                    :update_items_of_dashboard_list, [DASHBOARD_LIST_ID] + [DASHBOARDS],
                    :put, "/#{RESOURCE_NAME}/#{DASHBOARD_LIST_ID}/#{SUB_RESOURCE_NAME}",
                    DASHBOARD_LIST_WITH_DASHES_BODY
  end

  describe '#delete_items_from_dashboard_list' do
    it_behaves_like 'an api v2 method',
                    :delete_items_from_dashboard_list, [DASHBOARD_LIST_ID] + [DASHBOARDS],
                    :delete, "/#{RESOURCE_NAME}/#{DASHBOARD_LIST_ID}/#{SUB_RESOURCE_NAME}",
                    DASHBOARD_LIST_WITH_DASHES_BODY
  end

  describe '#get_items_of_dashboard_list' do
    it_behaves_like 'an api v2 method',
                    :get_items_of_dashboard_list, [DASHBOARD_LIST_ID],
                    :get, "/#{RESOURCE_NAME}/#{DASHBOARD_LIST_ID}/#{SUB_RESOURCE_NAME}"
  end
end
