require 'test/unit'
require 'dogapi'
require 'time'

class TestComments < Test::Unit::TestCase

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

  def test_comments
    dog = Dogapi::Client.new(@api_key, @app_key)

    # Create a comment
    dog.comment('test comment')

    # Create a comment as a user.
    handle = "carlo+14.1@datadoghq.com"
    status, comment_response = dog.comment('test comment with handle', :handle => handle)
    comment = comment_response["comment"]
    assert_equal "200", status, "Comment did not succeed"

    # Reply to a comment.
    status, reply_response = dog.comment('replying!', :related_event_id => comment["id"])
    reply = reply_response["comment"]
    assert_equal "200", status, "Reply did not work."
    # HACK: issue #900 on dogweb. id types should be the same.
    assert_equal comment["id"].to_s, reply["related_event_id"]

    # Update a comment.
    dog.update_comment(reply["related_event_id"], :message => "Updating the comment")

    # Delete a comment.
    status, to_delete_response = dog.comment("im dead")
    to_delete = to_delete_response["comment"]
    dog.delete_comment(to_delete["id"])

  end
end
