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

  describe '#get_all_boards_no_args' do
    it 'only queries one endpoint' do
      url = api_url + '/dashboards'
      stub_request(:get, /#{url}/).to_return(body: '{}').then.to_raise(StandardError)
      expect(dog.send(:get_all_boards)).to eq ['200', {}]
      params = { query: 'dashboard_type:custom_screenboard,custom_timeboard' }
      params.merge! default_query
      expect(WebMock).to have_requested(:get, url).with(
        query: params
      )
    end
  end

  describe '#get_all_boards_free_layout' do
    it 'only queries one endpoint' do
      url = api_url + '/dashboards'
      stub_request(:get, /#{url}/).to_return(body: '{}').then.to_raise(StandardError)
      expect(dog.send(:get_all_boards, 'free')).to eq ['200', {}]
      params = { query: 'dashboard_type:custom_screenboard' }
      params.merge! default_query
      expect(WebMock).to have_requested(:get, url).with(
        query: params
      )
    end
  end

  describe '#get_all_boards_ordered_layout' do
    it 'only queries one endpoint' do
      url = api_url + '/dashboards'
      stub_request(:get, /#{url}/).to_return(body: '{}').then.to_raise(StandardError)
      expect(dog.send(:get_all_boards, 'ordered')).to eq ['200', {}]
      params = { query: 'dashboard_type:custom_timeboard' }
      params.merge! default_query
      expect(WebMock).to have_requested(:get, url).with(
        query: params
      )
    end
  end

  describe '#delete_board' do
    it_behaves_like 'an api method',
                    :delete_board, [DASHBOARD_ID],
                    :delete, "/dashboard/#{DASHBOARD_ID}"
  end
end
