require "benchmark"
require "etc"
require "digest/md5"
require "socket"
require "time"
require "timeout"

require "dogapi"

# Monkeypatch capistrano to collect data about the tasks that it's running
module Capistrano
  class Configuration
    module Execution
      # Attempts to locate the task at the given fully-qualified path, and
      # execute it. If no such task exists, a Capistrano::NoSuchTaskError 
      # will be raised.
      # Also, capture the time the task took to execute, and the logs it 
      # outputted for submission to Datadog
      def find_and_execute_task(path, hooks={})
        task = find_task(path) or raise NoSuchTaskError, "the task `#{path}' does not exist"
        result = nil
        reporter = Capistrano::Datadog.reporter
        timing = Benchmark.measure(task.fully_qualified_name) do
          # Set the current task so that the logger knows which task to 
          # associate the logs with
          reporter.current_task = task.fully_qualified_name
          trigger(hooks[:before], task) if hooks[:before]
          result = execute_task(task)
          trigger(hooks[:after], task) if hooks[:after]
          reporter.current_task = nil
        end
        # Collect the timing in a list for later reporting
        reporter.record_task task, timing
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
    # Singleton method for Reporter
    def self.reporter()
      @reporter || @reporter = Reporter.new
    end

    # Collects info about the tasks that ran in order to submit to Datadog
    class Reporter
      attr_accessor :current_task

      def initialize()
        @tasks = []
        @current_task = nil
        @logging_output = {}
      end

      def record_task(task, timing)
        roles = task.options[:roles]
        if roles.is_a? Proc
          roles = roles.call
        end
        @tasks << {
          :name   => task.fully_qualified_name,
          :timing => timing.real,
          :roles  => roles
        }
      end

      def record_log(message)
        if not @logging_output[@current_task] 
          @logging_output[@current_task] = []
        end
        @logging_output[@current_task] << message
      end

      def report()
        hostname = Socket.gethostname
        user = Etc.getlogin

        # Lazy randomness
        aggregation_key = Digest::MD5.hexdigest "#{Time.new}|#{rand}"

        # Convert the tasks into Datadog events
        @tasks.map do |task|
          name  = task[:name]
          roles = Array(task[:roles]).sort
          tags  = ["#capistrano"] + (roles.map { |t| '#role:' + t })
          title = "%s@%s ran %s on %s with capistrano in %.2f secs" % [user, hostname, name, roles.join(', '), task[:timing]]
          type  = "deploy"
          alert_type = "success"
          source_type = "capistrano"
          message = "@@@" + "\n" + @logging_output[name].join('') + "@@@"

          Dogapi::Event.new(message,
            :msg_title        => title,
            :event_type       => type,
            :event_object     => aggregation_key,
            :alert_type       => alert_type,
            :source_type_name => source_type,
            :tags             => tags
          )
        end
      end
    end

    class LogCapture
      def initialize(device)
        @device = device
      end

      def puts(message)
        Capistrano::Datadog::reporter.record_log message
        @device.puts message
      end
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
        begin 
          api_key = variables[:datadog_api_key]
          if api_key
            dog = Dogapi::Client.new(api_key)
            Datadog::reporter.report.each do |event|
              dog.emit_event event
            end
          else
            puts "No api key set, not submitting to Datadog"
          end
        rescue Timeout::Error => e
          puts "Could not submit to Datadog, request timed out."
        rescue => e
          puts "Could not submit to Datadog: #{e.inspect}\n#{e.backtrace.join("\n")}"
        end
      end
    end
  end


end



