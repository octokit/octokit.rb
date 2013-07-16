require 'octokit/client'
require 'octokit/default'

# Ruby toolkit for the GitHub API
module Octokit

  class << self
    include Octokit::Configurable

    # API client based on configured options {Configurable}
    #
    # @return [Octokit::Client] API wrapper
    def client
      @client = Octokit::Client.new(options) unless defined?(@client) && @client.same_options?(options)
      @client
    end

    # @private
    def respond_to_missing?(method_name, include_private=false); client.respond_to?(method_name, include_private); end if RUBY_VERSION >= "1.9"
    # @private
    def respond_to?(method_name, include_private=false); client.respond_to?(method_name, include_private) || super; end if RUBY_VERSION < "1.9"

  private

    def method_missing(method_name, *args, &block)
      return super unless client.respond_to?(method_name)
      client.send(method_name, *args, &block)
    end

  end
end

Octokit.setup
