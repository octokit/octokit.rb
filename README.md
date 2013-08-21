# Octokit

Ruby toolkit for the GitHub API.

![Logo][logo]
[logo]: http://git.io/L4hkdg

## Philosophy

API wrappers [should reflect the idioms of the language in which they were
written][wrappers]. Octokit.rb wraps the [GitHub API][github-api] in a flat API
client that requires little knowledge of REST. Most methods have positional
arguments for required input and an options hash for optional parameters,
headers, or other options:

```ruby
# Fetch a README with Accept header for HTML format
Octokit.readme 'al3x/sovereign', :accept => 'application/vnd.github.html'
```

API methods are available as module methods, consuming module-level
configuration or as client instance methods.

```ruby
# Provide authentication credentials
Octokit.configure do |c|
  c.login 'defunkt'
  c.password 'c0d3b4ssssss!'
end

# Fetch the current user
Octokit.user
```
or

```ruby
# Provide authentication credentials
client = Octokit::Client.new :login => 'defunkt', :password => 'c0d3b4ssssss!'
# Fetch the current user
client.user
```

[wrappers]: http://wynnnetherland.com/journal/what-makes-a-good-api-wrapper
[github-api]: http://developer.github.com

## Quick start

Install via Rubygems

    gem install octokit

... or add to your Gemfile

    gem "octokit"

### Making requests and consuming resources:

Most methods return a `Resource` object which provides dot notation and `[]`
access for fields returned in the API response. 

**Note:** URL fields are treated
differently, however, and culled into a separate `.rels` collection for easier
[Hypermedia](docs/hypermedia.md) support.

```ruby
# Fetch a user
user = Octokit.user 'jbarnette'
puts user.name
# => "John Barnette"
puts user.fields
# => <Set: {:login, :id, :gravatar_id, :type, :name, :company, :blog, :location, :email, :hireable, :bio, :public_repos, :followers, :following, :created_at, :updated_at, :public_gists}>
user.rels[:gists].href
# => "https://api.github.com/users/jbarnette/gists"
```

Check out the [Getting Started guide](docs/getting-started.md) for more.


## Documentation

* [Getting Started guide](docs/getting-started.md)
* [Configuration and defaults](docs/configuration.md)
* [Authentication](docs/authentication.md)
* [Pagination](docs/pagination.md)
* [Hypermedia agent](docs/hypermedia.md)
* [Advanced usage](docs/advanced-usage.md)
* [Hacking on Octokit](docs/hacking-on-octokit.rb)

## Supported Ruby Versions

This library aims to support and is [tested against][travis] the following Ruby
implementations:

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

    spec.add_dependency 'octokit', '~> 2.0'

[semver]: http://semver.org/
[pvc]: http://docs.rubygems.org/read/chapter/16#page74

## Copyright

Copyright (c) 2011-2013 Wynn Netherland, Adam Stacoviak, Erik Michaels-Ober.
See [LICENSE][] for details.

[license]: LICENSE.md
