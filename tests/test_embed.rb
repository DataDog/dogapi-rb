require 'dogapi'
require 'time'
require 'test_base.rb'

class TestEmbed < Minitest::Test
  include TestBase

  def test_get_all_embeds
    dog = Dogapi::Client.new(@api_key, @app_key)

    # Attempt API Call
    status, result = dog.get_all_embeds()
    # Sanity check results
    assert_equal status, "200", "invalid HTTP response => #{status}"
    assert result.has_key?("embedded_graphs")
  end

  def test_create_embed
    dog = Dogapi::Client.new(@api_key, @app_key)
    # create an embed using the embed id and verify that it is valid
    graph_json = '{
      "viz": "toplist",
      "requests": [{
        "q": "top(system.disk.free{$var} by {device}, 10, \'mean\', \'desc\')",
        "style": {
          "palette": "dog_classic"
        },
        "conditional_formats": [{
          "palette": "red",
          "comparator": ">",
          "value": 50000000000
        }, {
          "palette": "green",
          "comparator": ">",
          "value": 30000000000
        }]
      }]
    }'
    timeframe = "1_hour"
    size = "medium"
    legend = "no"
    title = "Sick Title!"
    description = {
      :timeframe => timeframe,
      :size => size,
      :legend => legend,
      :title => title
    }
    status, result = dog.create_embed(graph_json, description)
    # Sanity check results
    assert result["graph_title"] == title
    assert_equal status, "200", "invalid HTTP response => #{status}"
    assert result["html"].include? "legend=false"
    assert result["html"].include? "height=300"
    assert result["html"].include? "width=600"
  end

  def test_get_embed
    dog = Dogapi::Client.new(@api_key, @app_key)
    # Create an Embed to get a valid embed_id
    graph_json = '{
      "viz": "toplist",
      "requests": [{
        "q": "top(system.disk.free{$var} by {device}, 10, \'mean\', \'desc\')",
        "style": {
          "palette": "dog_classic"
        },
        "conditional_formats": [{
          "palette": "red",
          "comparator": ">",
          "value": 50000000000
        }, {
          "palette": "green",
          "comparator": ">",
          "value": 30000000000
        }]
      }]
    }'
    timeframe = "1_hour"
    size = "medium"
    legend = "no"
    title = "Sick Title!"
    description = {
      :timeframe => timeframe,
      :size => size,
      :legend => legend,
      :title => title
    }
    status, create_result = dog.create_embed(graph_json, description)
    # Sanity check results
    assert_equal status, "200", "invalid HTTP response => #{status}"
    assert create_result["html"].include? "legend=false"
    assert create_result["html"].include? "height=300"
    assert create_result["html"].include? "width=600"
    embed_id = create_result["embed_id"]
    # Get the embed using that embed id
    status, embed_without_var = dog.get_embed(embed_id)
    assert_equal status, "200", "invalid HTTP response => #{status}"
    get_embed_description = {
      :size => size,
      :legend => legend,
      :var => "val"
    }
    status, embed_with_var = dog.get_embed(embed_id, get_embed_description)
    assert_equal status, "200", "invalid HTTP response => #{status}"
    # Verify that the get requests are good
    assert embed_without_var["html"] == create_result["html"]
    assert embed_with_var["html"] != embed_without_var["html"]
    assert embed_with_var["html"].include? "legend=false"
    assert embed_with_var["html"].include? "height=300"
    assert embed_with_var["html"].include? "width=600"
    assert embed_with_var["html"].include? "var=val"
  end

  def test_enable_embed
    dog = Dogapi::Client.new(@api_key, @app_key)
    # Create an Embed to get a valid embed_id
    graph_json = '{
      "viz": "toplist",
      "requests": [{
        "q": "top(system.disk.free{$var} by {device}, 10, \'mean\', \'desc\')",
        "style": {
          "palette": "dog_classic"
        },
        "conditional_formats": [{
          "palette": "red",
          "comparator": ">",
          "value": 50000000000
        }, {
          "palette": "green",
          "comparator": ">",
          "value": 30000000000
        }]
      }]
    }'
    timeframe = "1_hour"
    size = "medium"
    legend = "no"
    title = "Sick Title!"
    description = {
      :timeframe => timeframe,
      :size => size,
      :legend => legend,
      :title => title
    }
    status, create_result = dog.create_embed(graph_json, description)
    # Sanity check results
    assert_equal status, "200", "invalid HTTP response => #{status}"
    embed_id = create_result["embed_id"]
    status, result = dog.enable_embed(embed_id)
    assert_equal status, "200", "invalid HTTP response => #{status}"
    assert result.has_key?("success")
  end

  def test_revoke_embed
    dog = Dogapi::Client.new(@api_key, @app_key)
    # Create an Embed to get a valid embed_id
    graph_json = '{
      "viz": "toplist",
      "requests": [{
        "q": "top(system.disk.free{$var} by {device}, 10, \'mean\', \'desc\')",
        "style": {
          "palette": "dog_classic"
        },
        "conditional_formats": [{
          "palette": "red",
          "comparator": ">",
          "value": 50000000000
        }, {
          "palette": "green",
          "comparator": ">",
          "value": 30000000000
        }]
      }]
    }'
    timeframe = "1_hour"
    size = "medium"
    legend = "no"
    title = "Sick Title!"
    description = {
      :timeframe => timeframe,
      :size => size,
      :legend => legend,
      :title => title
    }
    status, create_result = dog.create_embed(graph_json, description)
    # Sanity check results
    assert_equal status, "200", "invalid HTTP response => #{status}"
    embed_id = create_result["embed_id"]
    status, result = dog.revoke_embed(embed_id)
    assert_equal status, "200", "invalid HTTP response => #{status}"
    assert result.has_key?("success")
  end
end
