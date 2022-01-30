# Ruby
# Releasing a new version of octokit.rb

1. Create a list of all the changes since the prior release
    1. Compare the latest release to master using https://github.com/octokit/octokit.rb/compare/`${latest}`...master
    1. Open the linked pull requests from all the `Merge pull request #...` commits
    1. For all non-documentation PRs, copy title (including pull request number) into markdown list items
    1. (optional, but nice) Sort into logical buckets, like "support for additional endpoints", "enhancements", "bugfixes"
    1. Reorganize to put the pull request number at the start of the line
1. Ensure there are no breaking changes _(if there are breaking changes you'll need to create a release branch without those changes or bump the major version)_
1. Update the version
    1. Update the constant in `lib/octokit/version.rb`
    1. Commit and push directly to master
1. Run the `script/release` script to cut a release
1. Draft a new release at https://github.com/octokit/octokit.rb/releases/new containing the curated changelog

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
