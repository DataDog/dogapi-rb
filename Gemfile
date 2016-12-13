source 'https://rubygems.org'

gemspec

group :test do
  gem 'rake', '>= 2.4.2'
  gem 'rspec'
  gem 'rubocop', '~> 0.41.2'
  gem 'simplecov'
  if RbConfig::CONFIG['ruby_version'].start_with?("1.9")
    gem 'json', '< 2'
    gem 'public_suffix', '< 1.5'
    gem 'rdoc', '< 5'
    gem 'term-ansicolor', '< 1.4'
    gem 'webmock', '< 2.3'
  else
    gem 'webmock'
  end
end

group :quality do
  gem 'tailor'
  gem 'tins', '~> 1.6.0'
end
