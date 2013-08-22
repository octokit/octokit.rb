# @title Getting started
# Getting started

## Installation

Install via Rubygems

    gem install octokit

... or add to your Gemfile

    gem "octokit", "~> 2.0"

## Making requests

API methods are available as module methods (consuming module-level
configuration) or as client instance methods.

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

## Consuming resources

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

**Note:** URL fields are treated
differently, however, and culled into a separate `.rels` collection for easier
[Hypermedia](docs/hypermedia.md) support. Check out the [Getting Started guide](docs/getting-started.md) for more.

## Accessing HTTP responses

While most methods return a `Resource` object or a Boolean, sometimes you may
need access to the raw HTTP response headers. You can access the last HTTP
response with `Client#last_response`:

```ruby
user      = Octokit.user 'andrewpthorp'
response  = Octokit.last_response
etag      = response.headers[:etag]
```
