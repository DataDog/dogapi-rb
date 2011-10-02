require 'test/unit'
require 'time'
require 'dogapi'

class TestMetricClient < Test::Unit::TestCase

  def config_client_test_env
    @api_key = 'apikey_2'
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
  end

end
