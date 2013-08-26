require 'bundler/gem_tasks'
require 'rake/testtask'
require 'rdoc/task'

# Assign some test keys if they aren't already set.
ENV["DATADOG_API_KEY"] ||= '9775a026f1ca7d1c6c5af9d94d9595a4'
ENV["DATADOG_APP_KEY"] ||= '87ce4a24b5553d2e482ea8a8500e71b8ad4554ff'

task :default => [:test]

Rake::TestTask.new(:test) do |test|
  test.libs.push 'lib'
  test.libs.push 'tests'
  test.test_files = FileList['tests/test_*.rb']
end

# Doc stuff
RDoc::Task.new do |rd|
  rd.main = 'README.rdoc'
  rd.rdoc_files.include('README.rdoc', 'lib/**/*.rb', 'CHANGELOG.md')
  rd.options << '--line-numbers' << '--inline-source'
  rd.rdoc_dir = 'doc'
  rd.title = 'DogAPI -- DataDog Client'
end


desc "Find notes in code"
task :notes do
  puts `grep --exclude=Rakefile -r 'OPTIMIZE:\\|FIXME:\\|TODO:' .`
end
