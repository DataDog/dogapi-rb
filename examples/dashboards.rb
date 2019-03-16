require 'rubygems'
require 'dogapi'

application_key="01e679d30c75dee420da362ce4e81d6bce65e24c"
api_key="9b6ea71d495d9864521d6cc731ef67bf"
api_host="https://dd.datad0g.com"

# Create a simple client
# The host is optional here, it's a shortcut to tie event and metrics to a given host
#
# You typically want to do:
#   Dogapi::Client.new(your_actual_api_key_as_a_string, ...)
# We are using ENV to let you experiment via an environment variable.
# dog = Dogapi::Client.new(ENV['DATADOG_KEY'])

dog = Dogapi::Client.new(api_key, application_key, nil, nil, nil, nil, api_host)

# Let's use tags and aggregation
# We will send 2 related events, one error and one success.

 p dog.get_all_boards()[1]['dashboards'][0,2]
