require 'faraday'
require 'octokit/version'

module Octokit
  module Configuration
    VALID_OPTIONS_KEYS = [
      :adapter,
      :faraday_config_block,
      :api_version,
      :api_endpoint,
      :web_endpoint,
      :status_api_endpoint,
      :login,
      :password,
      :proxy,
      :oauth_token,
      :client_id,
      :client_secret,
      :user_agent,
      :request_host,
      :netrc,
      :auto_traversal,
      :per_page].freeze

    DEFAULT_ADAPTER             = Faraday.default_adapter
    DEFAULT_API_VERSION         = 3
    DEFAULT_API_ENDPOINT        = ENV['OCTOKIT_API_ENDPOINT'] || 'https://api.github.com/'
    DEFAULT_WEB_ENDPOINT        = ENV['OCTOKIT_WEB_ENDPOINT'] || 'https://github.com/'
    DEFAULT_STATUS_API_ENDPOINT = ENV['OCTOKIT_STATUS_API_ENDPOINT'] || 'https://status.github.com/api/'
    DEFAULT_USER_AGENT          = "Octokit Ruby Gem #{Octokit::VERSION}".freeze
    DEFAULT_AUTO_TRAVERSAL      = false

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

    def api_endpoint=(value)
      @api_endpoint = File.join(value, "")
    end

    def web_endpoint=(value)
      @web_endpoint = File.join(value, "")
    end

    def faraday_config(&block)
      @faraday_config_block = block
    end

    def reset
      self.adapter             = DEFAULT_ADAPTER
      self.api_version         = DEFAULT_API_VERSION
      self.api_endpoint        = DEFAULT_API_ENDPOINT
      self.web_endpoint        = DEFAULT_WEB_ENDPOINT
      self.status_api_endpoint = DEFAULT_STATUS_API_ENDPOINT
      self.login               = nil
      self.password            = nil
      self.proxy               = nil
      self.oauth_token         = nil
      self.client_id           = nil
      self.client_secret       = nil
      self.request_host        = nil
      self.netrc               = false
      self.user_agent          = DEFAULT_USER_AGENT
      self.auto_traversal      = DEFAULT_AUTO_TRAVERSAL
    end
  end
end
