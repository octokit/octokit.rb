# frozen_string_literal: true

module Octokit
  class Client
    # Methods for the Events API
    #
    # @see https://developer.github.com/v3/activity/events/
    module Events
      # List public events
      #
      #
      # @return [Array<Sawyer::Resource>] A list of events
      # @see https://developer.github.com/v3/activity/events/#list-public-events
      def public_events(options = {})
        paginate 'events', options
      end

      # List events received by the authenticated user
      #
      # @param user [Integer, String] A GitHub user id or login
      # @return [Array<Sawyer::Resource>] A list of events
      # @see https://developer.github.com/v3/activity/events/#list-events-received-by-the-authenticated-user
      def user_received_events(user, options = {})
        paginate "#{User.path user}/received_events", options
      end

      # List events for the authenticated user
      #
      # @param user [Integer, String] A GitHub user id or login
      # @return [Array<Sawyer::Resource>] A list of events
      # @see https://developer.github.com/v3/activity/events/#list-events-for-the-authenticated-user
      def user_events(user, options = {})
        paginate "#{User.path user}/events", options
      end

      # List public organization events
      #
      # @param org [Integer, String] A GitHub organization id or login
      # @return [Array<Sawyer::Resource>] A list of events
      # @see https://developer.github.com/v3/activity/events/#list-public-organization-events
      def public_org_events(org, options = {})
        paginate "#{Organization.path org}/events", options
      end

      # List public events received by a user
      #
      # @param user [Integer, String] A GitHub user id or login
      # @return [Array<Sawyer::Resource>] A list of events
      # @see https://developer.github.com/v3/activity/events/#list-public-events-received-by-a-user
      def user_received_public_events(user, options = {})
        paginate "#{User.path user}/received_events/public", options
      end

      # List public events for a network of repositories
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @return [Array<Sawyer::Resource>] A list of events
      # @see https://developer.github.com/v3/activity/events/#list-public-events-for-a-network-of-repositories
      def network_public_events(repo, options = {})
        paginate "networks/{owner}/#{repo}/events", options
      end

      # List repository events
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @return [Array<Sawyer::Resource>] A list of events
      # @see https://developer.github.com/v3/activity/events/#list-repository-events
      def repo_events(repo, options = {})
        paginate "#{Repository.path repo}/events", options
      end

      # List public events for a user
      #
      # @param user [Integer, String] A GitHub user id or login
      # @return [Array<Sawyer::Resource>] A list of events
      # @see https://developer.github.com/v3/activity/events/#list-public-events-for-a-user
      def user_public_events(user, options = {})
        paginate "#{User.path user}/events/public", options
      end

      # Get a single event
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @param event_id [Integer] The ID of the event
      # @return [Sawyer::Resource] A single event
      # @see https://developer.github.com/v3/issues/events/#get-a-single-event
      def issue_event(repo, event_id, options = {})
        get "#{Repository.path repo}/issues/events/#{event_id}", options
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

      # List events for a repository
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @return [Array<Sawyer::Resource>] A list of events
      # @see https://developer.github.com/v3/issues/events/#list-events-for-a-repository
      def issues_events(repo, options = {})
        paginate "#{Repository.path repo}/issues/events", options
      end

      # List events for an issue
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @param issue_number [Integer] The number of the issue
      # @return [Array<Sawyer::Resource>] A list of events
      # @see https://developer.github.com/v3/issues/events/#list-events-for-an-issue
      def issue_events(repo, issue_number, options = {})
        paginate "#{Repository.path repo}/issues/#{issue_number}/events", options
      end
    end
  end
end
