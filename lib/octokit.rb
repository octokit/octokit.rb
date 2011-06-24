require 'octokit/configuration'
require 'octokit/client'
require 'octokit/error'

module Octokit
  extend Configuration
  class << self
    # Alias for Octokit::Client.new
    #
    # @return [Octokit::Client]
    def client(options={})
      Octokit::Client.new(options)
    end

    # Delegate to Octokit::Client.new
    def method_missing(method, *args, &block)
      return super unless client.respond_to?(method)
      client.send(method, *args, &block)
    end

    def respond_to?(method, include_private=false)
      client.respond_to?(method, include_private) || super(method, include_private)
    end
  end
end
