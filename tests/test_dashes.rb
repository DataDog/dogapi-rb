require 'dogapi'
require 'time'
require 'test_base.rb'

class TestDashes < Test::Unit::TestCase
  include TestBase

  def test_dashes
    dog = Dogapi::Client.new(@api_key, @app_key)

    # Get the Travis ENV and use that to 'seed' the dashboard titles, in attempt
    # to prevent parallel testing conflicts
    job_number = ENV['TRAVIS_JOB_NUMBER'] || '1'

    # Create a dashboard.
    title = "foobar-#{job_number}"
    description = 'desc'
    graphs =  [{
      "definition" => {
        "events" => [],
        "requests" => [
          {"q" => "avg:system.mem.free{*}"}
        ],
        "viz" => "timeseries"
      },
      "title" => "Average Memory Free"
    }]

    status, dash_response = dog.create_dashboard(title, description, graphs)
    assert_equal "200", status, "Creation failed, response: #{dash_response}"

    dash_id = dash_response["dash"]["id"]

    # Fetch the dashboard and assert all is well.
    status, dash_response = dog.get_dashboard(dash_id)
    assert_equal "200", status, "Fetch failed, response: #{dash_response}"
    dash = dash_response["dash"]
    assert_equal title, dash["title"]
    assert_equal description, dash["description"]
    assert_equal graphs, dash["graphs"]

    # Update the dashboard.
    title = "blahfoobar-#{job_number}"
    description = 'asdfdesc'
    graphs =  [{
      "definition" => {
        "events" => [],
        "requests" => [
          {"q" => "sum:system.mem.free{*}"}
        ],
        "viz" => "timeseries"
      },
      "title" => "Sum Memory Free"
    }]

    status, dash_response = dog.update_dashboard(dash_id, title, description, graphs)
    assert_equal "200", status, "Updated failed, response: #{dash_response}"

    # Fetch the dashboard and assert all is well.
    status, dash_response = dog.get_dashboard(dash_id)
    assert_equal "200", status, "Fetch failed, response: #{dash_response}"
    dash = dash_response["dash"]
    assert_equal title, dash["title"]
    assert_equal description, dash["description"]
    assert_equal graphs, dash["graphs"]

    # Fetch all the dashboards.
    status, dash_response = dog.get_dashboards()
    assert_equal "200", status, "fetch failed, response: #{dash_response}"
    dashes = dash_response["dashes"]
    assert dashes.length
    dash = dashes.sort{|x,y| x["id"] <=> y["id"]}.last
    assert_equal title, dash["title"]
    assert_equal dash_id.to_s, dash["id"]

    # Delete the dashboard.
    status, dash_response = dog.delete_dashboard(dash_id)
    assert_equal "204", status, "Deleted failed, response: #{dash_response}"

    # Fetch the dashboard and assert all it's gone.
    status, dash_response = dog.get_dashboard(dash_id)
    assert_equal "404", status, "Still there failed, response: #{dash_response}"

  end
end
