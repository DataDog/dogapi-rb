require 'dogapi'
require 'time'
require 'test_base.rb'

class TestClient < Test::Unit::TestCase
  include TestBase

  def test_find_localhost
    # Must be an FQDN
    assert Dogapi.find_localhost.index(".") > 0
    assert Dogapi.find_localhost.split(".").length > 1
    assert Dogapi.find_localhost == %x[hostname -f].strip
  end

  def test_metrics
    # FIXME: actually verify this once there's a way to look at metrics through the api
    dog = Dogapi::Client.new(@api_key, @app_key)
    dog_r = Dogapi::Client.new(@api_key)

    dog_r.emit_point('test.metric.metric', 10, :host => 'test.metric.host')
    dog_r.emit_points('test.metric.metric', [[Time.now-5*60, 0]], :host => 'test.metric.host')

    dog_r.emit_points('test.metric.metric', [[Time.now-60, 20], [Time.now-30, 10], [Time.now, 5]], :tags => ["test:tag.1", "test:tag2"])
  end
end
