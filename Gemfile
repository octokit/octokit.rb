source 'https://rubygems.org'

gem 'jruby-openssl', :platforms => :jruby
gem 'rake', '> 11.0.1', '< 12.0'

group :development do
  gem 'awesome_print', :require => 'ap'
  gem 'guard-rspec', '~> 4.5'
  gem 'hirb-unicode'
  gem 'pry'
  gem 'redcarpet'
  gem 'wirb'
  gem 'wirble'
  gem 'yard'
end

group :test do
  gem 'coveralls', :require => false
  gem 'json', '~> 1.7', :platforms => [:jruby]
  gem 'jwt', '~> 1.5', '>= 1.5.6'
  gem 'multi_json', '~> 1.11.0'
  gem 'mime-types', '< 2.0.0'
  gem 'netrc', '~> 0.7.7'
  gem 'rb-fsevent', '~> 0.9'
  gem 'rspec', '~> 3.0.0'
  gem 'simplecov', :require => false
  gem 'vcr', '~> 4.0'
  gem 'webmock', '~> 3.4', '>= 3.4.2'
end

platforms :rbx do
  gem 'psych'
  gem 'rubysl', '~> 2.0'
end

gemspec
