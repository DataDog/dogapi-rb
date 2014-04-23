require "benchmark"
require "delegate"

# Capistrano v2

# Monkeypatch capistrano to collect data about the tasks that it's running
module Capistrano
  class Configuration
    module Execution
      # Attempts to locate the task at the given fully-qualified path, and
      # execute it. If no such task exists, a Capistrano::NoSuchTaskError
      # will be raised.
      # Also, capture the time the task took to execute, and the logs it
      # outputted for submission to Datadog
      def find_and_execute_task(path, hooks = {})
        task = find_task(path) or raise NoSuchTaskError, "the task `#{path}' does not exist"
        result = nil
        reporter = Capistrano::Datadog.reporter
        task_name = task.fully_qualified_name
        timing = Benchmark.measure(task_name) do
          # Set the current task so that the logger knows which task to
          # associate the logs with
          reporter.current_task = task_name
          trigger(hooks[:before], task) if hooks[:before]
          result = execute_task(task)
          trigger(hooks[:after], task) if hooks[:after]
          reporter.current_task = nil
        end

        # Record the task name, its timing and roles
        roles = task.options[:roles]
        if roles.is_a? Proc
          roles = roles.call
        end
        reporter.record_task(task_name, timing.real, roles, task.namespace.variables[:stage], fetch(:application))

        # Return the original result
        result
      end
    end
  end

  class Logger
    # Make the device attribute writeable so we can swap it out
    # with something that captures logging out by task
    attr_accessor   :device
  end
end


module Capistrano
  module Datadog
    class LogCapture < SimpleDelegator
      def puts(message)
        Capistrano::Datadog::reporter.record_log message
        __getobj__.puts message
      end
    end

    Configuration.instance(:must_exist).load do
      # Wrap the existing logging target with the Datadog capture class
      logger.device = Datadog::LogCapture.new logger.device

      # Trigger the Datadog submission once all the tasks have run
      on :exit, "datadog:submit"
      namespace :datadog do
        desc "Submit the tasks that have run to Datadog as events"
        task :submit do |ns|
          Capistrano::Datadog.submit variables[:datadog_api_key]
        end
      end
    end
  end
end
