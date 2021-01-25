# Unless explicitly stated otherwise all files in this repository are licensed under the BSD-3-Clause License.
# This product includes software developed at Datadog (https://www.datadoghq.com/).
# Copyright 2011-Present Datadog, Inc.

require 'etc'
require 'digest/md5'
require 'timeout'

require 'dogapi'

module Capistrano
  module Datadog
    # Singleton method for Reporter
    def self.reporter()
      @reporter || @reporter = Reporter.new
    end

    def self.cap_version()
      if @cap_version.nil? then
        if !defined? Configuration
          @cap_version = ''
        elsif Configuration.respond_to? :instance
          @cap_version = :v2
        else
          @cap_version = :v3
        end
      end
      @cap_version
    end

    def self.submit(api_key, use_getlogin=true, endpoint=nil)
      begin
        if api_key
          dog = Dogapi::Client.new(api_key, nil, nil, nil, true, nil, endpoint, false)
          reporter.report(use_getlogin).each do |event, hosts|
            if hosts.size > 0
              hosts.each do |host|
                dog.emit_event event, host: host
              end
            else
              dog.emit_event event
            end
          end
        else
          puts 'No api key set, not submitting to Datadog'
        end
      rescue Timeout::Error => e
        puts 'Could not submit to Datadog, request timed out.'
      rescue => e
        puts "Could not submit to Datadog: #{e.inspect}\n#{e.backtrace.join("\n")}"
      end
    end

    # Collects info about the tasks that ran in order to submit to Datadog
    class Reporter
      attr_accessor :event_filter

      def initialize()
        @tasks = []
        @task_stack = []
      end

      def record_task(task_name, roles, stage=nil, application_name=nil)
        task = {
          :name   => task_name,
          :roles  => roles,
          :stage  => stage,
          :application => application_name,
          :logs => [],
          :hosts => []
        }
        @tasks << task
        @task_stack << task
        result = nil
        timing = Benchmark.measure(task_name) do
          result = yield
        end
        task[:timing] = timing.real
        @task_stack.pop
        result
      end

      def record_log(message)
        current_task = @task_stack.last
        if current_task
          current_task[:logs] << message
        end
      end

      def record_hostname(hostname)
        @task_stack.each do |task|
          task[:hosts] << hostname
        end
      end

      def report(use_getlogin=true)
        hostname = Dogapi.find_localhost
        user = use_getlogin ? Etc.getlogin : Etc.getpwuid.name

        # Lazy randomness
        aggregation_key = Digest::MD5.hexdigest "#{Time.new}|#{rand}"

        filter = event_filter || proc { |x| x }

        # Convert the tasks into Datadog events
        @tasks.map do |task|
          name  = task[:name]
          roles = Array(task[:roles]).map(&:to_s).sort
          tags  = ['#capistrano'] + (roles.map { |t| '#role:' + t })
          if !task[:stage].nil? and !task[:stage].empty? then
            tags << "#stage:#{task[:stage]}"
          end
          application = ''
          if !task[:application].nil? and !task[:application].empty? then
            application = ' for ' + task[:application]
          end
          timing = Float(task[:timing]).round(2) rescue 'n/a'
          title = "#{user}@#{hostname} ran #{name}#{application} on #{roles.join(', ')} "\
                  "with capistrano in #{timing} secs"
          type  = 'deploy'
          alert_type = 'success'
          source_type = 'capistrano'
          message_content = task[:logs].join('')
          message = if !message_content.empty? then
            # Strip out color control characters
            message_content = sanitize_encoding(message_content).gsub(/\e\[(\d+)m/, '')
            "@@@\n#{message_content}@@@" else '' end

          [Dogapi::Event.new(message,
            :msg_title        => title,
            :event_type       => type,
            :event_object     => aggregation_key,
            :alert_type       => alert_type,
            :source_type_name => source_type,
            :tags             => tags
          ), task[:hosts]]
        end.map(&event_filter).reject(&:nil?)
      end

      def sanitize_encoding(string)
        return string unless defined?(::Encoding) && string.encoding == Encoding::BINARY
        string.encode(Encoding::UTF_8, Encoding::BINARY, invalid: :replace, undef: :replace, replace: '')
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
  puts "Unknown version: #{Capistrano::Datadog::cap_version.inspect}"
end
