require 'test/unit'
require 'time'
require 'dogapi'

class TestEnvironment < Test::Unit::TestCase

  def config_client_test_env
    @api_key = Dogapi.find_api_key
    if !@api_key
      @api_key = 'apikey_2'
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

  def test_submit_metric
    metric_service = Dogapi::MetricService.new(@host)
    scope = Dogapi::Scope.new('test.dogclient.fake', 'eth0')
    metric = 'test.dogclient.metric.submit_metric'
    points = [
      [Time.now-90, 1.0],
      [Time.now-60, 2.0],
      [Time.now-30, 4.0],
      [Time.now,    8.0]
    ]
    res = metric_service.submit(@api_key, scope, metric, points)
    assert_equal(res['status'], 'ok')
    assert_equal(res['results'].size, 1)
    r = res['results'][0]
    assert_equal(r['host'], scope.host)
    if scope.device
      assert_equal(r['device'], scope.device)
    end
    assert_equal(r['metric'], metric)
    assert_equal(r['length'], points.size)
  end

end
