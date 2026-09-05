# frozen_string_literal: true

require 'octokit/connection'
require 'octokit/warnable'
require 'octokit/arguments'
require 'octokit/repo_arguments'
require 'octokit/configurable'
require 'octokit/authentication'
require 'octokit/app_authentication'
require 'octokit/gist'
require 'octokit/rate_limit'
require 'octokit/repository'
require 'octokit/user'
require 'octokit/organization'
require 'octokit/client/actions_artifacts'
require 'octokit/client/actions_secrets'
require 'octokit/client/actions_workflows'
require 'octokit/client/actions_workflow_jobs'
require 'octokit/client/actions_workflow_runs'
require 'octokit/client/apps'
require 'octokit/client/checks'
require 'octokit/client/code_scanning'
require 'octokit/client/codespaces_secrets'
require 'octokit/client/commits'
require 'octokit/client/commit_comments'
require 'octokit/client/commit_pulls'
require 'octokit/client/commit_branches'
require 'octokit/client/community_profile'
require 'octokit/client/contents'
require 'octokit/client/downloads'
require 'octokit/client/dependabot_secrets'
require 'octokit/client/deployments'
require 'octokit/client/environments'
require 'octokit/client/emojis'
require 'octokit/client/events'
require 'octokit/client/feeds'
require 'octokit/client/gists'
require 'octokit/client/gitignore'
require 'octokit/client/hooks'
require 'octokit/client/issues'
require 'octokit/client/labels'
require 'octokit/client/legacy_search'
require 'octokit/client/licenses'
require 'octokit/client/meta'
require 'octokit/client/markdown'
require 'octokit/client/marketplace'
require 'octokit/client/milestones'
require 'octokit/client/notifications'
require 'octokit/client/oauth_applications'
require 'octokit/client/objects'
require 'octokit/client/organizations'
require 'octokit/client/pages'
require 'octokit/client/projects'
require 'octokit/client/pull_requests'
require 'octokit/client/rate_limit'
require 'octokit/client/reactions'
require 'octokit/client/refs'
require 'octokit/client/releases'
require 'octokit/client/repositories'
require 'octokit/client/repository_invitations'
require 'octokit/client/reviews'
require 'octokit/client/say'
require 'octokit/client/search'
require 'octokit/client/service_status'
require 'octokit/client/source_import'
require 'octokit/client/stats'
require 'octokit/client/statuses'
require 'octokit/client/tokens'
require 'octokit/client/traffic'
require 'octokit/client/users'
require 'ext/sawyer/relation'

module Octokit
  # Client for the GitHub API
  #
  # @see https://developer.github.com
  class Client
    include Octokit::Authentication
    include Octokit::Configurable
    include Octokit::Connection
    include Octokit::Warnable
    include Octokit::Client::ActionsArtifacts
    include Octokit::Client::ActionsSecrets
    include Octokit::Client::Checks
    include Octokit::Client::CodeScanning
    include Octokit::Client::CodespacesSecrets
    include Octokit::Client::Commits
    include Octokit::Client::CommitComments
    include Octokit::Client::CommitPulls
    include Octokit::Client::CommitBranches
    include Octokit::Client::CommunityProfile
    include Octokit::Client::Contents
    include Octokit::Client::DependabotSecrets
    include Octokit::Client::Deployments
    include Octokit::Client::Downloads
    include Octokit::Client::Environments
    include Octokit::Client::Emojis
    include Octokit::Client::Events
    include Octokit::Client::Feeds
    include Octokit::Client::Gists
    include Octokit::Client::Gitignore
    include Octokit::Client::Hooks
    include Octokit::Client::ActionsWorkflows
    include Octokit::Client::ActionsWorkflowJobs
    include Octokit::Client::ActionsWorkflowRuns
    include Octokit::Client::Apps
    include Octokit::Client::Issues
    include Octokit::Client::Labels
    include Octokit::Client::LegacySearch
    include Octokit::Client::Licenses
    include Octokit::Client::Meta
    include Octokit::Client::Markdown
    include Octokit::Client::Marketplace
    include Octokit::Client::Milestones
    include Octokit::Client::Notifications
    include Octokit::Client::OauthApplications
    include Octokit::Client::Objects
    include Octokit::Client::Organizations
    include Octokit::Client::Pages
    include Octokit::Client::Projects
    include Octokit::Client::PullRequests
    include Octokit::Client::RateLimit
    include Octokit::Client::Reactions
    include Octokit::Client::Refs
    include Octokit::Client::Releases
    include Octokit::Client::Repositories
    include Octokit::Client::RepositoryInvitations
    include Octokit::Client::Reviews
    include Octokit::Client::Say
    include Octokit::Client::Search
    include Octokit::Client::ServiceStatus
    include Octokit::Client::SourceImport
    include Octokit::Client::Stats
    include Octokit::Client::Statuses
    include Octokit::Client::Tokens
    include Octokit::Client::Traffic
    include Octokit::Client::Users
    include Octokit::AppAuthentication

    # Header keys that can be passed in options hash to {#get},{#head}
    CONVENIENCE_HEADERS = Set.new(%i[accept content_type])

    def initialize(options = {})
      # Use options passed in, but fall back to module defaults
      #
      # rubocop:disable Style/HashEachMethods
      #
      # This may look like a `.keys.each` which should be replaced with `#each_key`, but
      # this doesn't actually work, since `#keys` is just a method we've defined ourselves.
      # The class doesn't fulfill the whole `Enumerable` contract.
      Octokit::Configurable.keys.each do |key|
        # rubocop:enable Style/HashEachMethods
        value = options[key].nil? ? Octokit.instance_variable_get(:"@#{key}") : options[key]
        instance_variable_set(:"@#{key}", value)
      end

      reset_app_authentication
      login_from_netrc unless user_authenticated? || application_authenticated? || app_authenticated?
    end

    def reset!
      super
      reset_app_authentication
      @last_response = nil
      self
    end
    alias setup reset!

    # Text representation of the client, masking tokens and passwords
    #
    # @return [String]
    def inspect
      inspected = super

      # mask password
      inspected.gsub! @password, '*******' if @password
      inspected.gsub! @bearer_token, '********' if @bearer_token
      inspected.gsub! @private_key.inspect, '"********"' if @private_key.is_a?(String) && !@private_key.empty?
      # Only show last 4 of token, secret
      inspected.gsub! @access_token, masked_secret(@access_token) if @access_token
      inspected.gsub! @client_secret, masked_secret(@client_secret) if @client_secret

      inspected
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
    def as_app(key = client_id, secret = client_secret)
      if key.to_s.empty? || secret.to_s.empty?
        raise ApplicationCredentialsRequired, 'client_id and client_secret required'
      end

      app_client = dup
      app_client.app_id = nil
      app_client.private_key = nil
      app_client.installation_id = nil
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

    # Set Bearer Token for authentication
    #
    # @param value [String] JWT
    def bearer_token=(value)
      reset_agent
      @bearer_token = value
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

    # Set GitHub App ID
    #
    # @param value [String, Integer] GitHub App ID
    def app_id=(value)
      @app_id = value
      reset_app_authentication
    end

    # Set GitHub App private key
    #
    # @param value [String, OpenSSL::PKey::RSA] PEM-encoded private key or RSA key object
    def private_key=(value)
      @private_key = value
      reset_app_authentication
    end

    # Set GitHub App Installation ID
    #
    # @param value [Integer] Installation ID
    def installation_id=(value)
      @installation_id = value
      reset_app_authentication
    end

    def api_endpoint=(value)
      @api_endpoint = value
      reset_app_authentication
    end

    def client_without_redirects(options = {})
      conn = build_connection
      conn.url_prefix = api_endpoint
      http_cache_middleware = conn.builder.handlers.delete(Faraday::HttpCache) if Faraday.const_defined?(:HttpCache)
      configure_authentication(conn, include_application: false)
      conn.builder.handlers.push(http_cache_middleware) unless http_cache_middleware.nil?
      conn.headers['accept'] = options[:accept] if options.key?(:accept)
      conn.builder.delete(Octokit::Middleware::FollowRedirects)

      conn
    end

    private

    def initialize_copy(other)
      super
      reset_app_authentication
      @last_response = nil
    end

    def masked_secret(secret)
      return '*' * secret.length if secret.length <= 4

      "#{'*' * (secret.length - 4)}#{secret[-4, 4]}"
    end
  end
end
