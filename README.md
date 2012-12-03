# Octokit [![Build Status](https://secure.travis-ci.org/pengwynn/octokit.png?branch=master)][travis] [![Dependency Status](https://gemnasium.com/pengwynn/octokit.png?travis)][gemnasium] [![Code Climate](https://codeclimate.com/badge.png)][codeclimate]
Simple Ruby wrapper for the GitHub v3 API.

[travis]: http://travis-ci.org/pengwynn/octokit
[gemnasium]: https://gemnasium.com/pengwynn/octokit
[codeclimate]: https://codeclimate.com/github/pengwynn/octokit

## Installation
    gem install octokit

## Documentation
[http://rdoc.info/gems/octokit][documentation]

[documentation]: http://rdoc.info/gems/octokit

## Examples
### Show a user
```ruby
Octokit.user("sferik")
=> <#Hashie::Rash blog="http://twitter.com/sferik" company="Code for America" created_at="2008/05/14 13:36:12 -0700" email="sferik@gmail.com" followers_count=177 following_count=83 gravatar_id="1f74b13f1e5c6c69cb5d7fbaabb1e2cb" id=10308 location="San Francisco" login="sferik" name="Erik Michaels-Ober" permission=nil public_gist_count=16 public_repo_count=30 type="User">
```

### Show who a user follows
```ruby
Octokit.following("sferik")
=> ["rails", "puls", "wycats", "dhh", "jm3", "joshsusser", "nkallen", "technoweenie", "blaine", "al3x", "defunkt", "schacon", "bmizerany", "rtomayko", "jpr5", "lholden", "140proof", "ephramzerb", "carlhuda", "carllerche", "jnunemaker", "josh", "hoverbird", "jamiew", "jeremyevans", "brynary", "mojodna", "mojombo", "joshbuddy", "igrigorik", "perplexes", "joearasin", "hassox", "nickmarden", "pengwynn", "mmcgrana", "reddavis", "reinh", "mzsanford", "aanand", "pjhyett", "kneath", "tekkub", "adamstac", "timtrueman", "aaronblohowiak", "josevalim", "kaapa", "hurrycane", "jackdempsey", "drogus", "cameronpriest", "danmelton", "marcel", "r", "atmos", "mbleigh", "isaacs", "maxogden", "codeforamerica", "chadk", "laserlemon", "gruber", "lsegal", "bblimke", "wayneeseguin", "brixen", "dkubb", "bhb", "bcardarella", "elliottcable", "fbjork", "mlightner", "dianakimball", "amerine", "danchoi", "develop", "dmfrancisco", "unruthless", "trotter", "hannestyden", "codahale", "ry"]
```

### Repositories
For convenience, methods that require a repository argument may be passed in
any of the following forms:

```ruby
Octokit.repo("pengwynn/octokit")

Octokit.repo({:username => "pengwynn", :name => "octokit"})

Octokit.repo({:username => "pengwynn", :repo => "octokit"})

Octokit.repo(Repository.new('pengwynn/octokit'))

=> <#Hashie::Rash created_at="2009/12/10 13:41:49 -0800" description="Simple Ruby wrapper for the GitHub API and feeds" fork=false forks=25 has_downloads=true has_issues=true has_wiki=true homepage="http://wynnnetherland.com/projects/octokit" integrate_branch="master" language="Ruby" name="octokit" open_issues=8 owner="pengwynn" private=false pushed_at="2011/05/05 10:48:57 -0700" size=1804 url="https://github.com/pengwynn/octokit" watchers=92>
```

### List the commits for a repository

```ruby
Octokit.commits("pengwynn/octokit")

Octokit.list_commits("pengwynn/octokit")

=> [#<Hashie::Mash author=#<Hashie::Mash avatar_url="https://secure.gravatar.com/avatar/7e19cd5486b5d6dc1ef90e671ba52ae0?d=https://a248.e.akamai.net/assets.github.com%2Fimages%2Fgravatars%2Fgravatar-user-420.png" gravatar_id="7e19cd5486b5d6dc1ef90e671ba52ae0" id=865 login="pengwynn" url="https://api.github.com/users/pengwynn"> commit=#<Hashie::Mash author=#<Hashie::Mash date="2012-10-31T15:17:51Z" email="wynn@github.com" name="Wynn Netherland"> comment_count=0 committer=#<Hashie::Mash date="2012-10-31T15:17:51Z" email="wynn@github.com" name="Wynn Netherland"> message="Fix bug with archive_link for private repo" tree=#<Hashie::Mash sha="49bf2a476aa819f29b0fc1a8805f7567f010006d" url="https://api.github.com/repos/pengwynn/octokit/git/trees/49bf2a476aa819f29b0fc1a8805f7567f010006d"> url="https://api.github.com/repos/pengwynn/octokit/git/commits/8db3df37fad3a021eb8036b007c718149836cb32"> committer=#<Hashie::Mash avatar_url="https://secure.gravatar.com/avatar/7e19cd5486b5d6dc1ef90e671ba52ae0?d=https://a248.e.akamai.net/assets.github.com%2Fimages%2Fgravatars%2Fgravatar-user-420.png" gravatar_id="7e19cd5486b5d6dc1ef90e671ba52ae0" id=865 login="pengwynn" url="https://api.github.com/users/pengwynn"> parents=[#<Hashie::Mash sha="7a67f4b47791cb77de33e491df87cef06012c79f" url="https://api.github.com/repos/pengwynn/octokit/commits/7a67f4b47791cb77de33e491df87cef06012c79f">] sha="8db3df37fad3a021eb8036b007c718149836cb32" url="https://api.github.com/repos/pengwynn/octokit/commits/8db3df37fad3a021eb8036b007c718149836cb32">, ... , ...]
```

## Authenticated Requests
For methods that require authentication, you'll need to setup a client with
your login and password.

```ruby
client = Octokit::Client.new(:login => "me", :password => "sekret")
client.follow("sferik")
```

Alternately, you can authenticate with a [GitHub OAuth2 token][oauth].

```ruby
client = Octokit::Client.new(:login => "me", :oauth_token => "oauth2token")
client.follow("sferik")
```

## Requesting a specific media type

You can pass an `:accept` option value to request a particular [media
type][media-types].

```ruby
Octokit.contents 'pengwynn/octokit', :path => 'README.md', :accept => 'application/vnd.github.html'
```

## Using with GitHub Enterprise

To use with [GitHub Enterprise](https://enterprise.github.com/), you'll need to
set the API and web endpoints before instantiating a client.

```ruby
Octokit.configure do |c|
  c.api_endpoint = 'https://github.company.com/api/v3'
  c.web_endpoint = 'https://github.company.com/'
end

@client = Octokit::Client.new(:login => 'USERNAME', :password => 'PASSWORD')
```

## Submitting a Pull Request
1. [Fork the repository.][fork]
2. [Create a topic branch.][branch]
3. Add specs for your unimplemented feature or bug fix.
4. Run `bundle exec rake spec`. If your specs pass, return to step 3.
5. Implement your feature or bug fix.
6. Run `bundle exec rake spec`. If your specs fail, return to step 5.
7. Run `open coverage/index.html`. If your changes are not completely covered
   by your tests, return to step 3.
8. Add documentation for your feature or bug fix.
9. Run `bundle exec rake doc:yard`. If your changes are not 100% documented, go
   back to step 8.
10. Add, commit, and push your changes.
11. [Submit a pull request.][pr]

[fork]: http://help.github.com/fork-a-repo/
[branch]: http://learn.github.com/p/branching.html
[pr]: http://help.github.com/send-pull-requests/

## Supported Ruby Versions

This library aims to support and is [tested against][travis] the following Ruby
versions:

* Ruby 1.8.7
* Ruby 1.9.2
* Ruby 1.9.3

This library may inadvertently work (or seem to work) on other Ruby
implementations, however support will only be provided for the versions listed
above.

If you would like this library to support another Ruby version, you may
volunteer to be a maintainer. Being a maintainer entails making sure all tests
run and pass on that implementation. When something breaks on your
implementation, you will be personally responsible for providing patches in a
timely fashion. If critical issues for a particular implementation exist at the
time of a major release, support for that Ruby version may be dropped.

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
turned into a true community effort. Special thanks to the following core
contributors:

* [Erik Michaels-Ober](http://github.com/sferik)
* [Clint Shryock](http://github.com/ctshryock)
* [Joey Wendt](http://github.com/joeyw)


## Inspiration
Octokit was inspired by [Octopi][] and aims to be a lightweight,
less-ActiveResourcey alternative.

[octopi]: https://github.com/fcoury/octopi

## Copyright
Copyright (c) 2011 Wynn Netherland, Adam Stacoviak, Erik Michaels-Ober. See
[LICENSE][] for details.

[license]: https://github.com/pengwynn/octokit/blob/master/LICENSE.md
[media-types]: http://developer.github.com/v3/media/
[oauth]: http://developer.github.com/v3/oauth
