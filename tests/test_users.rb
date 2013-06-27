require 'dogapi'
require 'time'
require 'test_base.rb'

class TestUsers < Test::Unit::TestCase
  include TestBase

  def test_users
    dog = Dogapi::Client.new(@api_key, @app_key)

    emails = ["notarealperson@datadoghq.com", "alsoreallyfake@datadoghq.com"]

    invited = dog.invite(emails)
    assert_equal emails, invited[1]["emails"], invited
  end
end
