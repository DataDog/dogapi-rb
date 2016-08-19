source 'https://rubygems.org'

gemspec

group :test do
  gem 'rake', '>= 2.4.2'
  gem 'rspec'
  gem 'rubocop', '~> 0.41.2'
  gem 'simplecov'
  gem 'webmock'
  if RbConfig::CONFIG['ruby_version'].start_with?("1.9")
  	gem 'json', '< 2'
  end
end

group :quality do
  gem 'tailor'
  gem 'tins', '~> 1.6.0'
end
