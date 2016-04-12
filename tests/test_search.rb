require 'dogapi'
require 'time'
require 'test_base.rb'

class TestSearch < Minitest::Test
  include TestBase

  def test_search
    dog = Dogapi::Client.new(@api_key, @app_key)

    facets = ["hosts", "metrics"]
    facets.each do |facet|
      status, results_body = dog.search("#{facet}:foo")
      results = results_body["results"]
      assert_equal status, "200", "failed search #{facet} facet"
      assert results[facet].kind_of?(Array), "#{facet} facet doesnt exist"
    end

  end
end
