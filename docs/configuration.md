# @title Configuration and defaults
# Configuration and defaults

While `Octokit::Client` accepts a range of options when creating a new client
instance, Octokit's configuration API allows you to set your configuration
options at the module level. This is particularly handy if you're creating a
number of client instances based on some shared defaults.

## Configuring module defaults

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

## Using ENV variables

Default configuration values are specified in {Octokit::Default}. Many
attributes will look for a default value from the ENV before returning
Octokit's default.

```ruby
# Given $OCTOKIT_API_ENDPOINT is "http://api.github.dev"
Octokit.api_endpoint

# => "http://api.github.dev"
```
