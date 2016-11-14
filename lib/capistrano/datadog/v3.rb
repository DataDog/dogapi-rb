require 'benchmark'
require 'delegate'
require 'sshkit/formatters/pretty'
require 'sshkit/formatters/simple_text'

# Capistrano v3 uses Rake's DSL instead of its own

module Rake
  class Task
    alias old_invoke invoke
    def invoke(*args)
      result = nil
      reporter = Capistrano::Datadog.reporter
      task_name = name
      reporter.current_task = task_name
      timing = Benchmark.measure(task_name) do
        result = old_invoke(*args)
      end
      reporter.record_task(task_name, timing.real, roles,
        Capistrano::Configuration.env.fetch(:stage), Capistrano::Configuration.env.fetch(:application))
      result
    end
  end
end

module Capistrano
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
  Capistrano::Datadog.submit api_key
end
