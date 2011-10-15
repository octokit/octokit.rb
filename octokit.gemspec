# encoding: utf-8
require File.expand_path('../lib/octokit/version', __FILE__)

Gem::Specification.new do |gem|
  gem.add_dependency 'addressable', '~> 2.2.6'
  gem.add_dependency 'faraday', '~> 0.7.4'
  gem.add_dependency 'faraday_middleware', '~> 0.7.0'
  gem.add_dependency 'hashie', '~> 1.2.0'
  gem.add_dependency 'multi_json', '~> 1.0.2'
  gem.add_development_dependency 'json', '~> 1.6'
  gem.add_development_dependency 'rake', '~> 0.9'
  gem.add_development_dependency 'rspec', '~> 2.6'
  gem.add_development_dependency 'simplecov', '~> 0.4'
  gem.add_development_dependency 'webmock', '~> 1.7'
  gem.add_development_dependency 'yard', '~> 0.7'
  gem.authors = ["Wynn Netherland", "Adam Stacoviak", "Erik Michaels-Ober"]
  gem.description = %q{Simple wrapper for the GitHub API v2}
  gem.email = ['wynn.netherland@gmail.com', 'adam@stacoviak.com', 'sferik@gmail.com']
  gem.files = `git ls-files`.split("\n")
  gem.homepage = 'https://github.com/pengwynn/octokit'
  gem.name = 'octokit'
  gem.platform = Gem::Platform::RUBY
  gem.require_paths = ['lib']
  gem.required_rubygems_version = Gem::Requirement.new('>= 1.3.6')
  gem.summary = %q{Wrapper for the GitHub API}
  gem.test_files = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.version = Octokit::VERSION.dup
end
