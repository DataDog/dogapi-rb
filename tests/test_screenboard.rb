require 'dogapi'
require 'time'
require 'test_base.rb'

class TestScreenboard < Test::Unit::TestCase
  include TestBase

  def test_screenboard
    dog = Dogapi::Client.new(@api_key, @app_key)

        board = {
            "width" => 1024,
            "height" => 768,
            "board_title" => "dogapi-rb test",
            "widgets" => [
                {
                    "type" => "event_stream",
                    "title" => false,
                    "height" => 57,
                    "width" => 59,
                    "y" => 18,
                    "x" => 84,
                    "query" => "tags:release",
                    "timeframe" => "1w"
                },
                {
                  "type" => "image",
                  "height" => 20,
                  "width" => 32,
                  "y" => 7,
                  "x" => 32,
                  "url" => "http://path/to/image.jpg"
                }
            ]
        }

        updated_board = {
            "width" => 1024,
            "height" => 768,
            "board_title" => "dogapi test",
            "widgets" => [
                {
                  "type" => "image",
                  "height" => 20,
                  "width" => 32,
                  "y" => 7,
                  "x" => 32,
                  "url" => "http://path/to/image.jpg"
                }
            ]
        }

    status, result = dog.create_screenboard(board)
    assert_equal status, "200", "invalid HTTP response => #{status}"
    assert result["widgets"] == board["widgets"]

    status, result = dog.get_screenboard(result["id"])
    assert_equal status, "200", "invalid HTTP response => #{status}"
    assert result["widgets"] == board["widgets"]

    status, result = dog.update_screenboard(result["id"], updated_board)
    assert_equal status, "200", "invalid HTTP response => #{status}"
    assert result["widgets"] == updated_board["widgets"]

    status, share_result = dog.share_screenboard(result["id"])
    assert_equal status, "200", "invalid HTTP response => #{status}"
    assert share_result["board_id"] == result["id"]

    status, del_result = dog.delete_screenboard(result["id"])
    assert_equal status, "200", "invalid HTTP response => #{status}"
    assert del_result["id"] == result["id"]

  end
end
