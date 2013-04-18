module Octokit
  module Default

    API_ENDPOINT = "https://api.github.com".freeze
    USER_AGENT   = "Octokit Ruby Gem #{Octokit::VERSION}".freeze
    MEDIA_TYPE   = "application/vnd.github.beta+json"
    WEB_ENDPOINT = "https://github.com".freeze
    MIDDLEWARE = Faraday::Builder.new do |builder|
      builder.adapter Faraday.default_adapter
    end unless defined?(Octokit::Default::MIDDLEWARE)

    class << self

      def options
        Hash[Octokit::Configurable.keys.map{|key| [key, send(key)]}]
      end

      def access_token
        ENV['OCTOKIT_ACCESS_TOKEN']
      end

      def api_endpoint
        ENV['OCTOKIT_API_ENDPOINT'] || API_ENDPOINT
      end

      def auto_paginate
        ENV['OCTOKIT_AUTO_PAGINATE']
      end

      def client_id
        ENV['OCTOKIT_CLIENT_ID']
      end

      def client_secret
        ENV['OCTOKIT_SECRET']
      end

      def connection_options
        {
          :headers => {
            :accept => default_media_type,
            :user_agent => user_agent
          }
        }
      end

      def default_media_type
        ENV['OCTOKIT_DEFAULT_MEDIA_TYPE'] || MEDIA_TYPE
      end

      def login
        ENV['OCTOKIT_LOGIN']
      end

      def middleware
        MIDDLEWARE
      end

      def password
        ENV['OCTOKIT_PASSWORD']
      end

      def per_page
        ENV['OCTOKIT_PER_PAGE']
      end

      def proxy
        ENV['OCTOKIT_PROXY']
      end

      def user_agent
        ENV['OCTOKIT_USER_AGENT'] || USER_AGENT
      end

      def web_endpoint
        ENV['OCTOKIT_WEB_ENDPOINT'] || WEB_ENDPOINT
      end

    end
  end
end
