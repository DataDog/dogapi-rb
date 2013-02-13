require 'rubygems/package_task'
require 'rdoc/task'
require 'rake/testtask'
require 'bundler'


def version()
  ENV["DOGAPI_VERSION"] || File.open(File.join(File.dirname(__FILE__), "VERSION")).read.strip
end

# Assign some test keys if they aren't already set.
ENV["DATADOG_API_KEY"] ||= '9775a026f1ca7d1c6c5af9d94d9595a4'
ENV["DATADOG_APP_KEY"] ||= '87ce4a24b5553d2e482ea8a8500e71b8ad4554ff'

Rake::TestTask.new(:test) do |test|
    test.libs << 'lib' << 'tests'
    test.test_files = FileList['tests/test_*.rb']
end

# Doc stuff
RDoc::Task.new do |rd|
  rd.main = 'README.rdoc'
  rd.rdoc_files.include('README.rdoc', 'lib/**/*.rb')
  rd.options << '--line-numbers' << '--inline-source'
  rd.rdoc_dir = 'doc'
  rd.title = 'DogAPI -- DataDog Client'
end

# Gem stuff
spec = Gem::Specification.new do |s|
  s.name = 'dogapi'
  s.version = version
  s.author = 'Datadog, Inc.'
  s.email = 'packages@datadoghq.com'
  s.homepage = 'http://datadoghq.com/'
  s.platform = Gem::Platform::RUBY
  s.summary = 'Ruby bindings for Datadog\'s API'
  s.files = FileList['{lib,tests}/**/*'].exclude('rdoc').to_a
  s.require_path = 'lib'
  s.test_file = 'tests/test_client.rb'
  s.license = 'BSD'

  s.has_rdoc = true
  s.extra_rdoc_files = ['README.rdoc']
  s.rdoc_options << '--title' << 'DogAPI -- DataDog Client' <<
                    '--main' << 'README.rdoc' <<
                    '--line-numbers' << '--inline-source'

  s.add_dependency 'json', '>= 1.5.1'
end

Gem::PackageTask.new(spec) do |pkg|
  pkg.need_tar = true
end

task :clean do
  sh "rm -rf pkg/*"
end

task :release => [:clean, :gem] do
  sh "cd pkg && gem push *.gem"
end
