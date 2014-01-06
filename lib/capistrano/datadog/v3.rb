require "benchmark"

# Capistrano v3 uses Rake's DSL instead of its own

module Rake
  class Task
    alias old_invoke invoke
    def invoke(*args)
      result = nil
      reporter = Capistrano::Datadog.reporter
      task_name = name
      timing = Benchmark.measure(task_name) do
        result = old_invoke(*args)
      end
      reporter.record_task(task_name, timing.real, roles)
      result
    end
  end
end

at_exit do
  api_key = Capistrano::Configuration.env.fetch :datadog_api_key
  Capistrano::Datadog.submit api_key
end
