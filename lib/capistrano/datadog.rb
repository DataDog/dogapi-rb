require "etc"
require "digest/md5"
require "dogapi"

module Capistrano
  module Datadog
    # Singleton method for Reporter
    def self.reporter()
      @reporter || @reporter = Reporter.new
    end

    def self.cap_version()
      if @cap_version.nil? then
        if Configuration.respond_to? :instance then
          @cap_version = :v2
        else
          @cap_version = :v3
        end
      end
      @cap_version
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
        hostname = %x[hostname -f].strip
        user = Etc.getlogin

        # Lazy randomness
        aggregation_key = Digest::MD5.hexdigest "#{Time.new}|#{rand}"

        # Convert the tasks into Datadog events
        @tasks.map do |task|
          name  = task[:name]
          roles = Array(task[:roles]).map(&:to_s).sort
          tags  = ["#capistrano"] + (roles.map { |t| '#role:' + t })
          title = "%s@%s ran %s on %s with capistrano in %.2f secs" % [user, hostname, name, roles.join(', '), task[:timing]]
          type  = "deploy"
          alert_type = "success"
          source_type = "capistrano"
          message = "@@@" + "\n" + (@logging_output[name] || []).join('') + "@@@"

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

  end
end

case Capistrano::Datadog::cap_version
when :v2
  require 'capistrano/datadog/v2'
when :v3
  require 'capistrano/datadog/v3'
else
  puts "Unknown version: {Capistrano::Datadog::cap_version.inspect}"
end
