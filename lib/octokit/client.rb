require 'octokit/connection'
require 'octokit/warnable'
require 'octokit/arguments'
require 'octokit/repo_arguments'
require 'octokit/configurable'
require 'octokit/authentication'
require 'octokit/gist'
require 'octokit/rate_limit'
require 'octokit/repository'
require 'octokit/user'
require 'octokit/organization'
require 'octokit/preview'
require 'octokit/client/activity_events'
require 'octokit/client/activity_feeds'
require 'octokit/client/activity_notifications'
require 'octokit/client/apps'
require 'octokit/client/authorizations'
require 'octokit/client/checks_runs'
require 'octokit/client/checks_suites'
require 'octokit/client/commits'
require 'octokit/client/commit_comments'
require 'octokit/client/commit_pulls'
require 'octokit/client/community_profile'
require 'octokit/client/emojis'
require 'octokit/client/gists'
require 'octokit/client/gists_comments'
require 'octokit/client/gitignore'
require 'octokit/client/issues'
require 'octokit/client/issues_assignees'
require 'octokit/client/issues_comments'
require 'octokit/client/issues_events'
require 'octokit/client/issues_labels'
require 'octokit/client/issues_milestones'
require 'octokit/client/issues_timeline'
require 'octokit/client/legacy_search'
require 'octokit/client/licenses'
require 'octokit/client/markdown'
require 'octokit/client/marketplace'
require 'octokit/client/meta'
require 'octokit/client/objects'
require 'octokit/client/organizations'
require 'octokit/client/orgs_hooks'
require 'octokit/client/projects'
require 'octokit/client/projects_cards'
require 'octokit/client/projects_collaborators'
require 'octokit/client/projects_columns'
require 'octokit/client/pub_sub_hubbub'
require 'octokit/client/pulls'
require 'octokit/client/pulls_comments'
require 'octokit/client/rate_limit'
require 'octokit/client/reactions'
require 'octokit/client/refs'
require 'octokit/client/repos_contents'
require 'octokit/client/repos_downloads'
require 'octokit/client/repos_deployments'
require 'octokit/client/repos_hooks'
require 'octokit/client/repos_pages'
require 'octokit/client/repos_releases'
require 'octokit/client/repos_statistics'
require 'octokit/client/repos_statuses'
require 'octokit/client/repositories'
require 'octokit/client/repository_invitations'
require 'octokit/client/reviews'
require 'octokit/client/say'
require 'octokit/client/search'
require 'octokit/client/service_status'
require 'octokit/client/source_import'
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
    include Octokit::Preview
    include Octokit::Warnable
    include Octokit::Client::ActivityEvents
    include Octokit::Client::ActivityFeeds
    include Octokit::Client::ActivityNotifications
    include Octokit::Client::Apps
    include Octokit::Client::Authorizations
    include Octokit::Client::ChecksRuns
    include Octokit::Client::ChecksSuites
    include Octokit::Client::Commits
    include Octokit::Client::CommitComments
    include Octokit::Client::CommitPulls
    include Octokit::Client::CommunityProfile
    include Octokit::Client::Emojis
    include Octokit::Client::Gists
    include Octokit::Client::GistsComments
    include Octokit::Client::Gitignore
    include Octokit::Client::Issues
    include Octokit::Client::IssuesAssignees
    include Octokit::Client::IssuesComments
    include Octokit::Client::IssuesEvents
    include Octokit::Client::IssuesLabels
    include Octokit::Client::IssuesMilestones
    include Octokit::Client::IssuesTimeline
    include Octokit::Client::LegacySearch
    include Octokit::Client::Licenses
    include Octokit::Client::Markdown
    include Octokit::Client::Marketplace
    include Octokit::Client::Meta
    include Octokit::Client::Objects
    include Octokit::Client::Organizations
    include Octokit::Client::OrgsHooks
    include Octokit::Client::Projects
    include Octokit::Client::ProjectsCards
    include Octokit::Client::ProjectsCollaborators
    include Octokit::Client::ProjectsColumns
    include Octokit::Client::PubSubHubbub
    include Octokit::Client::Pulls
    include Octokit::Client::PullsComments
    include Octokit::Client::RateLimit
    include Octokit::Client::Reactions
    include Octokit::Client::Refs
    include Octokit::Client::ReposReleases
    include Octokit::Client::ReposContents
    include Octokit::Client::ReposDeployments
    include Octokit::Client::ReposDownloads
    include Octokit::Client::ReposHooks
    include Octokit::Client::Repositories
    include Octokit::Client::RepositoryInvitations
    include Octokit::Client::ReposPages
    include Octokit::Client::ReposStatistics
    include Octokit::Client::ReposStatuses
    include Octokit::Client::Reviews
    include Octokit::Client::Say
    include Octokit::Client::Search
    include Octokit::Client::ServiceStatus
    include Octokit::Client::SourceImport
    include Octokit::Client::Traffic
    include Octokit::Client::Users

    # Header keys that can be passed in options hash to {#get},{#head}
    CONVENIENCE_HEADERS = Set.new([:accept, :content_type])

    def initialize(options = {})
      # Use options passed in, but fall back to module defaults
      Octokit::Configurable.keys.each do |key|
        value = options[key].nil? ? Octokit.instance_variable_get(:"@#{key}") : options[key]
        instance_variable_set(:"@#{key}", value)
      end

      login_from_netrc unless user_authenticated? || application_authenticated?
    end

    # Text representation of the client, masking tokens and passwords
    #
    # @return [String]
    def inspect
      inspected = super

      # mask password
      inspected.gsub! @password, '*******' if @password
      inspected.gsub! @management_console_password, '*******' if @management_console_password
      inspected.gsub! @bearer_token, '********' if @bearer_token
      # Only show last 4 of token, secret
      inspected.gsub! @access_token, "#{'*'*36}#{@access_token[36..-1]}" if @access_token
      inspected.gsub! @client_secret, "#{'*'*36}#{@client_secret[36..-1]}" if @client_secret

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

    def client_without_redirects(options = {})
      conn_opts = @connection_options
      conn_opts[:url] = @api_endpoint
      conn_opts[:builder] = @middleware.dup if @middleware
      conn_opts[:proxy] = @proxy if @proxy
      conn_opts[:ssl] = { :verify_mode => @ssl_verify_mode } if @ssl_verify_mode
      conn = Faraday.new(conn_opts) do |http|
        if basic_authenticated?
          http.basic_auth(@login, @password)
        elsif token_authenticated?
          http.authorization 'token', @access_token
        elsif bearer_authenticated?
          http.authorization 'Bearer', @bearer_token
        end
        http.headers['accept'] = options[:accept] if options.key?(:accept)
      end
      conn.builder.delete(Octokit::Middleware::FollowRedirects)

      conn
    end
  end
end
