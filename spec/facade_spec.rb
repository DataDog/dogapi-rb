require 'spec_helper'

describe "Facade", :vcr => true do

  before(:all) do
    @api_key = ENV["DATADOG_API_KEY"]
    @app_key = ENV["DATADOG_APP_KEY"]
    @dog = Dogapi::Client.new(@api_key, @app_key)
  end

  context "Client" do

    it "emit_point passes data" do
      metric_svc = double
      @dog.instance_variable_set("@metric_svc", metric_svc)
      metric_svc.should_receive(:submit) do |metric, points, scope, options|
        expect(metric).to eq "metric.name"
        expect(points[0][1]).to eq 0
        expect(scope.host).to eq "myhost"
      end
      @dog.emit_point("metric.name", 0, :host => "myhost")
    end

    it "emit_point uses localhost default" do
      metric_svc = double
      @dog.instance_variable_set("@metric_svc", metric_svc)
      metric_svc.should_receive(:submit) do |metric, points, scope, options|
        expect(scope.host).to eq Dogapi.find_localhost
      end
      @dog.emit_point("metric.name", 0)
    end

    it "emit_point can pass nil host" do
      metric_svc = double
      @dog.instance_variable_set("@metric_svc", metric_svc)
      metric_svc.should_receive(:submit) do |metric, points, scope, options|
        expect(scope.host).to eq nil
      end
      @dog.emit_point("metric.name", 0, :host => nil)
    end

  end

end
