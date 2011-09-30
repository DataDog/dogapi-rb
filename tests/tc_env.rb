require 'test/unit'
require 'dogapi'

class TestEnvironment < Test::Unit::TestCase

  def setup
    @host = ENV['DATADOG_HOST']
  end

  def teardown
    ENV['DATADOG_HOST'] = @host
  end

  def test_unset
    ENV['DATADOG_HOST'] = nil
    assert_equal "https://app.datadoghq.com", Dogapi.find_datadog_host
  end

  def test_set
    ENV['DATADOG_HOST'] = 'test.host'
    assert_equal 'test.host', Dogapi.find_datadog_host
  end
end
