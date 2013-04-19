require 'sawyer'
require 'octokit/configurable'
require 'octokit/authentication'
require 'octokit/gist'
require 'octokit/rate_limit'
require 'octokit/client/emojis'
require 'octokit/client/gists'
require 'octokit/client/rate_limit'
require 'octokit/client/say'


module Octokit
  class Client
    include Octokit::Authentication
    include Octokit::Configurable
    include Octokit::Client::Emojis
    include Octokit::Client::Gists
    include Octokit::Client::RateLimit
    include Octokit::Client::Say

    attr_reader :last_response

    def initialize(options={})
      # Use options passed in, but fall back to module defaults
      Octokit::Configurable.keys.each do |key|
        instance_variable_set(:"@#{key}", options[key] || Octokit.instance_variable_get(:"@#{key}"))
      end
    end

    def same_options?(requested_options)
      requested_options.hash == options.hash
    end

    def inspect
      inspected = super

      # Mask passwords
      inspected = inspected.gsub(/(password)="(\w+)(",)/) { "#{$1}=\"*******#{$3}" }
      # Only show last 4 of tokens, secrets
      inspected = inspected.gsub(/(access_token|client_secret)="(\w+)(",)/) { "#{$1}=\"#{"*"*36}#{$2[36..-1]}#{$3}" }

      inspected
    end

    def get(url, options = {})
      request :get, url, options
    end

    def post(url, options = {})
      request :post, url, options
    end

    def put(url, options = {})
      request :put, url, options
    end

    def patch(url, options = {})
      request :patch, url, options
    end

    def delete(url, options = {})
      request :delete, url, options
    end

    def head(url, options = {})
      request :head, url, options
    end

    def paginate(url, options = {})
      options[:query] ||= {}
      if @auto_paginate || @per_page
        options[:query][:per_page] = @per_page || (@auto_paginate ? 100 : nil)
      end

      data = request(:get, url, options)

      if @auto_paginate && data.is_a?(Array)
        while @last_response.rels[:next] && rate_limit.remaining > 0
          @last_response = @last_response.rels[:next].get
          data.concat(@last_response.data) if @last_response.data.is_a?(Array)
        end

      end

      data
    end

    private

    def agent
      @agent ||= Sawyer::Agent.new(api_endpoint, sawyer_options) do |http|
        http.headers[:accept] = default_media_type
        http.headers[:user_agent] = user_agent
        if basic_authenticated?
          http.basic_auth(@login, @password)
        elsif token_authenticated?
          http.authorization 'token', @access_token
        end
      end
    end

    def request(method, url, options)
      if application_authenticated?
        options[:query] ||= {}
        options[:query].merge! application_authentication
      end
      if accept = options.delete(:accept)
        options[:headers] ||= {}
        options[:headers][:accept] = accept
      end

      @last_response = response = agent.call(method, url, options)
      response.data
    end

    # Executes the request, checking if it was successful
    #
    # @return [Boolean] True on success, false otherwise
    def boolean_from_response(method, path, options={})
      request(method, path, options)
      @last_response.status == 204
    end

    def sawyer_options
      opts = {
        :links_parser => Sawyer::LinkParsers::Simple.new
      }
      conn_opts = @connection_options
      conn_opts[:builder] = @middleware if @middleware
      conn_opts[:proxy] = @proxy if @proxy
      opts[:faraday] = Faraday.new(conn_opts)

      opts
    end

  end
end
