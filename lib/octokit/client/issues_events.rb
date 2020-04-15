# frozen_string_literal: true

module Octokit
  class Client
    # Methods for the IssuesEvents API
    #
    # @see https://developer.github.com/v3/issues/events/
    module IssuesEvents
      # Get a single event
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @param event_id [Integer] The ID of the event
      # @return [Sawyer::Resource] A single event
      # @see https://developer.github.com/v3/issues/events/#get-a-single-event
      def issue_event(repo, event_id, options = {})
        get "#{Repository.path repo}/issues/events/#{event_id}", options
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
