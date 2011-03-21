require 'rake/gempackagetask'
require 'rake/rdoctask'
require 'rake/testtask'
require 'rubygems'

Rake::TestTask.new(:test) do |test|
    test.libs << 'lib' << 'tests'
    test.pattern = 'tests/**/ts_*.rb'
end

# Doc stuff
Rake::RDocTask.new do |rd|
  rd.main = 'README.rdoc'
  rd.rdoc_files.include('README.rdoc', 'lib/**/*.rb')
  rd.options << '--line-numbers' << '--inline-source'
  rd.rdoc_dir = 'doc'
  rd.title = 'DogAPI -- DataDog Client'
end

# Gem stuff
spec = Gem::Specification.new do |s|
  s.name = 'dogapi'
  s.version = '1.0.0'
  s.author = 'Datadog, Inc.'
  s.email = 'packages@datadoghq.com'
  s.homepage = 'http://datadoghq.com/'
  s.platform = Gem::Platform::RUBY
  s.summary = 'Ruby bindings for Datadog\'s API'
  s.files = FileList['{lib,tests}/**/*'].exclude('rdoc').to_a
  s.require_path = 'lib'
  s.test_file = 'tests/ts_dogapi.rb'
  s.license = 'BSD'

  s.has_rdoc = true
  s.extra_rdoc_files = ['README.rdoc']
  s.rdoc_options << '--title' << 'DogAPI -- DataDog Client' <<
                    '--main' << 'README.rdoc' <<
                    '--line-numbers' << '--inline-source'

  s.add_dependency 'json', '>=1.5.1'
end

Rake::GemPackageTask.new(spec) do |pkg|
  pkg.need_tar = true
end
