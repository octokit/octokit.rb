# Octokit [![Build Status](https://secure.travis-ci.org/pengwynn/octokit.png?branch=master)][travis] [![Dependency Status](https://gemnasium.com/pengwynn/octokit.png?travis)][gemnasium]
Simple Ruby wrapper for the GitHub v2 & v3 API.

[travis]: http://travis-ci.org/pengwynn/octokit
[gemnasium]: https://gemnasium.com/pengwynn/octokit

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
For convenience, methods that require a repository argument may be passed in any of the following forms:

* `"pengwynn/octokit"`
* `{:username => "pengwynn", :name => "octokit"}`
* `{:username => "pengwynn", :repo => "octokit"}`
* instance of `Repository`

```ruby
Octokit.repo("pengwynn/octokit")
=> <#Hashie::Rash created_at="2009/12/10 13:41:49 -0800" description="Simple Ruby wrapper for the GitHub v2 API and feeds" fork=false forks=25 has_downloads=true has_issues=true has_wiki=true homepage="http://wynnnetherland.com/projects/octokit" integrate_branch="master" language="Ruby" name="octokit" open_issues=8 owner="pengwynn" private=false pushed_at="2011/05/05 10:48:57 -0700" size=1804 url="https://github.com/pengwynn/octokit" watchers=92>
```

## Authenticated Requests
For methods that require authentication, you'll need to setup a client with
your login and password.

```ruby
client = Octokit::Client.new(:login => "me", :password => "sekret")
client.follow!("sferik")
```

Alternately, you can authenticate with a GitHub OAuth2 token. Note: this is
**NOT** the GitHub API token on your [account page][account].

[account]: https://github.com/account
```ruby
client = Octokit::Client.new(:login => "me", :oauth_token => "oauth2token")
client.follow!("sferik")
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
implementations:

* Ruby 1.8.7
* Ruby 1.9.2
* Ruby 1.9.3
* [JRuby][]
* [Rubinius][]

[jruby]: http://www.jruby.org/
[rubinius]: http://rubini.us/

If something doesn't work on one of these interpreters, it should be considered
a bug.

This library may inadvertently work (or seem to work) on other Ruby
implementations, however support will only be provided for the versions listed
above.

If you would like this library to support another Ruby version, you may
volunteer to be a maintainer. Being a maintainer entails making sure all tests
run and pass on that implementation. When something breaks on your
implementation, you will be personally responsible for providing patches in a
timely fashion. If critical issues for a particular implementation exist at the
time of a major release, support for that Ruby version may be dropped.

## Inspiration
Octokit was inspired by [Octopi][] and aims to be a lightweight,
less-ActiveResourcey alternative.

[octopi]: https://github.com/fcoury/octopi

## Copyright
Copyright (c) 2011 Wynn Netherland, Adam Stacoviak, Erik Michaels-Ober. See
[LICENSE][] for details.

[license]: https://github.com/pengwynn/octokit/blob/master/LICENSE
