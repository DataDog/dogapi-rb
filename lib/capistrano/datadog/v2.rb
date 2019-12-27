# Copyright (c) 2010-2020, Datadog <opensource@datadoghq.com>
#
# Redistribution and use in source and binary forms, with or without modification, are permitted provided that the
# following conditions are met:
#
# 1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following
# disclaimer.
#
# 2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following
# disclaimer in the documentation and/or other materials provided with the distribution.
#
# 3. Neither the name of the copyright holder nor the names of its contributors may be used to endorse or promote
# products derived from this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES,
# INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
# SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
# SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
# WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

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
          Capistrano::Datadog.submit variables[:datadog_api_key]
        end
      end
    end
  end
end
