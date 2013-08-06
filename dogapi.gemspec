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

  spec.files         = `git ls-files`.split($\)
  spec.executables   = spec.files.grep(%r{^bin/}).map { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.has_rdoc = true
  spec.extra_rdoc_files = ['README.rdoc']
  spec.rdoc_options << '--title' << 'DogAPI -- Datadog Client' <<
                    '--main' << 'README.rdoc' <<
                    '--line-numbers' << '--inline-source'

  spec.add_dependency 'json', '>= 1.5.1'

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake', '~> 10'
  spec.add_development_dependency 'rdoc'
end
