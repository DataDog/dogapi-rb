# An example of how to submit long-running events.

require 'dogapi'
require 'optparse'

if !ENV['DATADOG_KEY']
  raise 'DATADOG_KEY environment variable not set'
else
  api_key = ENV['DATADOG_KEY']
end

prog = File.basename(__FILE__)
options = {}
OptionParser.new do |opts|
  opts.on('-t', '--target [target]', 'Host to post events to') do |v|
    options[:target] = v
  end
end.parse!

event_service = Dogapi::EventService.new(options[:target])
scope = Dogapi::Scope.new()

cost = rand(4) + 12
sleep_time = rand(50) + 10
event = Dogapi::Event.new("Doing #{cost} units of work then sleeping for #{sleep_time} seconds")
puts event.msg_text

event_service.start(api_key, event, scope) do
  sleep(sleep_time)

  if rand(2) == 0
    # Leaving the context with an exception will tell the event api to 
    # mark the event as unsuccessful
    raise 'Job failed'
  end
end
