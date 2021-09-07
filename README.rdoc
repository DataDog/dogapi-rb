= Ruby Client for Datadog API

{<img src="https://badge.fury.io/rb/dogapi.svg" alt="Gem Version" />}[http://badge.fury.io/rb/dogapi]
{<img src="https://dev.azure.com/datadoghq/dogapi-rb/_apis/build/status/DataDog.dogapi-rb?branchName=master" alt="Build Status" />}[https://dev.azure.com/datadoghq/dogapi-rb/_build/latest?definitionId=16&branchName=master]

The Ruby client is a library suitable for inclusion in existing Ruby projects or for development of standalone scripts. It provides an abstraction on top of Datadog's raw HTTP interface for reporting events and metrics.

To support all Datadog HTTP APIs, a generated library is
available which will expose all the endpoints:
datadog-api-client-ruby[https://github.com/DataDog/datadog-api-client-ruby].

= What's new?

See CHANGELOG.md for details

= Installation

== From Source

Available at: https://github.com/DataDog/dogapi-rb

    $ cd dogapi-rb
    $ bundle
    $ rake install

== Using RubyGems

Gem page: https://rubygems.org/gems/dogapi

    $ gem install dogapi

If you get a permission error, you might need to run the install process with sudo:

    $ sudo gem install dogapi

If you get a LoadError, missing mkmf, you need to install the development packages for ruby.

    # on ubuntu e.g.
    $ sudo apt-get install ruby-dev

= Usage

== Supported Versions

This project currently works with Ruby versions 1.9.3+

*Note* Newer features and new endpoint support may no longer support EOL Ruby versions but
the client should still intialize and allow metric/event submission.

== How to find your API and application keys

Go to your setup page[https://app.datadoghq.com/account/settings].

== A word about hosts and devices

Events and metric data points can be attached to hosts
to take advantage of automatic tagging with the host's tags.

If you want to attach events and points to a specific device
on a host, simply specify the device when calling emit functions.

== Configure the Datadog API Url


    require 'rubygems'
    require 'dogapi'

    api_key = "abcdef123456"
    application_key = "fedcba654321"

    # by default the API Url will be set to https://api.datadoghq.com
    dog = Dogapi::Client.new(api_key, application_key)
    p dog.datadog_host  # prints https://api.datadoghq.com

    # API Url can be passed to the initializer...
    dog = Dogapi::Client.new(api_key, application_key, nil, nil, nil, nil, 'https://myproxy.local')
    p dog.datadog_host  # prints https://myproxy.local

    # ...or set on the client instance directly
    dog = Dogapi::Client.new(api_key, application_key)
    dog.datadog_host = 'https://myproxy.local'
    p dog.datadog_host  # prints https://myproxy.local

    # in any case, contents of the DATADOG_HOST env var take precedence
    ENV['DATADOG_HOST'] = https://myproxy.local
    dog = Dogapi::Client.new(api_key, application_key)
    p dog.datadog_host  # prints https://myproxy.local


== Submit an event to Datadog


    require 'rubygems'
    require 'dogapi'

    api_key = "abcdef123456"

    # submitting events doesn't require an application_key, so we don't bother setting it
    dog = Dogapi::Client.new(api_key)

    dog.emit_event(Dogapi::Event.new('Testing done, FTW'), :host => "my_host")


== Tag a host in Datadog


    require 'rubygems'
    require 'dogapi'

    api_key = "abcdef123456"
    application_key = "fedcba654321"

    dog = Dogapi::Client.new(api_key, application_key)

    dog.add_tags("my_host", ["tagA", "tagB"])


== Submit a metric to Datadog

You want to track a new metric called +some+.+metric+.+name+ and have just sampled it from +my_device+ on +my_host+.
Its value is 50. Here is how you submit the value to Datadog.


    require 'rubygems'
    require 'dogapi'

    api_key = "abcdef123456"

    # submitting metrics doesn't require an application_key, so we don't bother setting it
    dog = Dogapi::Client.new(api_key)

    dog.emit_point('some.metric.name', 50.0, :host => "my_host", :device => "my_device")


Let us now assume that you have sampled the metric multiple times and you would like to submit the results.
You can use the +emit_points+ method (instead of +emit_point+). Since you are submitting more than one
data point you will need to pass a list of +Time+, +float+ pairs, instead of a simple +float+ value.


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

    dog.emit_points('some.metric.name', [[t1, val1], [t2, val2], [t3, val3]], :host => "my_host", :device => "my_device")

If you want to specify the metric type, using the example above you can pass in a symbol key with :type and a value of a metric type such as counter, gauge or rate. 

    dog.emit_points('some.metric.name', [[t1, val1], [t2, val2], [t3, val3]], :host => "my_host", :device => "my_device", :type => 'counter' )

If you want to add metric tags, using the example above you can pass in a symbol key with :tags and an array of tags.

    dog.emit_points('some.metric.name', [[t1, val1], [t2, val2], [t3, val3]], :host => "my_host", :device => "my_device", :tags => ['frontend', 'app:webserver'] )

== Get points from a Datadog metric

    require 'rubygems'
    require 'dogapi'

    api_key = "abcd123"
    application_key = "brec1252"

    dog = Dogapi::Client.new(api_key, application_key)

    # get points from the last hour
    from = Time.now - 3600
    to = Time.now

    query = 'sum:metric.count{*}.as_count()'

    dog.get_points(query, from, to)
