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

    # @private
    def const_missing(const_name)
      deprecated = %w(
        BadRequest
        Unauthorized
        Forbidden
        NotFound
        NotAcceptable
        UnprocessableEntity
        InternalServerError
        NotImplemented
        BadGateway
        ServiceUnavailable
      )
      super unless deprecated.include?(const_name.to_s)
      warn "`Octokit::#{const_name}` has been deprecated. Use `Octokit::Error::#{const_name}` instead."
      Octokit::Error.const_get(const_name)
    end

    private

    def method_missing(method_name, *args, &block)
      return super unless client.respond_to?(method_name)
      client.send(method_name, *args, &block)
    end

  end
end

Octokit.setup
