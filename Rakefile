require 'bundler/gem_tasks'
require 'rake/testtask'
require 'rdoc/task'
require 'tailor/rake_task'

# Assign some test keys if they aren't already set.
ENV["DATADOG_API_KEY"] ||= '9775a026f1ca7d1c6c5af9d94d9595a4'
ENV["DATADOG_APP_KEY"] ||= '87ce4a24b5553d2e482ea8a8500e71b8ad4554ff'

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

require 'tailor/rake_task'
Tailor::RakeTask.new do |task|
  task.file_set 'lib/**/*.rb', :code do |style|
    style.max_line_length 160, level: :warn
    style.max_code_lines_in_method 40, level: :warn
  end
  task.file_set 'tests/*.rb', :tests do |style|
    style.max_line_length 160, level: :warn
    style.max_code_lines_in_method 40, level: :warn
  end
end

task :default => [:test]
