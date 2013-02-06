module Octokit
  class Client
    module Events
      # List all public events for GitHub
      #
      # @return [Array] A list of all public events from GitHub
      # @see http://developer.github.com/v3/activity/events/#list-public-events
      # @example List all pubilc events
      #   Octokit.public_events
      def public_events(options={})
        get("events", options)
      end

      # List all user events
      #
      # @return [Array] A list of all user events
      # @see http://developer.github.com/v3/activity/events/#list-events-performed-by-a-user
      # @example List all user events
      #   Octokit.user_events("sferik")
      def user_events(user, options={})
        get("users/#{user}/events", options)
      end

      # List public user events
      #
      # @param user [String] GitHub username
      # @return [Array] A list of public user events
      # @see http://developer.github.com/v3/activity/events/#list-public-events-performed-by-a-user
      # @example List public user events
      #   Octokit.user_events("sferik")
      def user_public_events(user, options={})
        get("users/#{user}/events/public", options)
      end

      # List events that a user has received
      #
      # @return [Array] A list of all user received events
      # @see http://developer.github.com/v3/activity/events/#list-events-that-a-user-has-received
      # @example List all user received events
      #   Octokit.received_events("sferik")
      def received_events(user, options={})
        get("users/#{user}/received_events", options)
      end

      # List public events a user has received
      #
      # @return [Array] A list of public user received events
      # @see http://developer.github.com/v3/activity/events/#list-public-events-that-a-user-has-received
      # @example List public user received events
      #   Octokit.received_public_events("sferik")
      def received_public_events(user, options={})
        get("users/#{user}/received_events/public", options)
      end

      # List events for a repository
      #
      # @param repo [String, Repository, Hash] A GitHub repository
      # @return [Array] A list of events for a repository
      # @see http://developer.github.com/v3/activity/events/#list-repository-events
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

      # List all events for an organization
      #
      # Requires authenticated client.
      #
      # @param org [String] Organization GitHub handle
      # @return [Array] List of all events from a GitHub organization
      # @see http://developer.github.com/v3/activity/events/#list-events-for-an-organization
      # @example List events for the lostisland organization
      #   @client.organization_events("lostisland")
      def organization_events(org, options={})
        get("users/#{login}/events/orgs/#{org}", options)
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
