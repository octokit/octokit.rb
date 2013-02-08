# CHANGELOG

# 1.23.0

* [Meta API][]
* [Status API][]

View [the full changelog][1.23.0].
[1.23.0]: https://github.com/pengwynn/octokit/compare/v1.22.0...v1.23.0


[Meta API]: http://developer.github.com/v3/meta/
[Status API]: https://status.github.com/api

# 1.22.0

* Patch from @[gonzoyumo][] to fix service hooks

[gonzoyumo]: https://github.com/gonzoyumo

View [the full changelog][1.22.0].
[1.22.0]: https://github.com/pengwynn/octokit/compare/v1.21.0...v1.22.0

# 1.21.0

[@joeyw](https://github.com/joeyw) added:

* 9df8662f3dddceba88a179029d9811ca8f201784 `.repository network events`
* 005723269f56fc59fc58c2d7f4eb2b6da1ee0b4a `.organization_public_events`
* f952ab54207f3d0bc5dc50bb822768444a777a70 `.received_public_events`
* c2e42b70d4f5fc219bd399bc2e645cce2cc168e9 `.user_public_events`
* ae9aaea3a25bee4cc17176419ebc5142aba2f729 `.organization_events`

View [the full changelog][1.21.0].
[1.21.0]: https://github.com/pengwynn/octokit/compare/v1.20.0...v1.21.0

# 1.20.0

* [@joeyw](https://github.com/joeyw) added `.all_users` and `.all_repositories`
* [@joeyw](https://github.com/joeyw) added `.issues_comments` and `.pull_request_comments`
* [@x3ro](https://github.com/x3ro) added some date parsing to Commits API
* .netrc support

View [the full changelog][1.20.0].
[1.20.0]: https://github.com/pengwynn/octokit/compare/v1.19.0...v1.20.0


# 1.19.0

This version has some substantial rewiring internally to support non-JSON
[media types][media-types]:

```ruby
Octokit.contents 'pengwynn/octokit', :path => 'README.md', :accept => 'application/vnd.github.html'
```

Additionally, all methods that return empty body responses for `GET`, `DELETE`,
and `PUT`, return a Boolean instead of raw HTTP Response or status code.

This version also introduces a couple of new methods:

* `scopes`: Check the scopes on an OAuth token
* `octocat`: Your daily dose of GitHub API Zen.

View [the full changelog][1.19.0].
[1.19.0]: https://github.com/pengwynn/octokit/compare/v1.18.0...v1.19.0

## Previous versions

* [1.18.0 - October 15, 2012](https://github.com/pengwynn/octokit/compare/v1.17.1...v1.18.0)
* [1.17.1 - October 11, 2012](https://github.com/pengwynn/octokit/compare/v1.17.0...v1.17.1)
* [1.17.0 - October 8, 2012](https://github.com/pengwynn/octokit/compare/v1.16.0...v1.17.0)
* [1.16.0 - September 25,2012](https://github.com/pengwynn/octokit/compare/v1.15.1...v1.16.0)
* [1.15.1 - September 24,2012](https://github.com/pengwynn/octokit/compare/v1.15.0...v1.15.1)
* [1.15.0 - September 24,2012](https://github.com/pengwynn/octokit/compare/v1.14.0...v1.15.0)
* [1.14.0 - September 22,2012](https://github.com/pengwynn/octokit/compare/v1.13.0...v1.14.0)
* [1.13.0 - September 5, 2012](https://github.com/pengwynn/octokit/compare/v1.12.0...v1.13.0)
* [1.12.0 - September 4, 2012](https://github.com/pengwynn/octokit/compare/v1.11.0...v1.12.0)
* [1.11.0 - August 29, 2012](https://github.com/pengwynn/octokit/compare/v1.10.0...v1.11.0)
* [1.10.0 - August 8, 2012](https://github.com/pengwynn/octokit/compare/v1.9.4...v1.10.0)
* [1.9.4 - August 6, 2012](https://github.com/pengwynn/octokit/compare/v1.9.3...v1.9.4)
* [1.9.3 - July 27, 2012](https://github.com/pengwynn/octokit/compare/v1.9.2...v1.9.3)
* [1.9.2 - July 25, 2012](https://github.com/pengwynn/octokit/compare/v1.9.1...v1.9.2)
* [1.9.1 - July 11, 2012](https://github.com/pengwynn/octokit/compare/v1.8.1...v1.9.1)
* [1.8.1 - June 18, 2012](https://github.com/pengwynn/octokit/compare/v1.8.0...v1.8.1)
* [1.7.0 - June 18, 2012](https://github.com/pengwynn/octokit/compare/v1.6.1...v1.7.0)
* [1.6.1 - June 14, 2012](https://github.com/pengwynn/octokit/compare/v1.6.0...v1.6.1)
* [1.6.0 - June 14, 2012](https://github.com/pengwynn/octokit/compare/v1.5.0...v1.6.0)
* [1.5.0 - June 14, 2012](https://github.com/pengwynn/octokit/compare/v1.4.0...v1.5.0)
* [1.4.0 - June 3, 2012](https://github.com/pengwynn/octokit/compare/v1.3.0...v1.4.0)
* [1.3.0 - May 17, 2012](https://github.com/pengwynn/octokit/compare/v1.2.1...v1.3.0)
* [1.2.0 - May 17, 2012](https://github.com/pengwynn/octokit/compare/v1.1.1...v1.2.0)
* [1.1.1 - May 15, 2012](https://github.com/pengwynn/octokit/compare/v1.1.0...v1.1.1)
* [1.1.0 - May 13, 2012](https://github.com/pengwynn/octokit/compare/v1.0.7...v1.1.0)
* [1.0.7 - May 11, 2012](https://github.com/pengwynn/octokit/compare/v1.0.6...v1.0.7)
* [1.0.6 - May 11, 2012](https://github.com/pengwynn/octokit/compare/v1.0.5...v1.0.6)
* [1.0.5 - May 2, 2012](https://github.com/pengwynn/octokit/compare/v1.0.4...v1.0.5)
* [1.0.4 - April 24, 2012](https://github.com/pengwynn/octokit/compare/v1.0.3...v1.0.4)
* [1.0.3 - April 18, 2012](https://github.com/pengwynn/octokit/compare/v1.0.2...v1.0.3)
* [1.0.2 - March 31, 2012](https://github.com/pengwynn/octokit/compare/v1.0.1...v1.0.2)
* [1.0.1 - March 31, 2012](https://github.com/pengwynn/octokit/compare/v1.0.0...v1.0.1)
* [1.0.0 - February 12, 2012](https://github.com/pengwynn/octokit/compare/v0.6.5...v1.0.0)
* [0.6.5 - October 15, 2011](https://github.com/pengwynn/octokit/compare/v0.6.4...v0.6.5)
* [0.6.4 - July 2, 2011](https://github.com/pengwynn/octokit/compare/v0.6.3...v0.6.4)
* [0.6.3 - May 5, 2011](https://github.com/pengwynn/octokit/compare/v0.6.2...v0.6.3)
* [0.6.2 - April 26, 2011](https://github.com/pengwynn/octokit/compare/v0.6.1...v0.6.2)
* [0.6.1 - April 6, 2011](https://github.com/pengwynn/octokit/compare/v0.6.0...v0.6.1)
* [0.6.0 - March 20, 2011](https://github.com/pengwynn/octokit/compare/v0.5.2...v0.6.0)
* [0.5.2 - February 6, 2011](https://github.com/pengwynn/octokit/compare/v0.5.1...v0.5.2)
* [0.5.1 - February 3, 2011](https://github.com/pengwynn/octokit/compare/v0.5.0...v0.5.1)
* [0.5.0 - January 21, 2011](https://github.com/pengwynn/octokit/compare/v0.4.1...v0.5.0)
* [0.4.1 - January 8, 2011](https://github.com/pengwynn/octokit/compare/v0.2.3...v0.4.1)
* [0.2.3 - June 17, 2010](https://github.com/pengwynn/octokit/compare/v0.2.2...v0.2.3)
* [0.2.2 - June 8, 2010](https://github.com/pengwynn/octokit/compare/v0.2.1...v0.2.2)
* [0.2.1 - May 4, 2010](https://github.com/pengwynn/octokit/compare/v0.2.0...v0.2.1)
* [0.2.0 - April 30, 2010](https://github.com/pengwynn/octokit/compare/v0.1.4...v0.2.0)
* [0.1.4 - January 13, 2010](https://github.com/pengwynn/octokit/compare/v0.1.3...v0.1.4)
* [0.1.3 - December 16, 2009](https://github.com/pengwynn/octokit/compare/v0.1.2...v0.1.3)
* [0.1.2 - December 16, 2009](https://github.com/pengwynn/octokit/compare/v0.1.1...v0.1.2)
* [0.1.1 - December 15, 2009](https://github.com/pengwynn/octokit/compare/v0.1.0...v0.1.1)
* [0.1.0 - December 12, 2009](https://github.com/pengwynn/octokit/compare/v0.0.1...v0.1.0)
* [0.0.1 - December 12, 2009](https://github.com/pengwynn/octokit/compare/cb7d5480944229e1a5ddfa9d1113903628765584...v0.0.1)


[media-types]: http://developer.github.com/v3/media/
