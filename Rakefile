require 'bundler/gem_tasks'
require 'rake/testtask'
require 'rdoc/task'
require 'rspec/core/rake_task'

default_tests = [:spec, :test]

case RbConfig::CONFIG['ruby_version']
when -> (version) { version.start_with?("2.3") }
  # Not compatible with Ruby 2.3.x
else
  require 'tailor/rake_task'
  default_tests.unshift(:tailor)

  Tailor::RakeTask.new do |task|
    task.file_set 'lib/**/*.rb', :code do |style|
      style.max_line_length 160, :level => :warn
      style.max_code_lines_in_method 40, :level => :warn
    end
    task.file_set 'spec/**/*.rb', :tests do |style|
      style.max_line_length 160, :level => :warn
      style.max_code_lines_in_method 40, :level => :warn
    end
  end

end

task :default => default_tests

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

RSpec::Core::RakeTask.new(:spec)

desc "Find notes in code"
task :notes do
  puts `grep --exclude=Rakefile -r 'OPTIMIZE:\\|FIXME:\\|TODO:' .`
end
