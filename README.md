# Octokit

Ruby toolkit for the GitHub API.

![Logo][logo]
[logo]: http://cl.ly/image/3Y013H0A2z3z/gundam-ruby.png

Octokit 2.0 is out, check the [Upgrade Guide](#upgrading-guide) before
upgrading from 1.x.

## Philosophy

API wrappers [should reflect the idioms of the language in which they were
written][wrappers]. Octokit.rb wraps the [GitHub API][github-api] in a flat API
client that follows Ruby conventions and requires little knowledge of REST.
Most methods have positional arguments for required input and an options hash
for optional parameters, headers, or other options:

```ruby
# Fetch a README with Accept header for HTML format
Octokit.readme 'al3x/sovereign', :accept => 'application/vnd.github.html'
```


[wrappers]: http://wynnnetherland.com/journal/what-makes-a-good-api-wrapper
[github-api]: http://developer.github.com

## Quick start

Install via Rubygems

    gem install octokit

... or add to your Gemfile

    gem "octokit", "~> 2.0"

### Making requests

API methods are available as module methods (consuming module-level
configuration) or as client instance methods.

```ruby
# Provide authentication credentials
Octokit.configure do |c|
  c.login = 'defunkt'
  c.password = 'c0d3b4ssssss!'
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

### Consuming resources

Most methods return a `Resource` object which provides dot notation and `[]`
access for fields returned in the API response.

```ruby
# Fetch a user
user = Octokit.user 'jbarnette'
puts user.name
# => "John Barnette"
puts user.fields
# => <Set: {:login, :id, :gravatar_id, :type, :name, :company, :blog, :location, :email, :hireable, :bio, :public_repos, :followers, :following, :created_at, :updated_at, :public_gists}>
puts user[:company]
# => "GitHub"
user.rels[:gists].href
# => "https://api.github.com/users/jbarnette/gists"
```

**Note:** URL fields are culled into a separate `.rels` collection for easier
[Hypermedia](#hypermedia-agent) support.

### Accessing HTTP responses

While most methods return a `Resource` object or a Boolean, sometimes you may
need access to the raw HTTP response headers. You can access the last HTTP
response with `Client#last_response`:

```ruby
user      = Octokit.user 'andrewpthorp'
response  = Octokit.last_response
etag      = response.headers[:etag]
```

## Authentication

Octokit supports the various [authentication methods supported by the GitHub
API][auth]:

### Basic Authentication

Using your GitHub username and password is the easiest way to get started
making authenticated requests:

```ruby
client = Octokit::Client.new \
  :login    => 'defunkt',
  :password => 'c0d3b4ssssss!'

user = client.user
user.login
# => "defunkt"
```
While Basic Authentication makes it easy to get started quickly, OAuth access
tokens are the preferred way to authenticate on behalf of users.

### OAuth access tokens

[OAuth access tokens][oauth] provide two main benefits over using your username
and password:

* **Revokable access**. Access tokens can be revoked, removing access for just
  that token without having to change your password everywhere.
* **Limited access**. Access tokens have [access scopes][] which allow for more
  granular access to API resources. For instance, you can grant a third party
  access to your gists but not your private repositories.

To use an access token with the Octokit client, just pass it in lieu of your
username and password:

```ruby
client = Octokit::Client.new :access_token => "<your 40 char token>"

user = client.user
user.login
# => "defunkt"
```

You can use `.create_authorization` to create a token using Basic Authorization
that you can use for subsequent calls.

### Using a .netrc file

Octokit supports reading credentials from a netrc file (defaulting to
`~/.netrc`).  Given these lines in your netrc:

```
machine api.github.com
  login defunkt
  password c0d3b4ssssss!
```
You can now create a client with those credentials:

```ruby
client = Octokit::Client.new :netrc => true
client.login
# => "defunkt"
```
But _I want to use OAuth_ you say. Since the GitHub API supports using an OAuth
token as a Basic password, you totally can:

```
machine api.github.com
  login defunkt
  password <your 40 char token>
```

**Note:** Support for netrc requires adding the [netrc gem][] to your Gemfile
or `.gemspec`.

### Application authentication

Octokit also supports application-only authentication [using OAuth application client
credentials][app-creds]. Using application credentials will result in making
anonymous API calls on behalf of an application in order to take advantage of
the higher rate limit.

```ruby
client = Octokit::Client.new \
  :client_id     => "<your 20 char id>",
  :client_secret => "<your 40 char secret>"

user = client.users 'defunkt'
```



[auth]: http://developer.github.com/v3/#authentication
[oauth]: http://developer.github.com/v3/oauth/
[access scopes]: http://developer.github.com/v3/oauth/#scopes
[app-creds]: http://developer.github.com/v3/#unauthenticated-rate-limited-requests

## Pagination

Many GitHub API resources are [paginated][]. While you may be tempted to start
adding `:page` parameters to your calls, the API returns links to the next,
previous, and last pages for you in the `Link` response header as [Hypermedia
link relations](docs/hypermedia.md).

```ruby
issues = Octokit.issues 'rails/rails', :per_page => 100
issues.concat Octokit.last_response.rels[:next].get.data
```

### Auto pagination

For smallish resource lists, Octokit provides auto pagination. When this is
enabled, calls for paginated resources will fetch and concatenate the results
from every page into a single array:

```ruby
Octokit.auto_paginate = true
issues = Octokit.issues 'rails/rails'
issues.length

# => 702
```

**Note:** While Octokit auto pagination will set the page size to the maximum
`100`, and seek to not overstep your rate limit, you probably want to use a
custom pattern for traversing large lists.

[paginated]: http://developer.github.com/v3/#pagination

## Configuration and defaults

While `Octokit::Client` accepts a range of options when creating a new client
instance, Octokit's configuration API allows you to set your configuration
options at the module level. This is particularly handy if you're creating a
number of client instances based on some shared defaults.

### Configuring module defaults

Every writable attribute in {Octokit::Configurable} can be set one at a time:

```ruby
Octokit.api_endpoint = 'http://api.github.dev'
Octokit.web_endpoint = 'http://github.dev'
```

or in batch:

```ruby
Octokit.configure do |c|
  c.api_endpoint = 'http://api.github.dev'
  c.web_endpoint = 'http://github.dev'
end
```

### Using ENV variables

Default configuration values are specified in {Octokit::Default}. Many
attributes will look for a default value from the ENV before returning
Octokit's default.

```ruby
# Given $OCTOKIT_API_ENDPOINT is "http://api.github.dev"
Octokit.api_endpoint

# => "http://api.github.dev"
```

## Hypermedia agent

Starting in version 2.0, Octokit is [hypermedia][]-enabled. Under the hood,
{Octokit::Client} uses [Sawyer][], a hypermedia client built on [Faraday][].

### Hypermedia in Octokit

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

### URI templates

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

### The Full Hypermedia Experience™

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

## Upgrading guide

Version 2.0 includes a completely rewritten `Client` factory that now memoizes
client instances based on unique configuration options. Breaking changes also
include:

* `:oauth_token` is now `:access_token`
* `:auto_traversal` is now `:auto_paginate`
* `Hashie::Mash` has been removed. Responses now return a `Sawyer::Resource`
  object. This new type behaves mostly like a Ruby `Hash`, but does not fully
  support the `Hashie::Mash` API.
* Two new client error types are raised where appropriate:
  `Octokit::TooManyRequests` and `Octokit::TooManyLoginAttempts`
* The `search_*` methods from v1.x are now found at `legacy_search_*`
* Support for netrc requires including the [netrc gem][] in your Gemfile or
  gemspec.

[netrc gem]: https://rubygems.org/gems/netrc


## Advanced usage

Since Octokit employs [Faraday][faraday] under the hood, some behavior can be
extended via middleware.

### Debugging

Often, it helps to know what Octokit is doing under the hood. Faraday makes it
easy to peek into the underlying HTTP traffic:

```ruby
stack = Faraday::Builder.new do |builder|
  builder.response :logger
  builder.use Octokit::Response::RaiseError
  builder.adapter Faraday.default_adapter
end
Octokit.middleware = stack
Octokit.user 'pengwynn'
```
```
I, [2013-08-22T15:54:38.583300 #88227]  INFO -- : get https://api.github.com/users/pengwynn
D, [2013-08-22T15:54:38.583401 #88227] DEBUG -- request: Accept: "application/vnd.github.beta+json"
User-Agent: "Octokit Ruby Gem 2.0.0.rc4"
I, [2013-08-22T15:54:38.843313 #88227]  INFO -- Status: 200
D, [2013-08-22T15:54:38.843459 #88227] DEBUG -- response: server: "GitHub.com"
date: "Thu, 22 Aug 2013 20:54:40 GMT"
content-type: "application/json; charset=utf-8"
transfer-encoding: "chunked"
connection: "close"
status: "200 OK"
x-ratelimit-limit: "60"
x-ratelimit-remaining: "39"
x-ratelimit-reset: "1377205443"
...
```

See the [Faraday README][faraday] for more middleware magic.

### Caching

If you want to boost performance, stretch your API rate limit, or avoid paying
the hypermedia tax, you can use [Faraday Http Cache][cache].

Add the gem to your Gemfile

    gem 'faraday-http-cache'

Next, construct your own Faraday middleware:

```ruby
stack = Faraday::Builder.new do |builder|
  builder.use Faraday::HttpCache
  builder.use Octokit::Response::RaiseError
  builder.adapter Faraday.default_adapter
end
Octokit.middleware = stack
```

Once configured, the middleware will store responses in cache based on ETag
fingerprint and serve those back up for future `304` responses for the same
resource. See the [project README][cache] for advanced usage.


[cache]: https://github.com/plataformatec/faraday-http-cache
[faraday]: https://github.com/lostisland/faraday

## Hacking on Octokit.rb

If you want to hack on Octokit locally, we try to make [bootstrapping the
project][bootstrapping] as painless as possible. Just clone and run:

    script/bootstrap

This will install project dependencies and get you up and running. If you want
to run a Ruby console to poke on Octokit, you can crank one up with:

    script/console

Using the scripts in `./scripts` instead of `bundle exec rspec`, `bundle
console`, etc.  ensures your dependencies are up-to-date.

### Running and writing new tests

Octokit uses [VCR][] for recording and playing back API fixtures during test
runs. These fixtures are part of the Git project in the `spec/cassettes`
folder. For the most part, tests use an authenticated client, using a token
stored in `ENV['OCTOKIT_TEST_GITHUB_TOKEN']`. If you're not recording new
cassettes, you don't need to have this set. If you do need to record new
cassettes, this token can be any GitHub API token because the test suite strips
the actual token from the cassette output before storing to disk.

Since we periodically refresh our cassettes, please keep some points in mind
when writing new specs.

* **Specs should be idempotent**. The HTTP calls made during a spec should be
  able to be run over and over. This means deleting a known resource prior to
  creating it if the name has to be unique.
* **Specs should be able to be run in random order.** If a spec depends on
  another resource as a fixture, make sure that's created in the scope of the
  spec and not depend on a previous spec to create the data needed.
* **Do not depend on authenticated user info.** Instead of asserting
  actual values in resources, try to assert the existence of a key or that a
  response is an Array. We're testing the client, not the API.

[bootstrapping]: http://wynnnetherland.com/linked/2013012801/bootstrapping-consistency
[VCR]: https://github.com/vcr/vcr

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

## License

{include:file:LICENSE.md}
