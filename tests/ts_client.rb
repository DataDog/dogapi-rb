require 'test/unit'
require 'dogapi'

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

    my_event = Dogapi::Event.new('Testing Event API with a duration')
    dog.start_event(my_event, :host =>'test.dogclient.fake', :device => 'eth0') do
      sleep 1
    end
  end
end
