require 'faraday'
require 'octokit/version'

module Octokit
  module Configuration
    VALID_OPTIONS_KEYS = [
      :adapter,
      :api_version,
      :login,
      :password,
      :proxy,
      :oauth_token,
      :user_agent,
      :auto_traversal,
      :per_page].freeze

    DEFAULT_ADAPTER        = Faraday.default_adapter
    DEFAULT_API_VERSION    = 3
    DEFAULT_USER_AGENT     = "Octokit Ruby Gem #{Octokit::VERSION}".freeze
    DEFAULT_AUTO_TRAVERSAL = false

    attr_accessor(*VALID_OPTIONS_KEYS)

    def self.extended(base)
      base.reset
    end

    def configure
      yield self
    end

    def options
      VALID_OPTIONS_KEYS.inject({}){|o,k| o.merge!(k => send(k)) }
    end

    def reset
      self.adapter        = DEFAULT_ADAPTER
      self.api_version    = DEFAULT_API_VERSION
      self.login          = nil
      self.password       = nil
      self.proxy          = nil
      self.oauth_token    = nil
      self.user_agent     = DEFAULT_USER_AGENT
      self.auto_traversal = DEFAULT_AUTO_TRAVERSAL
    end
  end
end
