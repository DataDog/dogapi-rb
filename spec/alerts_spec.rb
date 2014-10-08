require 'spec_helper'

describe "Alerts", :vcr => true do

  before(:all) do
    @api_key = ENV["DATADOG_API_KEY"]
    @app_key = ENV["DATADOG_APP_KEY"]
    @dog = Dogapi::Client.new(@api_key, @app_key)
    @query = 'avg(last_10m):avg:test.metric.metric{host:test.metric.host} > 5'
  end

  context "create" do
    before(:each) do
      @new_alert = @dog.alert(@query)
    end
    after(:each) do
      @dog.delete_alert(@new_alert[1]['id'])
    end

    it "returns HTTP code 200" do
      expect(@new_alert[0]).to eq '200'
    end

    it "returns a valid event ID" do
      expect(@new_alert[1]['id']).to be_a(Fixnum)
    end

    it "returns the same query as sent" do
      expect(@new_alert[1]['query']).to eq @query
    end
  end

end
