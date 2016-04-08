require 'dogapi'
require 'time'
require 'test_base.rb'
require 'open-uri'

class TestScreenboard < Minitest::Test
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

    open(share_result["public_url"]) do |f|
      assert_equal f.status.first, "200", "invalid HTTP response => #{status}"
    end

    status, revoke_result = dog.revoke_screenboard(result["id"])
    assert_equal status, "200", "invalid HTTP response => #{status}"

    ex = assert_raises OpenURI::HTTPError do
      open(share_result["public_url"])
    end
    assert_equal ex.message, "404 Not Found"

    status, del_result = dog.delete_screenboard(result["id"])
    assert_equal status, "200", "invalid HTTP response => #{status}"
    assert del_result["id"] == result["id"]

    status, result = dog.get_all_screenboards()
    assert_equal status, "200", "invalid HTTP response => #{status}"

  end
end
