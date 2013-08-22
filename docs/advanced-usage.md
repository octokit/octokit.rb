# @title Advanced usage

# Advanced usage

Since Octokit employs [Faraday][faraday] under the hood, some behavior can be
extended via middleware.

## Debugging

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

## Caching

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

Once configured, the middleware will store responses in cached based on ETag
fingerprint and serve those back up for future `304` responses for the same
resource. See the [project README][cache] for advanced usage.


[cache]: https://github.com/plataformatec/faraday-http-cache
[faraday]: https://github.com/lostisland/faraday

