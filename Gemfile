source 'https://rubygems.org'

gem 'jruby-openssl', :platforms => :jruby
gem 'rake', '> 11.0.1', '< 12.0'

# when stdlib items become gems, they need to added
install_if -> { RUBY_VERSION >= '2.8' } do
  gem 'rss', '>= 0.2.8'
end

group :development do
  gem 'awesome_print', :require => 'ap'
  gem 'guard-rspec', '~> 4.5'
  gem 'hirb-unicode'
  gem 'wirb'
  gem 'wirble'
  gem 'yard'
end

group :test do
  install_if -> { RUBY_VERSION >= '2.8' } do
    gem 'rexml', '>= 3.2.3'
  end
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

group :test, :development do
  gem 'activesupport'
  gem 'oas_parser'
  gem 'redcarpet'
  gem 'pry-byebug'
end

platforms :rbx do
  gem 'psych'
  gem 'rubysl', '~> 2.0'
end

gemspec
