Octokit
=======
Simple Ruby wrapper for the GitHub v2 API.

Installation
------------
    gem install octokit

Continuous Integration
----------------------
[![Build Status](http://travis-ci.org/pengwynn/octokit.png)](http://travis-ci.org/pengwynn/octokit)

Some examples
-------------

### Show a user

    Octokit.user('pengwynn')
    => <#Hashie::Mash blog="http://wynnnetherland.com" company="Orrka" created_at="2008/02/25 10:24:19 -0800" email="wynn.netherland@gmail.com" followers_count=21 following_count=55 id=865 location="Dallas, TX" login="pengwynn" name="Wynn Netherland" public_gist_count=4 public_repo_count=16>

### Show who a user follows

    Octokit.following('pengwynn')
    => ["cglee", "bryansray", "rails", "zachinglis", "wycats", "obie", "mully", "squeejee", "jderrett", "Shopify", "ReinH", "technoweenie", "errfree", "defunkt", "joshsusser", "hashrocket", "newbamboo", "bigtiger", "github", "jamis", "jeresig", "thoughtbot", "therealadam", "jnunemaker", "seaofclouds", "choan", "llimllib", "kwhinnery", "marshall", "handcrafted", "adamstac", "jashkenas", "dan", "remy", "hayesdavis", "documentcloud", "imathis", "mdeiters", "njonsson", "asenchi", "mattsa", "marclove", "webiest", "brogers", "polomasta", "stephp", "mchelen", "piyush", "davidnorth", "rmetzler", "jferris", "madrobby", "zh", "erikvold", "desandro"]

Working with repositories
-------------------------
For convenience, methods that require a repo argument may be passed in any of the following forms

* "pengwynn/linked"
* {:username => 'pengwynn', :name => 'linkedin'}
* {:username => 'pengwynn', :repo => 'linkedin'}
* instance of Repository

### Show a repo

    Octokit.repo("pengwynn/linkedin")
    => <#Hashie::Mash description="Ruby wrapper for the LinkedIn API" fork=false forks=1 homepage="http://bit.ly/ruby-linkedin" name="linkedin" open_issues=2 owner="pengwynn" private=false url="http://github.com/pengwynn/linkedin" watchers=36>

Authenticated requests
----------------------
Some methods require authentication so you'll need to pass a login and an api_token. You can find your GitHub API token on your [account page](https://github.com/account)

    client = Octokit::Client.new(:login => 'pengwynn', :token => 'OU812')
    client.follow!('adamstac')

Read the full [docs](http://rdoc.info/projects/pengwynn/octokit)

TODO
----
* Feed parsing
* More examples

Submitting a Pull Request
-------------------------
1. Fork the project.
2. Create a topic branch.
3. Implement your feature or bug fix.
4. Add documentation for your feature or bug fix.
5. Run <tt>bundle exec rake doc:yard</tt>. If your changes are not 100% documented, go back to step 4.
6. Add specs for your feature or bug fix.
7. Run <tt>bundle exec rake spec</tt>. If your changes are not 100% covered, go back to step 6.
8. Commit and push your changes.
9. Submit a pull request. Please do not include changes to the version or gemspec. (If you want to create your own version for some reason, please do so in a separate commit.)

Credits
-------
Octokit is inspired by [Octopi](http://github.com/fcoury/octopi) and aims to be a lightweight, less active-resourcey alternative.

Copyright
---------
Copyright (c) 2011 [Wynn Netherland](http://wynnnetherland.com), [Adam Stacoviak](http://adamstacoviak.com/), [Erik Michaels-Ober](https://github.com/sferik).
See [LICENSE](https://github.com/pengwynn/octokit/blob/master/LICENSE) for details.
