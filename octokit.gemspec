# encoding: utf-8
require File.expand_path('../lib/octokit/version', __FILE__)

Gem::Specification.new do |gem|
  gem.add_dependency 'addressable', '~> 2.2'
  gem.add_dependency 'faraday', '~> 0.8'
  gem.add_dependency 'faraday_middleware', '~> 0.8'
  gem.add_dependency 'hashie', '~> 1.2'
  gem.add_dependency 'multi_json', '~> 1.3'
  gem.add_development_dependency 'json'
  gem.add_development_dependency 'maruku'
  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'simplecov'
  gem.add_development_dependency 'webmock'
  gem.add_development_dependency 'yard'
  gem.authors = ["Wynn Netherland", "Adam Stacoviak", "Erik Michaels-Ober"]
  gem.description = %q{Simple wrapper for the GitHub v3 API}
  gem.email = ['wynn.netherland@gmail.com', 'adam@stacoviak.com', 'sferik@gmail.com']
  gem.files = `git ls-files`.split("\n")
  gem.homepage = 'https://github.com/pengwynn/octokit'
  gem.name = 'octokit'
  gem.platform = Gem::Platform::RUBY
  gem.require_paths = ['lib']
  gem.required_rubygems_version = Gem::Requirement.new('>= 1.3.6')
  gem.summary = gem.description
  gem.test_files = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.version = Octokit::VERSION
end
