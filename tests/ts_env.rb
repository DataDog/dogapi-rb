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
