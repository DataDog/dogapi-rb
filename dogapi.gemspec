# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'dogapi/version'

Gem::Specification.new do |spec|
  spec.name          = 'dogapi'
  spec.version       = Dogapi::VERSION
  spec.authors       = ['Datadog, Inc.']
  spec.email         = ['packages@datadoghq.com']
  spec.description   = 'Ruby bindings for Datadog\'s API'
  spec.summary       = spec.description
  spec.homepage      = 'http://datadoghq.com/'
  spec.license       = 'BSD'

  spec.metadata      = {
    'bug_tracker_uri'   => 'https://github.com/DataDog/dogapi-rb/issues',
    'changelog_uri'     => 'https://github.com/DataDog/dogapi-rb/blob/master/CHANGELOG.md',
    'documentation_uri' => 'https://docs.datadoghq.com/api/',
    'source_code_uri'   => 'https://github.com/DataDog/dogapi-rb'
  }

  spec.files         = `git ls-files`.split($\)
  spec.executables   = spec.files.grep(%r{^bin/}).map { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.extra_rdoc_files = ['README.rdoc']
  spec.rdoc_options << '--title' << 'DogAPI -- Datadog Client' <<
                    '--main' << 'README.rdoc' <<
                    '--line-numbers' << '--inline-source'

  spec.add_dependency 'multi_json'

  spec.add_development_dependency 'bundler', '>= 1.3'
  # NOTE: rake < 12.3.3 is vulnerable to CVE-2020-8130, but we only use it as a test dependency
  # and neither our users nor our CI is vulnerable in any way
  spec.add_development_dependency 'rake', '~> 10'
  spec.add_development_dependency 'rdoc'
end
