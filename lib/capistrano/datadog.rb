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

    def self.submit(api_key)
      begin
        if api_key
          dog = Dogapi::Client.new(api_key)
          reporter.report.each do |event, hosts|
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

      def report()
        hostname = Dogapi.find_localhost
        user = Etc.getlogin

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
