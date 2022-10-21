# Releasing a new version of octokit.rb

1. Create a list of all the changes since the prior release
    1. Compare the latest release to master using https://github.com/octokit/octokit.rb/compare/`${latest}`...master
    2. Open the linked pull requests from all the `Merge pull request #...` commits
    3. For all non-documentation PRs, copy title (including pull request number) into markdown list items
    4. (optional, but nice) Sort into logical buckets, like "support for additional endpoints", "enhancements", "bugfixes"
    5. Reorganize to put the pull request number at the start of the line
2. Ensure there are no breaking changes _(if there are breaking changes you'll need to create a release branch without those changes or bump the major version)_
3. Update the version in `lib/octokit/version.rb`
4. Run `script/release` with no parameters to execute a dry run of a release
5. Run the `script/release -r` script to cut a release. This will perform some sanity checks on permissions, build the gem into a `.gem` file, create a commit for your new version, tag the commit with the new version, push the commit and tag to GitHub and finally push the gem to RubyGems.
6. Draft a new release at https://github.com/octokit/octokit.rb/releases/new containing the curated changelog

----

## Prerequisites

In order to create a release, you will need to be an owner of the octokit gem on Rubygems.

Verify with:
```
gem owner octokit
```

An existing owner can add new owners with:
```
gem owner octokit --add EMAIL
```
