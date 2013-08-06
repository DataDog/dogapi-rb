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
    assert code == 200, "resp code #{code}"
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

  def test_events
    now = Time.now()

    # Tag the events with the build number, because Travis parallel testing
    # can cause problems with the event stream
    tags = ["test-run:#{job_number}"]

    now_ts = now
    now_title = 'dogapi-rb end test title ' + now_ts.to_i.to_s
    now_message = 'test message ' + now_ts.to_i.to_s

    before_ts = (now - 5*60)
    before_title = 'dogapi-rb start test title ' + before_ts.to_i.to_s
    before_message = 'test message ' + before_ts.to_i.to_s

    dog = Dogapi::Client.new(@api_key, @app_key)
    dog_r = Dogapi::Client.new(@api_key)

    e1 = Dogapi::Event.new(now_message, :msg_title => now_title,
      :date_happened => now_ts, :tags => tags)
    e2 = Dogapi::Event.new(before_message, :msg_title => before_title,
      :date_happened => before_ts, :tags => tags)

    code, resp = dog_r.emit_event(e1)
    now_event_id = resp["event"]["id"]
    code, resp = dog_r.emit_event(e2)
    before_event_id = resp["event"]["id"]

    sleep 5

    code, resp = dog.stream(before_ts, now_ts + 1, :tags => tags)
    stream = resp["events"]

    code, resp = dog.get_event(now_event_id)
    assert code == 200 || code == 202, "resp code #{code}"
    now_event = resp['event']

    code, resp = dog.get_event(before_event_id)
    assert code == 200 || code == 202, "resp code #{code}"
    before_event = resp['event']

    assert now_event['text'] == now_message
    assert before_event['text'] == before_message

    # Testing priorities
    code, resp = dog_r.emit_event(Dogapi::Event.new(now_message, :msg_title => now_title, :date_happened => now_ts, :priority => "low"))
    low_event_id = resp["event"]["id"]

    sleep 5

    code, resp = dog.get_event(low_event_id)
    assert code == 200 || code == 202, "resp code #{code}"
    low_event = resp['event']
    assert low_event['priority'] == "low"

    # Testing aggregates
    agg_ts = Time.now()
    code, resp = dog_r.emit_event(Dogapi::Event.new("Testing Aggregation (first)", :aggregation_key => now_ts.to_i))
    first = resp["event"]["id"]
    code, resp = dog_r.emit_event(Dogapi::Event.new("Testing Aggregation (second)", :aggregation_key => now_ts.to_i))
    second = resp["event"]["id"]

    sleep 3

    code, resp = dog.get_event(first)
    agg1 = resp["event"]
    code, resp = dog.get_event(second)
    agg2 = resp["event"]

    # FIXME Need to export is_aggregate/children fields
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
