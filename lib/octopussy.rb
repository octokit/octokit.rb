require 'rubygems'

gem 'hashie', '~> 0.1.3'
require 'hashie'

gem 'httparty', '~> 0.4.5'
require 'httparty'

directory = File.expand_path(File.dirname(__FILE__))

Hash.send :include, Hashie::HashExtensions


module Octopussy
  class OctopussyError < StandardError
    attr_reader :data

    def initialize(data)
      @data = data
      super
    end
  end

  class RateLimitExceeded < StandardError; end
  class Unauthorized      < StandardError; end
  class General           < OctopussyError; end

  class Unavailable   < StandardError; end
  class InformOctopussy < StandardError; end
  class NotFound      < StandardError; end
  
  
  def self.search_users(q)
    Client.new.search_users(q)
  end
  
  def self.user(login)
    Client.new.user(login)
  end
  
  def self.followers(login)
    Client.new.followers(login)
  end
  
  def self.following(login)
    Client.new.following(login)
  end
  
  def self.watched(login)
    Client.new.watched(login)
  end
  
  # Issues
  
  def self.search_issues(options)
    Client.new.search_issues(options)
  end
  
  # username, repo, state
  def self.issues(options)
    Client.new.issues(options)
  end
  
  # username, repo, id
  def self.issue(options)
    Client.new.issue(options)
  end
  
  # Repos
  
  def self.search_repos(q)
    Client.new.search_repos(q)
  end
  
end

require File.join(directory, 'octopussy', 'client')