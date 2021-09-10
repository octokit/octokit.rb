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
  gem 'json', '>= 2.3.0', platforms: [:jruby]
  gem 'jwt', '~> 2.2', '>= 2.2.1'
  gem 'mime-types', '~> 3.3', '>= 3.3.1'
  gem 'multi_json', '~> 1.14', '>= 1.14.1'
  gem 'netrc', '~> 0.11.0'
  gem 'rb-fsevent', '~> 0.10.3'
  gem 'rbnacl', '~> 7.1.1'
  gem 'rspec', '~> 3.9'
  gem 'simplecov', require: false
  gem 'vcr', '~> 5.1'
  gem 'webmock', '~> 3.8', '>= 3.8.2'
end

group :test, :development do
  gem 'pry-byebug'
  gem 'redcarpet'
  gem 'rubocop'
end

gemspec

install_if -> { ENV['FARADAY_VERSION'] } do
  gem 'faraday', ENV['FARADAY_VERSION']
end
