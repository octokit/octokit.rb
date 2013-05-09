source 'https://rubygems.org'

gem 'jruby-openssl', :platforms => :jruby
gem 'rake'
gem 'yard'

group :development do
  gem 'awesome_print', :require => 'ap'
  gem 'guard-rspec', '~> 2.5.1'
  gem 'hirb-unicode'
  gem 'redcarpet'
  gem 'pry'
  gem 'wirb'
  gem 'wirble'
end

group :test do
  gem 'coveralls', :require => false
  gem 'json', '~> 1.7', :platforms => [:ruby_18, :jruby]
  gem 'rb-fsevent', '~> 0.9'
  gem 'rspec', '~> 2.13.0'
  gem 'simplecov', :require => false
  gem 'test-queue', '~> 0.1.3'
  gem 'vcr', '~> 2.4.0'
  gem 'webmock', '~> 1.9.0'
end

gemspec
