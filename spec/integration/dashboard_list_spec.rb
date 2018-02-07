require_relative '../spec_helper'

describe Dogapi::Client do
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
                    :post, '/dashboard/lists/manual', DASHBOARD_LIST_BODY
  end

  describe '#update_dashboard_list' do
    it_behaves_like 'an api method',
                    :update_dashboard_list, [DASHBOARD_LIST_ID] + [DASHBOARD_LIST_NAME],
                    :put, "/dashboard/lists/manual/#{DASHBOARD_LIST_ID}", DASHBOARD_LIST_BODY
  end

  describe '#get_dashboard_list' do
    it_behaves_like 'an api method',
                    :get_dashboard_list, [DASHBOARD_LIST_ID],
                    :get, "/dashboard/lists/manual/#{DASHBOARD_LIST_ID}"
  end

  describe '#get_all_dashboard_lists' do
    it_behaves_like 'an api method',
                    :get_all_dashboard_lists, [],
                    :get, '/dashboard/lists/manual'
  end

  describe '#delete_dashboard_list' do
    it_behaves_like 'an api method',
                    :delete_dashboard_list, [DASHBOARD_LIST_ID],
                    :delete, "/dashboard/lists/manual/#{DASHBOARD_LIST_ID}"
  end

  describe '#add_dashboards_to_dashboard_list' do
    it_behaves_like 'an api method',
                    :add_dashboards_to_dashboard_list, [DASHBOARD_LIST_ID] + [DASHBOARDS],
                    :post, "/dashboard/lists/manual/#{DASHBOARD_LIST_ID}/dashboards", DASHBOARD_LIST_WITH_DASHES_BODY
  end

  describe '#update_dashboards_of_dashboard_list' do
    it_behaves_like 'an api method',
                    :update_dashboards_of_dashboard_list, [DASHBOARD_LIST_ID] + [DASHBOARDS],
                    :put, "/dashboard/lists/manual/#{DASHBOARD_LIST_ID}/dashboards", DASHBOARD_LIST_WITH_DASHES_BODY
  end

  describe '#delete_dashboards_from_dashboard_list' do
    it_behaves_like 'an api method',
                    :delete_dashboards_from_dashboard_list, [DASHBOARD_LIST_ID] + [DASHBOARDS],
                    :delete, "/dashboard/lists/manual/#{DASHBOARD_LIST_ID}/dashboards", DASHBOARD_LIST_WITH_DASHES_BODY
  end

  describe '#get_dashboards_for_dashboard_list' do
    it_behaves_like 'an api method',
                    :get_dashboards_for_dashboard_list, [DASHBOARD_LIST_ID],
                    :get, "/dashboard/lists/manual/#{DASHBOARD_LIST_ID}/dashboards"
  end
end
