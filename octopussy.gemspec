require 'bundler'
require 'bundler/version'
require 'lib/octopussy'

Gem::Specification.new do |s|
  s.name = %q{octopussy}
  s.version = Octopussy::VERSION
  s.platform    = Gem::Platform::RUBY
  s.required_rubygems_version = ">= 1.3.6"
  s.authors = ["Wynn Netherland", "Adam Stacoviak"]
  s.date = %q{2010-09-01}
  s.description = %q{Simple wrapper for the GitHub API v2}
  s.email = %q{wynn.netherland@gmail.com}
  s.files = Dir.glob("{lib}/**/*")
  s.homepage = %q{http://wynnnetherland.com/projects/octopussy/}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.6}
  s.summary = %q{Wrapper for the Octopussy API}
  s.test_files = [
    "test/helper.rb",
     "test/octopussy_test.rb",
     "test/repo_test.rb"
  ]

  s.add_bundler_dependencies
end