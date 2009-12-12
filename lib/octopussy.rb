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
  
  def self.follows?(username, target)
    Client.new.follows?(username, target)
  end
  
  def self.watched(login)
    Client.new.watched(login)
  end
  
  # Issues
  
  def self.search_issues(repo, state, q)
    Client.new.search_issues(repo, state, q)
  end
  
  # repo, state
  def self.issues(repo, state)
    Client.new.issues(repo, state)
  end
  
  # repo, id
  def self.issue(repo, id)
    Client.new.issue(repo, id)
  end
  
  # Repos
  
  def self.search_repos(q)
    Client.new.search_repos(q)
  end
  
  def self.repo(repo)
    Client.new.repo(repo)
  end
  
  def self.list_repos(username)
    Client.new.list_repos(username)
  end
  
  def self.collaborators(repo)
    Client.new.collaborators(repo)
  end
  
  def self.network(repo)
    Client.new.network(repo)
  end
  
  def self.languages(repo)
    Client.new.languages(repo)
  end
  
  def self.tags(repo)
    Client.new.tags(repo)
  end
  
  def self.branches(repo)
    Client.new.branches(repo)
  end
  
  # Network Meta

  def self.network_meta(repo)
    Client.new.network_meta(repo)
  end
  
  def self.network_data(repo, nethash)
    Client.new.network_data(repo, nethash)
  end
  
  # Trees

  def self.tree(repo, sha)
    Client.new.tree(repo, sha)
  end

  def self.blob(repo, sha, path)
    Client.new.blob(repo, sha, path)
  end
  
  def self.raw(repo, sha)
    Client.new.raw(repo, sha)
  end
  
end

require File.join(directory, 'octopussy', 'repo')
require File.join(directory, 'octopussy', 'client')