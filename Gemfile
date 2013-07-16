source 'https://rubygems.org'

gem 'jruby-openssl', :platforms => :jruby
gem 'rake'

group :development do
  gem 'awesome_print', :require => 'ap'
  gem 'guard-rspec', '~> 2.5.1'
  gem 'hirb-unicode'
  gem 'pry'
  gem 'redcarpet'
  gem 'wirb'
  gem 'wirble'
  gem 'yard'
end

group :test do
  gem 'coveralls', :require => false
  gem 'json', '~> 1.7', :platforms => [:ruby_18, :jruby]
  gem 'netrc', '~> 0.7.7'
  gem 'rb-fsevent', '~> 0.9'
  gem 'rspec', '~> 2.13.0'
  gem 'simplecov', :require => false
  gem 'test-queue', '~> 0.1.3'
  gem 'vcr', '~> 2.4.0'
  gem 'webmock', '~> 1.9.0'
end

gemspec
