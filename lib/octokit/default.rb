require 'octokit/response/raise_error'
require 'octokit/version'

module Octokit

  # Default configuration options for {Client}
  module Default

    # Default API endpoint
    API_ENDPOINT = "https://api.github.com".freeze

    # Default User Agent header string
    USER_AGENT   = "Octokit Ruby Gem #{Octokit::VERSION}".freeze

    # Default media type
    MEDIA_TYPE   = "application/vnd.github.beta+json"

    # Default WEB endpoint
    WEB_ENDPOINT = "https://github.com".freeze

    # Default Faraday middleware stack
    MIDDLEWARE = Faraday::Builder.new do |builder|
      builder.use Octokit::Response::RaiseError
      builder.adapter Faraday.default_adapter
    end

    class << self

      # Configuration options
      # @return [Hash]
      def options
        Hash[Octokit::Configurable.keys.map{|key| [key, send(key)]}]
      end

      # Default access token from ENV
      # @return [String]
      def access_token
        ENV['OCTOKIT_ACCESS_TOKEN']
      end

      # Default API endpoint from ENV or {API_ENDPOINT}
      # @return [String]
      def api_endpoint
        ENV['OCTOKIT_API_ENDPOINT'] || API_ENDPOINT
      end

      # Default pagination preference from ENV
      # @return [String]
      def auto_paginate
        ENV['OCTOKIT_AUTO_PAGINATE']
      end

      # Default OAuth app key from ENV
      # @return [String]
      def client_id
        ENV['OCTOKIT_CLIENT_ID']
      end

      # Default OAuth app secret from ENV
      # @return [String]
      def client_secret
        ENV['OCTOKIT_SECRET']
      end

      # Default options for Faraday::Connection
      # @return [Hash]
      def connection_options
        {
          :headers => {
            :accept => default_media_type,
            :user_agent => user_agent
          }
        }
      end

      # Default media type from ENV or {MEDIA_TYPE}
      # @return [String]
      def default_media_type
        ENV['OCTOKIT_DEFAULT_MEDIA_TYPE'] || MEDIA_TYPE
      end

      # Default GitHub username for Basic Auth from ENV
      # @return [String]
      def login
        ENV['OCTOKIT_LOGIN']
      end

      # Default middleware stack for Faraday::Connection
      # from {MIDDLEWARE}
      # @return [String]
      def middleware
        MIDDLEWARE
      end

      # Default GitHub password for Basic Auth from ENV
      # @return [String]
      def password
        ENV['OCTOKIT_PASSWORD']
      end

      # Default pagination page size from ENV
      # @return [Fixnum] Page size
      def per_page
        page_size = ENV['OCTOKIT_PER_PAGE']

        page_size.to_i if page_size
      end

      # Default proxy server URI for Faraday connection from ENV
      # @return [String]
      def proxy
        ENV['OCTOKIT_PROXY']
      end

      # Default User-Agent header string from ENV or {USER_AGENT}
      # @return [String]
      def user_agent
        ENV['OCTOKIT_USER_AGENT'] || USER_AGENT
      end

      # Default web endpoint from ENV or {WEB_ENDPOINT}
      # @return [String]
      def web_endpoint
        ENV['OCTOKIT_WEB_ENDPOINT'] || WEB_ENDPOINT
      end

      # Default behavior for reading .netrc file
      # @return [Boolean]
      def netrc
        ENV['OCTOKIT_NETRC'] || false
      end

      # Default path for .netrc file
      # @return [String]
      def netrc_file
        ENV['OCTOKIT_NETRC_FILE'] || File.join(ENV['HOME'].to_s, '.netrc')
      end

    end
  end
end
