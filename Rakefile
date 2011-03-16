require 'rake/gempackagetask'
require 'rake/testtask'
require 'rubygems'

task :clean do
  rm_rf 'pkg'
end

Rake::TestTask.new(:test) do |test|
    test.libs << 'lib' << 'tests'
    test.pattern = 'tests/**/ts_*.rb'
end

# Gem stuff
spec = Gem::Specification.new do |s|
  s.name = "dogapi"
  s.version = "1.0.0"
  s.author = "Datadog, Inc."
  s.email = "packages@datadoghq.com"
  s.homepage = "http://datadoghq.com/"
  s.platform = Gem::Platform::RUBY
  s.summary = "Ruby bindings for Datadog's API"
  s.files = FileList["{lib,tests}/**/*"].exclude("rdoc").to_a
  s.require_path = "lib"
  s.test_file = "tests/ts_dogapi.rb"
  s.has_rdoc = true
  #s.extra_rdoc_files = ["README"]
  s.license = 'BSD'
end

Rake::GemPackageTask.new(spec) do |pkg|
  pkg.need_tar = true
end
