# @title Hacking on Octokit.rb
# Hacking on Octokit.rb

If you want to hack on Octokit locally, we try to make [bootstrapping the
project][bootstrapping] as painless as possible. Just clone and run:

    script/bootstrap

This will install project dependencies and get you up and running. If you want
to run a Ruby console to poke on Octokit, you can crank one up with:

    script/console

Using the scripts in `./scripts` instead of `bundle exec rspec`, `bundle
console`, etc.  ensures your dependencies are up-to-date.

## Running and writing new tests

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
* **Try to avoid assert on authenticated user info.** Instead of asserting
  actual values in resources, try to assert the existence of a key or that a
  response is an Array. We're testing the client, not the API.

[bootstrapping]: http://wynnnetherland.com/linked/2013012801/bootstrapping-consistency
[VCR]: https://github.com/vcr/vcr
