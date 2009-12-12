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
  
  def self.repo(options)
    Client.new.repo(options)
  end
  
  def self.list_repos(username)
    Client.new.list_repos(username)
  end
  
  def self.collaborators(options)
    Client.new.collaborators(options)
  end
  
  def self.network(options)
    Client.new.network(options)
  end
  
  def self.languages(options)
    Client.new.languages(options)
  end
  
  
  def self.tags(options)
    Client.new.tags(options)
  end
  
  def self.branches(options)
    Client.new.branches(options)
  end
  
  # Network Meta

  # username, repo
  def self.network_meta(options)
    Client.new.network_meta(options)
  end
  
  # username, repo
  def self.network_data(options)
    Client.new.network_data(options)
  end
  
end

require File.join(directory, 'octopussy', 'client')