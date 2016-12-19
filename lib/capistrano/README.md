# capistrano/datadog

Instrument your [Capistrano](https://github.com/capistrano/capistrano) deploys, generating events in Datadog which you can correlate with metrics in order to figure out what caused production issues.

To set up your Capfile:

    require "capistrano/datadog"
    set :datadog_api_key, "my_api_key"
    # optionally
    # create an event for every host
    set :datadog_record_hosts, true
    # only push the production event
    set :datadog_event_filter, proc { |event, hosts| event.msg_title.include?('ran production') ? [event, hosts] : nil }

You can find your Datadog API key [here](https://app.datadoghq.com/account/settings#api). If you don't have a Datadog account, you can sign up for one [here](http://www.datadoghq.com/).

`capistrano/datadog` will capture each Capistrano task that that Capfile runs, including the roles that the task applies to and any logging output that it emits and submits them as events to Datadog at the end of the execution of all the tasks. If sending to Datadog fails for any reason, your scripts will still succeed.

