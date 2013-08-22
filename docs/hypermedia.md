# @title Hypermedia
# Hypermedia agent

Starting in version 2.0, Octokit is [hypermedia][]-enabled. Under the hood,
{Octokit::Client} uses [Sawyer][], a hypermedia client built on [Faraday][].

## Hypermedia in Octokit

Resources returned by Octokit methods contain not only data but hypermedia
link relations:

```ruby
user = Octokit.user 'technoweenie'

# Get the repos rel, returned from the API
# as repos_url in the resource
user.rels[:repos].href
# => "https://api.github.com/users/technoweenie/repos"

repos = user.rels[:repos].get.data
repos.last.name
# => "faraday-zeromq"
```

When processing API responses, all `*_url` attributes are culled in to the link
relations collection. Any `url` attribute becomes `.rels[:self]`.

## URI templates

You might notice many link relations have variable placeholders. Octokit
supports [URI Templates][uri-templates] for parameterized URI expansion:

```ruby
repo = Octokit.repo 'pengwynn/pingwynn'
rel = repo.rels[:issues]
# => #<Sawyer::Relation: issues: get https://api.github.com/repos/pengwynn/pingwynn/issues{/number}>

# Get a page of issues
repo.rels[:issues].get.data

# Get issue #2
repo.rels[:issues].get(:uri => {:number => 2}).data
```

## The Full Hypermedia Experience™

If you want to use Octokit as a pure hypermedia API client, you can start at
the API root and and follow link relations from there:

```ruby
root = Octokit.root
root.rels[:repository].get :uri => {:owner => "octokit", :repo => "octokit.rb" }
```

Octokit 3.0 aims to be hypermedia-driven, removing the internal URL
construction currently used throughout the client.

[hypermedia]: http://en.wikipedia.org/wiki/Hypermedia
[Sawyer]: https://github.com/lostisland/sawyer
[Faraday]: https://github.com/lostisland/faraday
[uri-templates]: http://tools.ietf.org/html/rfc6570

