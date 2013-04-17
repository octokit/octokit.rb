source 'https://rubygems.org'

gem 'jruby-openssl', :platforms => :jruby
gem 'rake'
gem 'yard'

group :development do
  gem 'awesome_print', :require => 'ap'
  gem 'hirb-unicode'
  gem 'kramdown'
  gem 'pry'
  gem 'wirb'
  gem 'wirble'
end

group :test do
  gem 'coveralls', :require => false
  gem 'guard-minitest'
  gem 'json', '~> 1.7', :platforms => [:ruby_18, :jruby]
  gem 'rb-fsevent', '~> 0.9'
  gem 'simplecov', :require => false
  gem 'turn'
  gem 'webmock'
end

gemspec
