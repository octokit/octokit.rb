require 'faraday'
require 'octokit/version'

module Octokit
  module Configuration
    VALID_OPTIONS_KEYS = [
      :adapter,
      :endpoint,
      :format,
      :login,
      :password,
      :proxy,
      :token,
      :oauth_token,
      :user_agent,
      :version].freeze

    VALID_FORMATS = [
      :json,
      :xml,
      :yaml].freeze

    DEFAULT_ADAPTER     = Faraday.default_adapter
    DEFAULT_ENDPOINT    = 'https://github.com/'.freeze
    DEFAULT_FORMAT      = :json
    DEFAULT_LOGIN       = nil
    DEFAULT_PASSWORD    = nil
    DEFAULT_PROXY       = nil
    DEFAULT_TOKEN       = nil
    DEFAULT_OAUTH_TOKEN = nil
    DEFAULT_USER_AGENT  = "Octokit Ruby Gem #{Octokit::VERSION}".freeze
    DEFAULT_VERSION     = 2

    attr_accessor *VALID_OPTIONS_KEYS

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
      self.adapter     = DEFAULT_ADAPTER
      self.endpoint    = DEFAULT_ENDPOINT
      self.format      = DEFAULT_FORMAT
      self.login       = DEFAULT_LOGIN
      self.password    = DEFAULT_PASSWORD
      self.proxy       = DEFAULT_PROXY
      self.token       = DEFAULT_TOKEN
      self.oauth_token = DEFAULT_OAUTH_TOKEN
      self.user_agent  = DEFAULT_USER_AGENT
      self.version     = DEFAULT_VERSION
    end
  end
end
