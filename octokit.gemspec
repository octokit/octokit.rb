# encoding: utf-8
require File.expand_path('../lib/octokit/version', __FILE__)

Gem::Specification.new do |spec|
  spec.add_dependency 'addressable', '~> 2.2'
  spec.add_dependency 'faraday', '~> 0.8'
  spec.add_dependency 'faraday_middleware', '~> 0.9'
  spec.add_dependency 'hashie', '~> 1.2'
  spec.add_dependency 'multi_json', '~> 1.3'
  spec.add_dependency 'netrc', '~> 0.7.7'
  spec.authors = ["Wynn Netherland", "Erik Michaels-Ober", "Clint Shryock"]
  spec.description = %q{Simple wrapper for the GitHub v3 API}
  spec.email = ['wynn.netherland@gmail.com', 'sferik@gmail.com', 'clint@ctshryock.com']
  spec.files = %w(.document CHANGELOG.md CONTRIBUTING.md LICENSE.md README.md Rakefile octokit.gemspec)
  spec.files += Dir.glob("lib/**/*.rb")
  spec.files += Dir.glob("spec/**/*")
  spec.homepage = 'https://github.com/pengwynn/octokit'
  spec.licenses = ['MIT']
  spec.name = 'octokit'
  spec.require_paths = ['lib']
  spec.required_rubygems_version = Gem::Requirement.new('>= 1.3.6')
  spec.summary = spec.description
  spec.test_files = Dir.glob("spec/**/*")
  spec.version = Octokit::VERSION
end
