require 'dogapi'
require 'time'
require 'test_base.rb'

class TestUsers < Minitest::Test
  include TestBase

  def test_users
    dog = Dogapi::Client.new(@api_key, @app_key)

    # user invite (deprecated)
    emails = ["notarealperson@datadoghq.com", "alsoreallyfake@datadoghq.com"]

    invited = dog.invite(emails)
    assert_equal emails, invited[1]["emails"], invited

    # user CRUD
    handle = 'user@test.com'
    name = 'Test User'
    alternate_name = 'Test User Alt'
    alternate_email = 'user+1@test.com'

    # test create user
    # the user might already exist
    dog.create_user({
        'handle' => handle,
        'name' => name,
    })

    # reset user to original status
    status, res = dog.update_user(handle, {
        'name' => name,
        'email' => handle,
        'disabled' => false,
    })
    assert_equal handle, res['user']['handle']
    assert_equal name, res['user']['name']
    assert_equal handle, res['user']['email']

    # test get
    status, res = dog.get_user(handle)
    assert_equal handle, res['user']['handle']

    # test update user
    status, res = dog.update_user(handle, {
        'name' => alternate_name,
        'email' => alternate_email,
    })
    assert_equal handle, res['user']['handle']
    assert_equal alternate_name, res['user']['name']
    assert_equal alternate_email, res['user']['email']

    # test disable user
    status, res = dog.disable_user(handle)
    assert_equal '200', status

    # test get all users
    status, res = dog.get_all_users()
    assert_equal true, res['users'].length >= 1

  end



end
