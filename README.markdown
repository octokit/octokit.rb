
# octopussy

Simple Ruby wrapper for the GitHub v2 API. 

![Octopussy poster](http://upload.wikimedia.org/wikipedia/en/b/bb/007Octopussyposter.jpg)

## Installation

    sudo gem install octopussy
    
## Usage

### Show a user

    Octopussy.user('pengwynn')
    => <#Hashie::Mash blog="http://wynnnetherland.com" company="Orrka" created_at="2008/02/25 10:24:19 -0800" email="wynn.netherland@gmail.com" followers_count=21 following_count=55 id=865 location="Dallas, TX" login="pengwynn" name="Wynn Netherland" public_gist_count=4 public_repo_count=16>
    

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