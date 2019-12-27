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
  Capistrano::Datadog.submit api_key
end
