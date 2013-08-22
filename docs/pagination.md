# @title Pagination
# Pagination

Many GitHub API resources are [paginated][]. While you may be tempted to start
adding `:page` parameters to your calls, the API returns links to the next,
previous, and last pages for you in the `Link` response header as [Hypermedia
link relations](docs/hypermedia.md).

```ruby
issues = Octokit.issues 'rails/rails', :per_page => 100
issues.concat Octokit.last_response.rels[:next].get.data
```

## Auto pagination

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
