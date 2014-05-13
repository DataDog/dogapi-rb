require 'spec_helper'

describe "Facade", :vcr => true do

  before(:all) do
    @api_key = ENV["DATADOG_API_KEY"]
    @app_key = ENV["DATADOG_APP_KEY"]
    @job_number = ENV['TRAVIS_JOB_NUMBER'] || '1'
    @dog = Dogapi::Client.new(@api_key, @app_key)
  end

  context "Client" do

    before(:each) do
      @dogmock = Dogapi::Client.new(@api_key, @app_key)
      @metric_svc = double
      @dogmock.instance_variable_set("@metric_svc", @metric_svc)
    end

    it "emit_point passes data" do
      expect(@metric_svc).to receive(:submit) do |metric, points, scope, options|
        expect(metric).to eq "metric.name"
        expect(points[0][1]).to eq 0
        expect(scope.host).to eq "myhost"
      end
      @dogmock.emit_point("metric.name", 0, :host => "myhost")
    end

    it "emit_point uses localhost default" do
      expect(@metric_svc).to receive(:submit) do |metric, points, scope, options|
        expect(scope.host).to eq Dogapi.find_localhost
      end
      @dogmock.emit_point("metric.name", 0)
    end

    it "emit_point can pass nil host" do
      expect(@metric_svc).to receive(:submit) do |metric, points, scope, options|
        expect(scope.host).to be_nil
      end
      @dogmock.emit_point("metric.name", 0, :host => nil)
    end

  end

  context "Events" do

    it "emits events and retrieves them" do
      now = Time.now()

      # Tag the events with the build number, because Travis parallel testing
      # can cause problems with the event stream
      tags = ["test-run:#{@job_number}"]

      now_ts = now
      now_title = 'dogapi-rb end test title ' + now_ts.to_i.to_s
      now_message = 'test message'


      event = Dogapi::Event.new(now_message, :msg_title => now_title,
        :date_happened => now_ts, :tags => tags)

      code, resp = @dog.emit_event(event)
      now_event_id = resp["event"]["id"]
      sleep 5
      code, resp = @dog.get_event(now_event_id)
      expect(resp['event']).not_to be_nil
      expect(resp['event']['text']).to eq(now_message)
    end

    it "emits events with specified priority" do
      event = Dogapi::Event.new('test message', :msg_title => 'title', :date_happened => Time.now(), :priority => "low")
      code, resp = @dog.emit_event(event)
      low_event_id = resp["event"]["id"]
      sleep 5
      code, resp = @dog.get_event(low_event_id)
      expect(resp['event']).not_to be_nil
      low_event = resp['event']
      expect(low_event['priority']).to eq("low")
    end

    it "emits aggregate events" do
      now = Time.now()
      code, resp = @dog.emit_event(Dogapi::Event.new("Testing Aggregation (first)", :aggregation_key => now.to_i))
      first = resp["event"]["id"]
      code, resp = @dog.emit_event(Dogapi::Event.new("Testing Aggregation (second)", :aggregation_key => now.to_i))
      second = resp["event"]["id"]
      sleep 5
      code, resp = @dog.get_event(first)
      expect(resp["event"]).not_to be_nil
      code, resp = @dog.get_event(second)
      expect(resp["event"]).not_to be_nil
    end

  end

  context "Tags" do
    it "adds, updates and detaches tags" do
      hostname = "test.tag.host"

      @dog.emit_point('test.tag.metric', 1, :host => hostname)
      sleep 5
      @dog.detach_tags(hostname)
      code, resp = @dog.host_tags(hostname)
      expect(resp["tags"]).to be_empty

      @dog.add_tags(hostname, ['test.tag.1', 'test.tag.2'])
      code, resp = @dog.host_tags(hostname)
      new_tags = resp["tags"]
      expect(new_tags).to match_array(['test.tag.1', 'test.tag.2'])

      @dog.add_tags(hostname, ['test.tag.3'])
      code, resp = @dog.host_tags(hostname)
      new_tags = resp["tags"]
      expect(new_tags).to match_array(['test.tag.1', 'test.tag.2', 'test.tag.3'])

      @dog.detach_tags(hostname)
      code, resp = @dog.host_tags(hostname)
      expect(resp["tags"]).to be_empty
    end
  end

end
