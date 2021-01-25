# Unless explicitly stated otherwise all files in this repository are licensed under the BSD-3-Clause License.
# This product includes software developed at Datadog (https://www.datadoghq.com/).
# Copyright 2011-Present Datadog, Inc.

require 'benchmark'
require 'delegate'

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
      def find_and_execute_task(path, hooks= {})
        task = find_task(path) or raise NoSuchTaskError, "the task `#{path}' does not exist"
        reporter = Capistrano::Datadog.reporter
        task_name = task.fully_qualified_name

        roles = task.options[:roles]
        if roles.is_a? Proc
          roles = roles.call
        end

        reporter.record_task(task_name, roles, task.namespace.variables[:stage], fetch(:application)) do
          trigger(hooks[:before], task) if hooks[:before]
          result = execute_task(task)
          trigger(hooks[:after], task) if hooks[:after]
          result
        end
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
      on :exit, 'datadog:submit'
      namespace :datadog do
        desc 'Submit the tasks that have run to Datadog as events'
        task :submit do |ns|
          if variables[:use_getlogin].nil?
            Capistrano::Datadog.submit variables[:datadog_api_key], true, variables[:datadog_host]
          else
            Capistrano::Datadog.submit variables[:datadog_api_key], variables[:use_getlogin], variables[:datadog_host]
          end
        end
      end
    end
  end
end
