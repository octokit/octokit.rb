# Releasing a new version of octokit.rb

1. Create a list of all the changes since the prior release
    1. Compare the latest release to master using https://github.com/octokit/octokit.rb/compare/`${latest}`...master
    2. Open the linked pull requests from all the `Merge pull request #...` commits
    3. For all non-documentation PRs, copy title (including pull request number) into markdown list items
    4. (optional, but nice) Sort into logical buckets, like "support for additional endpoints", "enhancements", "bugfixes"
    5. Reorganize to put the pull request number at the start of the line
2. Ensure there are no breaking changes _(if there are breaking changes you'll need to create a release branch without those changes or bump the major version)_
3. Update the version
    1. Update the constant in `lib/octokit/version.rb`
    2. Run the "File integrity check"
    3. Commit the version change and push directly to master
4. Run the `script/release` script to cut a release
5. Draft a new release at https://github.com/octokit/octokit.rb/releases/new containing the curated changelog

----

## File integrity check

(Given octokit.rb is currently shipped "manually")

Because different environments behave differently, it is recommended that the integrity and file permissions of the files packed in the gem are verified. This is to help prevent things like releasing world writeable files in the gem. As we get things a little more automated, this will become unnecessary.

Until then, it is recommended that if you are preparing a release you run the following prior to releasing the gem:

From the root of octokit.rb

```
> gem build *.gemspec
```

Use the version from the build in the next commands

```
> tar -x -f octokit-#.##.#.gem 
> tar -t -v --numeric-owner -f data.tar.gz |head -n 10
```

The files in the output should have the following permessions set:  
`-rw-r--r--`

(optional) Once verified, you can run `git clean -dfx` to clean things up before packing 

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
