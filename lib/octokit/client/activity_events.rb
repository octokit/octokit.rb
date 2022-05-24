# frozen_string_literal: true

module Octokit
  class Client
    # Methods for the ActivityEvents API
    #
    # @see https://developer.github.com/v3/activity/events/
    module ActivityEvents
      # List public events
      #
      #
      # @return [Array<Sawyer::Resource>] A list of events
      # @see https://developer.github.com/v3/activity/events/#list-public-events
      def public_events(options = {})
        paginate 'events', options
      end

      # List public organization events
      #
      # @param org [Integer, String] A GitHub organization id or login
      # @return [Array<Sawyer::Resource>] A list of events
      # @see https://developer.github.com/v3/activity/events/#list-public-organization-events
      def public_org_events(org, options = {})
        paginate "#{Organization.path org}/events", options
      end

      # List events for the authenticated user
      #
      # @param user [Integer, String] A GitHub user id or login
      # @return [Array<Sawyer::Resource>] A list of events
      # @see https://developer.github.com/v3/activity/events/#list-events-for-the-authenticated-user
      def user_events(user, options = {})
        paginate "#{User.path user}/events", options
      end

      # List events received by the authenticated user
      #
      # @param user [Integer, String] A GitHub user id or login
      # @return [Array<Sawyer::Resource>] A list of events
      # @see https://developer.github.com/v3/activity/events/#list-events-received-by-the-authenticated-user
      def user_received_events(user, options = {})
        paginate "#{User.path user}/received_events", options
      end

      # List public events for a network of repositories
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @return [Array<Sawyer::Resource>] A list of events
      # @see https://developer.github.com/v3/activity/events/#list-public-events-for-a-network-of-repositories
      def network_public_events(repo, options = {})
        paginate "networks/{owner}/#{repo}/events", options
      end

      # List public events for a user
      #
      # @param user [Integer, String] A GitHub user id or login
      # @return [Array<Sawyer::Resource>] A list of events
      # @see https://developer.github.com/v3/activity/events/#list-public-events-for-a-user
      def user_public_events(user, options = {})
        paginate "#{User.path user}/events/public", options
      end

      # List public events received by a user
      #
      # @param user [Integer, String] A GitHub user id or login
      # @return [Array<Sawyer::Resource>] A list of events
      # @see https://developer.github.com/v3/activity/events/#list-public-events-received-by-a-user
      def user_received_public_events(user, options = {})
        paginate "#{User.path user}/received_events/public", options
      end

      # List repository events
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @return [Array<Sawyer::Resource>] A list of events
      # @see https://developer.github.com/v3/activity/events/#list-repository-events
      def repo_events(repo, options = {})
        paginate "#{Repository.path repo}/events", options
      end

      # List organization events for the authenticated user
      #
      # @param user [Integer, String] A GitHub user id or login
      # @param org [Integer, String] A GitHub organization id or login
      # @return [Array<Sawyer::Resource>] A list of events
      # @see https://developer.github.com/v3/activity/events/#list-organization-events-for-the-authenticated-user
      def user_org_events(user, org, options = {})
        paginate "#{User.path user}/events/#{Organization.path org}", options
      end
    end
  end
end
