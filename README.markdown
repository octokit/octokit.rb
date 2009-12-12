
# octopussy

<img src='http://upload.wikimedia.org/wikipedia/en/b/bb/007Octopussyposter.jpg' style='float: right; margin: 0 0 10px 10px'/>

Simple Ruby wrapper for the GitHub v2 API. 

## Installation

    sudo gem install octopussy
    
## Some examples

### Show a user

    Octopussy.user('pengwynn')
    => <#Hashie::Mash blog="http://wynnnetherland.com" company="Orrka" created_at="2008/02/25 10:24:19 -0800" email="wynn.netherland@gmail.com" followers_count=21 following_count=55 id=865 location="Dallas, TX" login="pengwynn" name="Wynn Netherland" public_gist_count=4 public_repo_count=16>
    
### Show who a user follows

    Octopussy.following('pengwynn')
    => ["cglee", "bryansray", "rails", "zachinglis", "wycats", "obie", "mully", "squeejee", "jderrett", "Shopify", "ReinH", "technoweenie", "errfree", "defunkt", "joshsusser", "hashrocket", "newbamboo", "bigtiger", "github", "jamis", "jeresig", "thoughtbot", "therealadam", "jnunemaker", "seaofclouds", "choan", "llimllib", "kwhinnery", "marshall", "handcrafted", "adamstac", "jashkenas", "dan", "remy", "hayesdavis", "documentcloud", "imathis", "mdeiters", "njonsson", "asenchi", "mattsa", "marclove", "webiest", "brogers", "polomasta", "stephp", "mchelen", "piyush", "davidnorth", "rmetzler", "jferris", "madrobby", "zh", "erikvold", "desandro"]
    
## Working with repositories

For convenience, methods that require a repo argument may be passed in any of the following forms

* "pengwynn/linked"
* {:username => 'pengwynn', :name => 'linkedin'}
* {:username => 'pengwynn', :repo => 'linkedin'}
* instance of Repo

### Show a repo

    Octopussy.repo("pengwynn/linkedin")
    => <#Hashie::Mash description="Ruby wrapper for the LinkedIn API" fork=false forks=1 homepage="http://bit.ly/ruby-linkedin" name="linkedin" open_issues=2 owner="pengwynn" private=false url="http://github.com/pengwynn/linkedin" watchers=36>
    
## Authenticated requests

Some methods require authentication so you'll need to pass a login and an api_token. You can find your GitHub API token on your [account page](https://github.com/account)

    client = Octopussy::Client.new(:login => 'pengwynn', :token => 'OU812')
    client.follow!('adamstac')

Read the full [docs](http://rdoc.info/projects/pengwynn/octopussy) or check out the [examples](http://github.com/pengwynn/octopussy/tree/master/examples)

## Note on Patches/Pull Requests
 
* Fork the project.
* Make your feature addition or bug fix.
* Add tests for it. This is important so I don't break it in a
  future version unintentionally.
* Commit, do not mess with rakefile, version, or history.
  (if you want to have your own version, that is fine but
   bump version in a commit by itself I can ignore when I pull)
* Send me a pull request. Bonus points for topic branches.

## Credits

Octopussy is inspired by [Octopi](http://github.com/fcoury/octopi) and aims to be a lightweight, less active-resourcey alternative.

## Copyright

Copyright (c) 2009 [Wynn Netherland](http://wynnnetherland.com), [Adam Stacoviak](http://adamstacoviak.com/). See LICENSE for details.