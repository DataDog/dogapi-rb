Ruby client for Datadog API v1.0.3

The Ruby client is a library suitable for inclusion in existing Ruby projects or for development of standalone scripts. It provides an abstraction on top of Datadog's raw HTTP interface for reporting events and metrics.

# Installation

## Source

Available at: https://github.com/DataDog/dogapi-rb

 $ cd dogapi-rb
 $ rake gem
 $ gem install pkg/dogapi-*.gem

## RubyGems

Gem page: https://rubygems.org/gems/dogapi

 $ gem install dogapi

# Usage

## How to find your API Key

Go to [https://app.datadoghq.com/account/setup](your setup page).

## Submit an event to Datadog

### If the event has no duration

```ruby
require 'rubygems'
require 'dogapi'

api_key = "abcdef123456"

dog = Dogapi::Client.new(api_key)

dog.emit_event(Dogapi::Event.new('Testing done, FTW'), host => "my_host")
```

### If the event has a duration

```ruby
require 'rubygems'
require 'dogapi'

api_key = "abcdef123456"

dog = Dogapi::Client.new(api_key)

dog.start_event(Dogapi::Event.new('My event with a duration'), host => "my_host") do
  # do your work here...
  # e.g. sleep 1
end
  # stop_event will be sent automatically
```

## Submit a metric to Datadog

You want to track a new metric called `some.metric.name` and have just sampled it from `my_device` on `my_host`.
Its value is 50. Here is how you submit the value to Datadog.

```ruby
require 'rubygems'
require 'dogapi'

api_key = "abcdef123456"

dog = Dogapi::Client.new(api_key)

dog.emit_point 'some.metric.name', 50.0, host => "my_host", device => "my_device"
```

Let us now assume that you have sampled the metric multiple times and you would like to submit the results.
You can use the `emit_points` method (instead of `emit_point`). Since you are submitting more than one
data point you will need to pass a list of `Time`, `float` pairs, instead of a simple `float` value.

```ruby
require 'rubygems'
require 'dogapi'

# Actual sampling takes place
t1 = Time.now
val1 = 50.0

# some time elapses
t2 = Time.now
val2 = 51.0

# some more time elapses
t3 = Time.now
val3 = -60.0

api_key = "abcdef123456"

dog = Dogapi::Client.new(api_key)

dog.emit_points 'some.metric.name', [[t1, val1], [t2, val2], [t3, val3]], host => "my_host", device => "my_device"
```
