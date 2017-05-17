require 'bundler/gem_tasks'
require 'rake/testtask'
require 'rdoc/task'
require 'rspec/core/rake_task'
require 'rubocop/rake_task'

task :default => [:spec, :rubocop]

# Doc stuff
RDoc::Task.new do |rd|
  rd.main = 'README.rdoc'
  rd.rdoc_files.include('README.rdoc', 'lib/**/*.rb', 'CHANGELOG.md')
  rd.options << '--line-numbers' << '--inline-source'
  rd.rdoc_dir = 'doc'
  rd.title = 'DogAPI -- DataDog Client'
end

RSpec::Core::RakeTask.new(:spec)

RuboCop::RakeTask.new do |task|
  task.patterns = ['spec', 'lib']
end

desc "Find notes in code"
task :notes do
  puts `grep --exclude=Rakefile -r 'OPTIMIZE:\\|FIXME:\\|TODO:' .`
end
