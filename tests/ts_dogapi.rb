require 'test/unit'
require 'dogapi'

class TestEnvironment < Test::Unit::TestCase

  def setup
    @host = ENV['DATADOG_HOST']
    @key = ENV['DATADOG_KEY']
  end

  def teardown
    ENV['DATADOG_HOST'] = @host
    ENV['DATADOG_KEY'] = @key
  end

  def test_unset
    ENV['DATADOG_HOST'] = nil
    ENV['DATADOG_KEY'] = nil
    assert_equal nil, Dogapi.find_datadog_host
    assert_equal nil, Dogapi.find_api_key
  end

  def test_set
    ENV['DATADOG_HOST'] = 'test.host'
    ENV['DATADOG_KEY'] = 'test_key'
    assert_equal 'test.host', Dogapi.find_datadog_host
    assert_equal 'test_key', Dogapi.find_api_key
  end
end

class TestClient < Test::Unit::TestCase

  def config_client_test_env
    @api_key = Dogapi.find_api_key
    if !@api_key
      @api_key = 'apikey_3'
      ENV['DATADOG_KEY'] = @api_key
    end

    @host = Dogapi.find_datadog_host
    if !@host
      @host = 'localhost:5000'
      ENV['DATADOG_HOST'] = @host
    end
  end

  def setup
    config_client_test_env
  end

  def test_simple_client
    dog = Dogapi.init(@api_key)

    dog.emit_point 'test.dogclient.emit_point',
                   999,
                   :host => 'test.dogclient.fake',
                   :device => 'eth0'

    dog.emit_points 'test.dogclient.emit_points',
                    [[Time.now - 60, 10], [Time.now - 30, 20], [Time.now, 30]],
                    :host => 'test.dogclient.fake',
                    :device => 'eth0'

    my_event = Dogapi::Event.new('Testing Event API')
    dog.emit_event my_event,
      :host => 'test.dogclient.fake',
      :device => 'eth0'
#
#    my_event = Event.new('Testing Event API with a duration')
#    event_id = dog.start_event my_event, 'test.dogclient.fake', 'eth0'
#    sleep 1
#    dog.end_event event_id
  end
end
