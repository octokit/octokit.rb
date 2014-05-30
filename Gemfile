source 'https://rubygems.org'

gem 'jruby-openssl', :platforms => :jruby
gem 'rake'

group :development do
  gem 'awesome_print', :require => 'ap'
  gem 'guard-rspec'
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
  gem 'mime-types', '< 2.0.0'
  gem 'netrc', '~> 0.7.7'
  gem 'rb-fsevent', '~> 0.9'
  gem 'rspec', '~> 3.0.0.beta2'
  gem 'simplecov', :require => false
  gem 'vcr', '~> 2.4'
  gem 'webmock', '>= 1.9'
end

platforms :rbx do
  gem 'psych'
  gem 'rubysl', '~> 2.0'
end

gemspec
