# frozen_string_literal: true

source 'https://rubygems.org'

gem 'jruby-openssl', platforms: :jruby
gem 'rake', '~> 13.0', '>= 13.0.1'

# when stdlib items become gems, they need to be added
install_if -> { RUBY_VERSION >= '2.8' } do
  gem 'rss', '>= 0.2.9'
end

group :development do
  gem 'awesome_print', require: 'ap'
  gem 'yard'
end

group :test do
  install_if -> { RUBY_VERSION >= '2.8' } do
    gem 'rexml', '>= 3.2.4'
  end
  gem 'json', '>= 2.3.0'
  gem 'jwt', '~> 2.2', '>= 2.2.1'
  gem 'mime-types', '~> 3.3', '>= 3.3.1'
  gem 'multi_json', '~> 1.14', '>= 1.14.1'
  gem 'netrc', '~> 0.11.0'
  gem 'rb-fsevent', '~> 0.11.1'
  gem 'rbnacl', '~> 7.1.1'
  gem 'rspec', '~> 3.9'
  gem 'simplecov', require: false
  gem 'test-queue'
  gem 'vcr', '~> 6.1'
  gem 'webmock', '~> 3.8', '>= 3.8.2'
end

faraday_version = ENV.fetch('FARADAY_VERSION', '~> 2.0')

gem 'faraday', faraday_version

if faraday_version.start_with?('~> 2')
  gem 'faraday-multipart'
  gem 'faraday-retry'
end

group :test, :development do
  gem 'bundler', '>= 1', '< 3'
  gem 'pry-byebug'
  gem 'redcarpet'
  gem 'rubocop', '1.60.1'
end

gemspec
