# Octokit

Simple Ruby wrapper for the GitHub API.

## Installation

    gem install octokit

## Documentation

[http://rdoc.info/gems/octokit][documentation]

[documentation]: http://rdoc.info/gems/octokit

### Examples

#### Show a user

```ruby
Octokit.user "sferik"
=> # Sawyer::Resource with User Information
=> #<Sawyer::Resource>
```

#### Repositories

For convenience, methods that require a repository argument may be passed in
any of the following forms:

```ruby
Octokit.repo "octokit/octokit.rb"

Octokit.repo {:username => "octokit", :name => "octokit.rb"}

Octokit.repo {:username => "octokit", :repo => "octokit.rb"}

Octokit.repo Repository.new('octokit/octokit.rb')
```

#### List the commits for a repository

```ruby
Octokit.commits("octokit/octokit.rb")

Octokit.list_commits("octokit/octokit.rb")

=> # Array of Sawyer::Resources with Commit Information
=> [#<Sawyer::Resource>, #<Sawyer::Resource>]
```

#### Authenticated Requests
For methods that require authentication, you'll need to setup a client with
your login and password.

```ruby
client = Octokit::Client.new(:login => "me", :password => "sekret")
client.follow("sferik")
```

Alternately, you can authenticate with a [GitHub OAuth2 token][oauth].

[oauth]: http://developer.github.com/v3/oauth

```ruby
client = Octokit::Client.new(:login => "me", :oauth_token => "oauth2token")
client.follow("sferik")
```

#### Requesting a specific media type

You can pass an `:accept` option value to request a particular [media
type][media-types].

[media-types]: http://developer.github.com/v3/media/

```ruby
Octokit.contents 'octokit/octokit.rb', :path => 'README.md', :accept => 'application/vnd.github.html'
```

### Using with GitHub Enterprise

To use with [GitHub Enterprise](https://enterprise.github.com/), you'll need to
set the API and web endpoints before instantiating a client.

```ruby
Octokit.configure do |c|
  c.api_endpoint = 'https://github.company.com/api/v3'
  c.web_endpoint = 'https://github.company.com/'
end

@client = Octokit::Client.new(:login => 'USERNAME', :password => 'PASSWORD')
```

## Supported Ruby Versions

This library aims to support and is [tested against][travis] the following Ruby
implementations:

* Ruby 1.8.7
* Ruby 1.9.2
* Ruby 1.9.3
* Ruby 2.0.0

If something doesn't work on one of these Ruby versions, it's a bug.

This library may inadvertently work (or seem to work) on other Ruby
implementations, however support will only be provided for the versions listed
above.

If you would like this library to support another Ruby version, you may
volunteer to be a maintainer. Being a maintainer entails making sure all tests
run and pass on that implementation. When something breaks on your
implementation, you will be responsible for providing patches in a timely
fashion. If critical issues for a particular implementation exist at the time
of a major release, support for that Ruby version may be dropped.

[travis]: https://travis-ci.org/octokit/octokit.rb

## Versioning

This library aims to adhere to [Semantic Versioning 2.0.0][semver]. Violations
of this scheme should be reported as bugs. Specifically, if a minor or patch
version is released that breaks backward compatibility, that version should be
immediately yanked and/or a new version should be immediately released that
restores compatibility. Breaking changes to the public API will only be
introduced with new major versions. As a result of this policy, you can (and
should) specify a dependency on this gem using the [Pessimistic Version
Constraint][pvc] with two digits of precision. For example:

    spec.add_dependency 'octokit', '~> 1.0'

[semver]: http://semver.org/
[pvc]: http://docs.rubygems.org/read/chapter/16#page74

### JSON dependency

Since JSON is included in 1.9 now, we no longer include it as a hard
dependency. Please require it explicitly if you're running Ruby 1.8

    gem 'json', '~> 1.7'

## Contributors

Octokit was initially created by Wynn Netherland and [Adam
Stacoviak](http://twitter.com/adamstac) but has
turned into a true community effort. Special thanks to the following
contributors:

* [Erik Michaels-Ober](http://github.com/sferik)
* [Clint Shryock](http://github.com/ctshryock)
* [Joey Wendt](http://github.com/joeyw)


## Inspiration

Octokit was inspired by [Octopi][] and aims to be a lightweight,
less-ActiveResourcey alternative.

[octopi]: https://github.com/fcoury/octopi

## Copyright

Copyright (c) 2011-2013 Wynn Netherland, Adam Stacoviak, Erik Michaels-Ober.
See [LICENSE][] for details.

[license]: LICENSE.md
