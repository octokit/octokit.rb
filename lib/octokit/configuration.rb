require 'faraday'
require File.expand_path('../version', __FILE__)

module Octokit
  module Configuration
    VALID_OPTIONS_KEYS = [:adapter, :endpoint, :format, :login, :password, :proxy, :token, :user_agent, :version].freeze
    VALID_FORMATS      = [:json, :xml, :yaml].freeze

    DEFAULT_ADAPTER    = Faraday.default_adapter.freeze
    DEFAULT_ENDPOINT   = 'https://github.com/'.freeze
    DEFAULT_FORMAT     = :json.freeze
    DEFAULT_LOGIN      = nil.freeze
    DEFAULT_PASSWORD   = nil.freeze
    DEFAULT_PROXY      = nil.freeze
    DEFAULT_TOKEN      = nil.freeze
    DEFAULT_USER_AGENT = "Octokit Ruby Gem #{Octokit::VERSION}".freeze
    DEFAULT_VERSION    = 2

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
      self.adapter    = DEFAULT_ADAPTER
      self.endpoint   = DEFAULT_ENDPOINT
      self.format     = DEFAULT_FORMAT
      self.login      = DEFAULT_LOGIN
      self.password   = DEFAULT_PASSWORD
      self.proxy      = DEFAULT_PROXY
      self.token      = DEFAULT_TOKEN
      self.user_agent = DEFAULT_USER_AGENT
      self.version    = DEFAULT_VERSION
    end
  end
end
