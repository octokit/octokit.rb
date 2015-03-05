require 'sawyer'
require 'octokit/arguments'
require 'octokit/repo_arguments'
require 'octokit/configurable'
require 'octokit/authentication'
require 'octokit/gist'
require 'octokit/rate_limit'
require 'octokit/repository'
require 'octokit/user'
require 'octokit/organization'
require 'octokit/client/authorizations'
require 'octokit/client/commits'
require 'octokit/client/commit_comments'
require 'octokit/client/contents'
require 'octokit/client/downloads'
require 'octokit/client/deployments'
require 'octokit/client/emojis'
require 'octokit/client/events'
require 'octokit/client/feeds'
require 'octokit/client/gists'
require 'octokit/client/gitignore'
require 'octokit/client/hooks'
require 'octokit/client/issues'
require 'octokit/client/labels'
require 'octokit/client/legacy_search'
require 'octokit/client/meta'
require 'octokit/client/markdown'
require 'octokit/client/milestones'
require 'octokit/client/notifications'
require 'octokit/client/objects'
require 'octokit/client/organizations'
require 'octokit/client/pages'
require 'octokit/client/pub_sub_hubbub'
require 'octokit/client/pull_requests'
require 'octokit/client/rate_limit'
require 'octokit/client/refs'
require 'octokit/client/releases'
require 'octokit/client/repositories'
require 'octokit/client/say'
require 'octokit/client/search'
require 'octokit/client/service_status'
require 'octokit/client/stats'
require 'octokit/client/statuses'
require 'octokit/client/users'

module Octokit

  # Client for the GitHub API
  #
  # @see https://developer.github.com
  class Client

    include Octokit::Authentication
    include Octokit::Configurable
    include Octokit::Client::Authorizations
    include Octokit::Client::Commits
    include Octokit::Client::CommitComments
    include Octokit::Client::Contents
    include Octokit::Client::Deployments
    include Octokit::Client::Downloads
    include Octokit::Client::Emojis
    include Octokit::Client::Events
    include Octokit::Client::Feeds
    include Octokit::Client::Gists
    include Octokit::Client::Gitignore
    include Octokit::Client::Hooks
    include Octokit::Client::Issues
    include Octokit::Client::Labels
    include Octokit::Client::LegacySearch
    include Octokit::Client::Meta
    include Octokit::Client::Markdown
    include Octokit::Client::Milestones
    include Octokit::Client::Notifications
    include Octokit::Client::Objects
    include Octokit::Client::Organizations
    include Octokit::Client::Pages
    include Octokit::Client::PubSubHubbub
    include Octokit::Client::PullRequests
    include Octokit::Client::RateLimit
    include Octokit::Client::Refs
    include Octokit::Client::Releases
    include Octokit::Client::Repositories
    include Octokit::Client::Say
    include Octokit::Client::Search
    include Octokit::Client::ServiceStatus
    include Octokit::Client::Stats
    include Octokit::Client::Statuses
    include Octokit::Client::Users

    # Header keys that can be passed in options hash to {#get},{#head}
    CONVENIENCE_HEADERS = Set.new([:accept, :content_type])

    def initialize(options = {})
      # Use options passed in, but fall back to module defaults
      Octokit::Configurable.keys.each do |key|
        instance_variable_set(:"@#{key}", options[key] || Octokit.instance_variable_get(:"@#{key}"))
      end

      login_from_netrc unless user_authenticated? || application_authenticated?
    end

    # Compares client options to a Hash of requested options
    #
    # @param opts [Hash] Options to compare with current client options
    # @return [Boolean]
    def same_options?(opts)
      opts.hash == options.hash
    end

    # Text representation of the client, masking tokens and passwords
    #
    # @return [String]
    def inspect
      inspected = super

      # mask password
      inspected = inspected.gsub! @password, "*******" if @password
      # Only show last 4 of token, secret
      if @access_token
        inspected = inspected.gsub! @access_token, "#{'*'*36}#{@access_token[36..-1]}"
      end
      if @client_secret
        inspected = inspected.gsub! @client_secret, "#{'*'*36}#{@client_secret[36..-1]}"
      end

      inspected
    end

    # Make a HTTP GET request
    #
    # @param url [String] The path, relative to {#api_endpoint}
    # @param options [Hash] Query and header params for request
    # @return [Sawyer::Resource]
    def get(url, options = {})
      request :get, url, parse_query_and_convenience_headers(options)
    end

    # Make a HTTP POST request
    #
    # @param url [String] The path, relative to {#api_endpoint}
    # @param options [Hash] Body and header params for request
    # @return [Sawyer::Resource]
    def post(url, options = {})
      request :post, url, options
    end

    # Make a HTTP PUT request
    #
    # @param url [String] The path, relative to {#api_endpoint}
    # @param options [Hash] Body and header params for request
    # @return [Sawyer::Resource]
    def put(url, options = {})
      request :put, url, options
    end

    # Make a HTTP PATCH request
    #
    # @param url [String] The path, relative to {#api_endpoint}
    # @param options [Hash] Body and header params for request
    # @return [Sawyer::Resource]
    def patch(url, options = {})
      request :patch, url, options
    end

    # Make a HTTP DELETE request
    #
    # @param url [String] The path, relative to {#api_endpoint}
    # @param options [Hash] Query and header params for request
    # @return [Sawyer::Resource]
    def delete(url, options = {})
      request :delete, url, options
    end

    # Make a HTTP HEAD request
    #
    # @param url [String] The path, relative to {#api_endpoint}
    # @param options [Hash] Query and header params for request
    # @return [Sawyer::Resource]
    def head(url, options = {})
      request :head, url, parse_query_and_convenience_headers(options)
    end

    # Make one or more HTTP GET requests, optionally fetching
    # the next page of results from URL in Link response header based
    # on value in {#auto_paginate}.
    #
    # @param url [String] The path, relative to {#api_endpoint}
    # @param options [Hash] Query and header params for request
    # @param block [Block] Block to perform the data concatination of the
    #   multiple requests. The block is called with two parameters, the first
    #   contains the contents of the requests so far and the second parameter
    #   contains the latest response.
    # @return [Sawyer::Resource]
    def paginate(url, options = {}, &block)
      opts = parse_query_and_convenience_headers(options.dup)
      if @auto_paginate || @per_page
        opts[:query][:per_page] ||=  @per_page || (@auto_paginate ? 100 : nil)
      end

      data = request(:get, url, opts)

      if @auto_paginate
        while @last_response.rels[:next] && rate_limit.remaining > 0
          @last_response = @last_response.rels[:next].get
          if block_given?
            yield(data, @last_response)
          else
            data.concat(@last_response.data) if @last_response.data.is_a?(Array)
          end
        end

      end

      data
    end

    # Hypermedia agent for the GitHub API
    #
    # @return [Sawyer::Agent]
    def agent
      @agent ||= Sawyer::Agent.new(api_endpoint, sawyer_options) do |http|
        http.headers[:accept] = default_media_type
        http.headers[:content_type] = "application/json"
        http.headers[:user_agent] = user_agent
        if basic_authenticated?
          http.basic_auth(@login, @password)
        elsif token_authenticated?
          http.authorization 'token', @access_token
        elsif application_authenticated?
          http.params = http.params.merge application_authentication
        end
      end
    end

    # Fetch the root resource for the API
    #
    # @return [Sawyer::Resource]
    def root
      get "/"
    end

    # Response for last HTTP request
    #
    # @return [Sawyer::Response]
    def last_response
      @last_response if defined? @last_response
    end

    # Duplicate client using client_id and client_secret as
    # Basic Authentication credentials.
    # @example
    #   Octokit.client_id = "foo"
    #   Octokit.client_secret = "bar"
    #
    #   # GET https://api.github.com/?client_id=foo&client_secret=bar
    #   Octokit.get "/"
    #
    #   Octokit.client.as_app do |client|
    #     # GET https://foo:bar@api.github.com/
    #     client.get "/"
    #   end
    def as_app(key = client_id, secret = client_secret, &block)
      if key.to_s.empty? || secret.to_s.empty?
        raise ApplicationCredentialsRequired, "client_id and client_secret required"
      end
      app_client = self.dup
      app_client.client_id = app_client.client_secret = nil
      app_client.login    = key
      app_client.password = secret

      yield app_client if block_given?
    end

    # Set username for authentication
    #
    # @param value [String] GitHub username
    def login=(value)
      reset_agent
      @login = value
    end

    # Set password for authentication
    #
    # @param value [String] GitHub password
    def password=(value)
      reset_agent
      @password = value
    end

    # Set OAuth access token for authentication
    #
    # @param value [String] 40 character GitHub OAuth access token
    def access_token=(value)
      reset_agent
      @access_token = value
    end

    # Set OAuth app client_id
    #
    # @param value [String] 20 character GitHub OAuth app client_id
    def client_id=(value)
      reset_agent
      @client_id = value
    end

    # Set OAuth app client_secret
    #
    # @param value [String] 40 character GitHub OAuth app client_secret
    def client_secret=(value)
      reset_agent
      @client_secret = value
    end

    # Wrapper around Kernel#warn to print warnings unless
    # OCTOKIT_SILENT is set to true.
    #
    # @return [nil]
    def octokit_warn(*message)
      unless ENV['OCTOKIT_SILENT']
        warn message
      end
    end

    private

    def reset_agent
      @agent = nil
    end

    def request(method, path, data, options = {})
      if data.is_a?(Hash)
        options[:query]   = data.delete(:query) || {}
        options[:headers] = data.delete(:headers) || {}
        if accept = data.delete(:accept)
          options[:headers][:accept] = accept
        end
      end

      @last_response = response = agent.call(method, URI::Parser.new.escape(path.to_s), data, options)
      response.data
    end

    # Executes the request, checking if it was successful
    #
    # @return [Boolean] True on success, false otherwise
    def boolean_from_response(method, path, options = {})
      request(method, path, options)
      @last_response.status == 204
    rescue Octokit::NotFound
      false
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

    def parse_query_and_convenience_headers(options)
      headers = options.fetch(:headers, {})
      CONVENIENCE_HEADERS.each do |h|
        if header = options.delete(h)
          headers[h] = header
        end
      end
      query = options.delete(:query)
      opts = {:query => options}
      opts[:query].merge!(query) if query && query.is_a?(Hash)
      opts[:headers] = headers unless headers.empty?

      opts
    end
  end
end
