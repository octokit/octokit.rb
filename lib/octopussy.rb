require 'forwardable'

require 'httparty'
require 'hashie'
Hash.send :include, Hashie::HashExtensions

libdir = File.dirname(__FILE__)
$LOAD_PATH.unshift(libdir) unless $LOAD_PATH.include?(libdir)

require 'octopussy/repo'
require 'octopussy/event'
require 'octopussy/client'


module Octopussy
  extend SingleForwardable

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
  class NotFound        < StandardError; end

  def self.client; Client.new end

  # Users
  def_delegators :client, :search_users, :user, :followers, :following, :follows?, :watched

  # Issues
  def_delegators :client, :search_issues, :issues, :issue

  # Repos
  def_delegators :client, :branches, :collaborators, :languages, :list_repos,
                 :network, :repo, :search_repos, :tags

  # Network Meta
  def_delegators :client, :network_meta, :network_data

  # Trees
  def_delegators :client, :tree, :blob, :raw
end
