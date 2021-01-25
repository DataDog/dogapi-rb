# Unless explicitly stated otherwise all files in this repository are licensed under the BSD-3-Clause License.
# This product includes software developed at Datadog (https://www.datadoghq.com/).
# Copyright 2011-Present Datadog, Inc.

require 'benchmark'
require 'delegate'
require 'sshkit/formatters/pretty'
require 'sshkit/formatters/simple_text'

# Capistrano v3 uses Rake's DSL instead of its own

module Rake
  class Task
    alias old_invoke invoke
    def invoke(*args)
      reporter = Capistrano::Datadog.reporter
      event_filter = Capistrano::Configuration.env.fetch(:datadog_event_filter)
      if event_filter
        reporter.event_filter = event_filter
      end
      task_name = name
      stage = Capistrano::Configuration.env.fetch(:stage)
      application = Capistrano::Configuration.env.fetch(:application)
      reporter.record_task(task_name, roles, stage, application) do
        old_invoke(*args)
      end
    end
  end
end

module Capistrano
  module DSL
    alias old_on on
    def on(hosts, *args, &block)
      old_on(hosts, *args) do |host|
        if Capistrano::Configuration.env.fetch(:datadog_record_hosts)
          Capistrano::Datadog.reporter.record_hostname(host)
        end
        self.instance_exec(host, &block)
      end
    end
  end

  module Datadog
    class CaptureIO < SimpleDelegator
      def initialize(wrapped)
        super
        @wrapped = wrapped
      end

      def write(*args)
        # Check if Capistrano version >= 3.5.0
        if Gem::Version.new(VERSION) >= Gem::Version.new('3.5.0')
          @wrapped << args.join
        else
          @wrapped.write(*args)
        end
        args.each { |arg| Capistrano::Datadog.reporter.record_log(arg) }
      end
      alias :<< :write
    end
  end
end

module SSHKit
  module Formatter
    class Pretty
      def initialize(oio)
        super(Capistrano::Datadog::CaptureIO.new(oio))
      end
    end

    class SimpleText
      def initialize(oio)
        super(Capistrano::Datadog::CaptureIO.new(oio))
      end
    end
  end
end

at_exit do
  api_key = Capistrano::Configuration.env.fetch :datadog_api_key
  use_getlogin = Capistrano::Configuration.env.fetch :use_getlogin
  datadog_host = Capistrano::Configuration.env.fetch :datadog_host
  if use_getlogin.nil?
    Capistrano::Datadog.submit api_key, true, datadog_host
  else
    Capistrano::Datadog.submit api_key, use_getlogin, datadog_host
  end
end
