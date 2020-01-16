require 'bundler/gem_tasks'
require 'rake/testtask'
require 'rdoc/task'
require 'rspec/core/rake_task'

task :default => :spec

# Doc stuff
RDoc::Task.new do |rd|
  rd.main = 'README.rdoc'
  rd.rdoc_files.include('README.rdoc', 'lib/**/*.rb', 'CHANGELOG.md')
  rd.options << '--line-numbers' << '--inline-source'
  rd.rdoc_dir = 'doc'
  rd.title = 'DogAPI -- DataDog Client'
end

RSpec::Core::RakeTask.new(:spec)

desc "Find notes in code"
task :notes do
  puts `grep --exclude=Rakefile -r 'OPTIMIZE:\\|FIXME:\\|TODO:' .`
end

task :rubocop do
  sh "rubocop"
end

task :rubocop_todo do
  sh "rubocop --auto-gen-config"
end
