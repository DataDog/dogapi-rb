require 'test/unit'
require 'dogapi'
require 'time'

class TestClient < Test::Unit::TestCase

  def config_client_test_env
    @api_key = ENV['DATADOG_API_KEY']
    @app_key = ENV['DATADOG_APP_KEY']
    if not @api_key or not @app_key
      puts "\n"
      abort "To run tests in your environment, set 'DATADOG_API_KEY' and 'DATADOG_APP_KEY' to appropriate values for your account. Be aware that the tests will submit data, some of which won't be removed at the end.\n\n"
    end
  end

  def setup
    config_client_test_env()
  end

  def test_tags
    hostname = 'test.tag.host'
    dog = Dogapi::Client.new(@api_key, @app_key)

    # post a metric to make sure the test host context exists
    dog.emit_point('test.tag.metric', 1, :host => hostname)

    dog.all_tags()

    dog.detatch_tags(hostname)
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

    dog.detatch_tags(hostname)
    code, resp = dog.host_tags(hostname)
    assert resp["tags"].size == 0
  end

  def test_events
    now = Time.now()

    now_ts = now
    now_title = 'end test title ' + now_ts.to_i.to_s
    now_message = 'test message ' + now_ts.to_i.to_s

    before_ts = (now - 5*60)
    before_title = 'start test title ' + before_ts.to_i.to_s
    before_message = 'test message ' + before_ts.to_i.to_s

    dog = Dogapi::Client.new(@api_key, @app_key)

    code, resp = dog.emit_event(Dogapi::Event.new(now_message, :msg_title =>now_title, :date_happened => now_ts))
    now_event_id = resp["event"]["id"]
    sleep 1
    code, resp = dog.emit_event(Dogapi::Event.new(before_message, :msg_title =>before_title, :date_happened => before_ts))
    before_event_id = resp["event"]["id"]

    code, resp = dog.stream(before_ts, now_ts + 1)
    stream = resp["events"]

    assert stream.last['title'] == before_title
    assert stream.first['title'] == now_title

    code, resp = dog.get_event(now_event_id)
    now_event = resp['event']
    code, resp = dog.get_event(before_event_id)
    before_event = resp['event']

    assert now_event['text'] == now_message
    assert before_event['text'] == before_message
  end

  def test_metrics
    # FIXME: actually verify this once there's a way to look at metrics through the api
    dog = Dogapi::Client.new(@api_key, @app_key)

    dog.emit_point('test.metric.metric', 10, :host => 'test.metric.host')
    dog.emit_points('test.metric.metric', [[Time.now-5*60, 0]], :host => 'test.metric.host')
  end

end
