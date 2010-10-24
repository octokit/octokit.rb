require 'bundler'
require 'bundler/version'

require File.expand_path('lib/octopussy')

Gem::Specification.new do |s|
  s.add_development_dependency('fakeweb', '~> 1.3')
  s.add_development_dependency('jnunemaker-matchy', '~> 0.4.0')
  s.add_development_dependency('mocha', '~> 0.9')
  s.add_development_dependency('shoulda', '~> 2.11')
  s.add_runtime_dependency('hashie', '~> 0.4.0')
  s.add_runtime_dependency('httparty', '~> 0.6.1')
  s.name = "octopussy"
  s.authors = ["Wynn Netherland", "Adam Stacoviak"]
  s.description = %q{Simple wrapper for the GitHub API v2}
  s.email = ["wynn.netherland@gmail.com"]
  s.executables = `git ls-files -- bin/*`.split("\n").map{|f| File.basename(f)}
  s.files = `git ls-files`.split("\n")
  s.homepage = "http://wynnnetherland.com/projects/octopussy/"
  s.require_paths = ["lib"]
  s.summary = %q{Wrapper for the Octopussy API}
  s.test_files = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.version = Octopussy::VERSION
  s.platform = Gem::Platform::RUBY
  s.required_rubygems_version = Gem::Requirement.new('>= 1.3.6') if s.respond_to? :required_rubygems_version=
end
