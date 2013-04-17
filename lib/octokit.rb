require 'octokit/client'
require 'octokit/default'

module Octokit
  class << self
    include Octokit::Configurable

    def client
      @client = Octokit::Client.new(options) unless defined?(@client) && @client.same_options?(options)
      @client
    end

    def respond_to_missing?(method_name, include_private=false); client.respond_to?(method_name, include_private); end if RUBY_VERSION >= "1.9"
    def respond_to?(method_name, include_private=false); client.respond_to?(method_name, include_private) || super; end if RUBY_VERSION < "1.9"

  private

    def method_missing(method_name, *args, &block)
      return super unless client.respond_to?(method_name)
      client.send(method_name, *args, &block)
    end

  end
end
