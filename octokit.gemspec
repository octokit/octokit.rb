# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'octokit/version'

Gem::Specification.new do |spec|
  spec.add_development_dependency 'bundler', '~> 1.0'
  spec.add_dependency 'sawyer', '~> 0.5.1'
  spec.authors = ["Wynn Netherland", "Erik Michaels-Ober", "Clint Shryock"]
  spec.description = %q{Simple wrapper for the GitHub API}
  spec.email = ['wynn.netherland@gmail.com', 'sferik@gmail.com', 'clint@ctshryock.com']
  spec.files = %w(.document CONTRIBUTING.md LICENSE.md README.md Rakefile octokit.gemspec)
  spec.files += Dir.glob("lib/**/*.rb")
  spec.files += Dir.glob("spec/**/*")
  spec.homepage = 'https://github.com/octokit/octokit.rb'
  spec.licenses = ['MIT']
  spec.name = 'octokit'
  spec.require_paths = ['lib']
  spec.required_rubygems_version = '>= 1.3.5'
  spec.summary = "Ruby toolkit for working with the GitHub API"
  spec.test_files = Dir.glob("spec/**/*")
  spec.version = Octokit::VERSION.dup
end
