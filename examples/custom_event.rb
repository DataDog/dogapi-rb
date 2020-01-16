require 'rubygems'
require 'dogapi'

# Create a simple client
# The host is optional here, it's a shortcut to tie event and metrics to a given host
#
# You typically want to do:
#   Dogapi::Client.new(your_actual_api_key_as_a_string, ...)
# We are using ENV to let you experiment via an environment variable.
dog = Dogapi::Client.new(ENV['DATADOG_KEY'])

# Let's use tags and aggregation
# We will send 2 related events, one error and one success.

dog.emit_event(Dogapi::Event.new("Uh-oh, something bad happened",
                                 :msg_title       => "Alert! Alert!",
                                 :aggregation_key => "job-123",
                                 :alert_type      => "error",
                                 :tags            => ["ruby", "dogapi"]
                                 ))

dog.emit_event(Dogapi::Event.new("Now that's better",
                                 :msg_title       => "All systems green",
                                 :aggregation_key => "job-123",
                                 :alert_type      => "success",
                                 :tags            => ["ruby", "dogapi"]
                                 ))
