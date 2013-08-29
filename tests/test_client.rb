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

  def test_tags
    hostname = "test.tag.host.#{job_number}"
    dog = Dogapi::Client.new(@api_key, @app_key)

    # post a metric to make sure the test host context exists
    dog.emit_point('test.tag.metric', 1, :host => hostname)

    # Disable this call until we fix the timeouts
    # dog.all_tags()

    sleep 3

    dog.detach_tags(hostname)
    code, resp = dog.host_tags(hostname)
    assert resp["tags"].size == 0

    dog.add_tags(hostname, ['test.tag.1', 'test.tag.2'])
    code, resp = dog.host_tags(hostname)
    new_tags = resp["tags"]
    assert new_tags.size == 2
    assert new_tags.include?('test.tag.1')
    assert new_tags.include?('test.tag.2')

    dog.add_tags(hostname, ['test.tag.3'])
    code, resp = dog.host_tags(hostname)
    new_tags = resp["tags"]
    assert new_tags.size == 3
    assert new_tags.include?('test.tag.1')
    assert new_tags.include?('test.tag.2')
    assert new_tags.include?('test.tag.3')

    dog.update_tags(hostname, ['test.tag.4'])
    code, resp = dog.host_tags(hostname)
    new_tags = resp["tags"]
    assert new_tags.size == 1
    assert new_tags.include?('test.tag.4')

    dog.detach_tags(hostname)
    code, resp = dog.host_tags(hostname)
    assert resp["tags"].size == 0
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
