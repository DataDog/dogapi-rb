# A simple script that will do a git pull on a local repo and submit an event
# if there were new changes pulled down. Useful for setups that use git as
# their deployment mechanism, so you know when new code has been released.

require 'dogapi'
require 'optparse'

if !ENV['DATADOG_KEY']
  raise 'DATADOG_KEY environment variable not set'
else
  api_key = ENV['DATADOG_KEY']
end

prog = File.basename(__FILE__)
help = "usage: #{prog} [options] /path/to/local_git_dir"
options = {}
p = OptionParser.new do |opts|
  opts.banner = help
  opts.on('-t', '--target [target]', 'Host to post events to') do |v|
    options[:target] = v
  end
  opts.on('-r', '--remote [remote]', 'Git remote to pull from') do |v|
    options[:remote] = v
  end
  opts.on('-b', '--branch [branch]', 'Git branch to pull from') do |v|
    options[:branch] = v
  end
end.parse!

if ARGV.size < 1
  print help
else
  local_repo_dir = ARGV[0]
end

# Execute the git pull command
last_dir = Dir.getwd
Dir.chdir(local_repo_dir)
io = IO.popen("git pull #{options[:remote]} #{options[:branch]}")
git_message = io.gets

# Only submit events if there were changes
if !git_message.include?('Already up-to-date.')
  puts git_message
  Dogapi::EventService.new(options[:target]).submit(api_key, Dogapi::Event.new(git_message))
end
