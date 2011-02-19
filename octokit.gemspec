# -*- encoding: utf-8 -*-
require File.expand_path('../lib/octokit/version', __FILE__)

Gem::Specification.new do |s|
  s.add_development_dependency('json', '~> 1.5')
  s.add_development_dependency('nokogiri', '~> 1.4')
  s.add_development_dependency('rake', '~> 0.8')
  s.add_development_dependency('rspec', '~> 2.5')
  s.add_development_dependency('simplecov', '~> 0.4')
  s.add_development_dependency('webmock', '~> 1.6')
  s.add_development_dependency('ZenTest', '~> 4.5')
  s.add_runtime_dependency('addressable', '~> 2.2.4')
  s.add_runtime_dependency('hashie', '~> 1.0.0')
  s.add_runtime_dependency('faraday', '~> 0.5.4')
  s.add_runtime_dependency('faraday_middleware', '~> 0.3.2')
  s.add_runtime_dependency('multi_json', '~> 0.0.5')
  s.add_runtime_dependency('multi_xml', '~> 0.2.0')
  s.name = 'octokit'
  s.authors = ["Wynn Netherland", "Adam Stacoviak", "Erik Michaels-Ober"]
  s.description = %q{Simple wrapper for the GitHub API v2}
  s.email = ['wynn.netherland@gmail.com']
  s.executables = `git ls-files -- bin/*`.split("\n").map{|f| File.basename(f)}
  s.files = `git ls-files`.split("\n")
  s.homepage = 'http://wynnnetherland.com/projects/octokit/'
  s.require_paths = ['lib']
  s.summary = %q{Wrapper for the GitHub API}
  s.test_files = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.version = Octokit::VERSION.dup
  s.platform = Gem::Platform::RUBY
  s.required_rubygems_version = Gem::Requirement.new('>= 1.3.6') if s.respond_to? :required_rubygems_version=
end
