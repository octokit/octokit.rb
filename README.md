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
=> #<Hashie::Mash avatar_url="https://secure.gravatar.com/avatar/1f74b13f1e5c6c69cb5d7fbaabb1e2cb?d=https://a248.e.akamai.net/assets.github.com%2Fimages%2Fgravatars%2Fgravatar-user-420.png" bio="" blog="http://twitter.com/sferik" company="" created_at="2008-05-14T20:36:12Z" email="sferik@gmail.com" events_url="https://api.github.com/users/sferik/events{/privacy}" followers=662 followers_url="https://api.github.com/users/sferik/followers" following=102 following_url="https://api.github.com/users/sferik/following{/other_user}" gists_url="https://api.github.com/users/sferik/gists{/gist_id}" gravatar_id="1f74b13f1e5c6c69cb5d7fbaabb1e2cb" hireable=false html_url="https://github.com/sferik" id=10308 location="San Francisco, CA" login="sferik" name="Erik Michaels-Ober" organizations_url="https://api.github.com/users/sferik/orgs" public_gists=59 public_repos=83 received_events_url="https://api.github.com/users/sferik/received_events" repos_url="https://api.github.com/users/sferik/repos" starred_url="https://api.github.com/users/sferik/starred{/owner}{/repo}" subscriptions_url="https://api.github.com/users/sferik/subscriptions" type="User" updated_at="2013-05-31T16:01:08Z" url="https://api.github.com/users/sferik">
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

=> [#<Hashie::Mash author=#<Hashie::Mash avatar_url="https://secure.gravatar.com/avatar/7e19cd5486b5d6dc1ef90e671ba52ae0?d=https://a248.e.akamai.net/assets.github.com%2Fimages%2Fgravatars%2Fgravatar-user-420.png" gravatar_id="7e19cd5486b5d6dc1ef90e671ba52ae0" id=865 login="pengwynn" url="https://api.github.com/users/pengwynn"> commit=#<Hashie::Mash author=#<Hashie::Mash date="2012-10-31T15:17:51Z" email="wynn@github.com" name="Wynn Netherland"> comment_count=0 committer=#<Hashie::Mash date="2012-10-31T15:17:51Z" email="wynn@github.com" name="Wynn Netherland"> message="Fix bug with archive_link for private repo" tree=#<Hashie::Mash sha="49bf2a476aa819f29b0fc1a8805f7567f010006d" url="https://api.github.com/repos/octokit/octokit.rb/git/trees/49bf2a476aa819f29b0fc1a8805f7567f010006d"> url="https://api.github.com/repos/octokit/octokit.rb/git/commits/8db3df37fad3a021eb8036b007c718149836cb32"> committer=#<Hashie::Mash avatar_url="https://secure.gravatar.com/avatar/7e19cd5486b5d6dc1ef90e671ba52ae0?d=https://a248.e.akamai.net/assets.github.com%2Fimages%2Fgravatars%2Fgravatar-user-420.png" gravatar_id="7e19cd5486b5d6dc1ef90e671ba52ae0" id=865 login="pengwynn" url="https://api.github.com/users/pengwynn"> parents=[#<Hashie::Mash sha="7a67f4b47791cb77de33e491df87cef06012c79f" url="https://api.github.com/repos/octokit/octokit.rb/commits/7a67f4b47791cb77de33e491df87cef06012c79f">] sha="8db3df37fad3a021eb8036b007c718149836cb32" url="https://api.github.com/repos/octokit/octokit.rb/commits/8db3df37fad3a021eb8036b007c718149836cb32">, ... , ...]
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

#### Authorize an application using OAuth2 flow

```ruby
Octokit.authorize_url("id_here", "secret_here")
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
