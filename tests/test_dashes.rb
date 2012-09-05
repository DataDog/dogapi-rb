require 'dogapi'
require 'time'
require 'test_base.rb'

class TestDashes < Test::Unit::TestCase
  include TestBase

  def test_dashes
    dog = Dogapi::Client.new(@api_key, @app_key)

    # Create a dashboard.
    title = 'foobar'
    description = 'desc'
    graphs =  [{
      "definition" => {
        "events" => [],
        "requests "=> [
          {"q" => "avg:system.mem.free{*}"}
        ],
      "viz" => "timeseries"
      },
      "title" => "Average Memory Free"
    }]

    status, dash_response = dog.create_dashboard(title, description, graphs)
    assert_equal "200", status, "Creation failed"

    dash_id = dash_response["dash"]["id"]

    # Fetch the dashboard and assert all is well.
    status, dash_response = dog.get_dashboard(dash_id)
    assert_equal "200", status, "Fetch failed"
    dash = dash_response["dash"]
    assert_equal title, dash["title"]
    assert_equal description, dash["description"]
    assert_equal graphs, dash["graphs"]

    # Update the dashboard.
    title = 'blahfoobar'
    description = 'asdfdesc'
    graphs =  [{
      "definition" => {
        "events" => [],
        "requests "=> [
          {"q" => "sum:system.mem.free{*}"}
        ],
      "viz" => "timeseries"
      },
      "title" => "Sum Memory Free"
    }]

    status, dash_response = dog.update_dashboard(dash_id, title, description, graphs)
    assert_equal "200", status, "Updated failed"

    # Fetch the dashboard and assert all is well.
    status, dash_response = dog.get_dashboard(dash_id)
    assert_equal "200", status, "Fetch failed"
    dash = dash_response["dash"]
    assert_equal title, dash["title"]
    assert_equal description, dash["description"]
    assert_equal graphs, dash["graphs"]

    # Delete the dashboard.
    status, dash_response = dog.delete_dashboard(dash_id)
    assert_equal "204", status, "Deleted failed"

    # Fetch the dashboard and assert all it's gone.
    status, dash_response = dog.get_dashboard(dash_id)
    assert_equal "404", status, "Still there failed"

  end
end
