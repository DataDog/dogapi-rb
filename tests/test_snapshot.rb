require 'dogapi'
require 'time'
require 'test_base.rb'

class TestSnapshot < Minitest::Test
  include TestBase

  def test_snapshot
    dog = Dogapi::Client.new(@api_key, @app_key)

    metric_query = "system.load.1{*}"
    event_query = "*"
    end_ts = Time.now().to_i
    start_ts = end_ts - 60 * 60 # go back 1 hour

    # Try without an event query
    status, result = dog.graph_snapshot(metric_query, start_ts, end_ts)
    assert_equal status, "200", "invalid HTTP response: #{status}"
    assert result["metric_query"] = metric_query

    # Try with an event query
    status, result = dog.graph_snapshot(metric_query, start_ts, end_ts,
                                  event_query=event_query)
    assert_equal status, "200", "invalid HTTP response: #{status}"
    assert result["metric_query"] = metric_query
    assert result["event_query"] = event_query
  end
end
