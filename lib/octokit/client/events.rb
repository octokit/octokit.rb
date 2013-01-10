module Octokit
  class Client
    module Events
      # List all public events for GitHub
      #
      # @return [Array] A list of all public events from GitHub
      # @see http://developer.github.com/v3/events
      # @example List all pubilc events
      #   Octokit.public_events
      def public_events(options={})
        get("events", options)
      end

      # List all user events
      #
      # @return [Array] A list of all user events
      # @see http://developer.github.com/v3/events
      # @example List all user events
      #   Octokit.user_events("sferik")
      def user_events(user, options={})
        get("users/#{user}/events", options)
      end

      # List events that a user has received
      #
      # @return [Array] A list of all user received events
      # @see http://developer.github.com/v3/received_events
      # @example List all user received events
      #   Octokit.received_events("sferik")
      def received_events(user, options={})
        get("users/#{user}/received_events", options)
      end

      # List events for a repository
      #
      # @param repo [String, Repository, Hash] A GitHub repository
      # @return [Array] A list of events for a repository
      # @see http://developer.github.com/v3/events
      # @example List events for a repository
      #   Octokit.repository_events("sferik/rails_admin")
      def repository_events(repo, options={})
        get("repos/#{Repository.new(repo)}/events", options)
      end

      # List public events for a repository's network
      #
      # @param repo [String, Repository, Hash] A GitHub repository
      # @return [Array] A list of events for a repository's network
      # @see http://developer.github.com/v3/activity/events/#list-public-events-for-a-network-of-repositories
      # @example List events for a repository's network
      #   Octokit.repository_network_events("sferik/rails_admin")
      def repository_network_events(repo, options={})
        get("networks/#{Repository.new repo}/events", options)
      end

      # List an organization's public events
      #
      # @param org [String] Organization GitHub username
      # @return [Array] List of public events from a GitHub organization
      # @see http://developer.github.com/v3/activity/events/#list-public-events-for-an-organization
      # @example List public events for GitHub
      #   Octokit.organization_public_events("GitHub")
      def organization_public_events(org, options={})
        get("orgs/#{org}/events", options)
      end

    end
  end
end
