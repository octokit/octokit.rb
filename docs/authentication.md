# @title Authentication
# Authentication

Octokit supports the various [authentication methods supported by the GitHub
API][auth]:

## Basic Authentication

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

## OAuth access tokens

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

## Using a .netrc file

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

## Application authentication

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
