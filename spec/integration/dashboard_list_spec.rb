# Unless explicitly stated otherwise all files in this repository are licensed under the BSD-3-Clause License.
# This product includes software developed at Datadog (https://www.datadoghq.com/).
# Copyright 2011-Present Datadog, Inc.

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
