# frozen_string_literal: true

module Octokit
  class Client
    # Methods for the IssuesAssignees API
    #
    # @see https://developer.github.com/v3/issues/assignees/
    module IssuesAssignees
      # List assignees
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @return [Array<Sawyer::Resource>] A list of assignees
      # @see https://developer.github.com/v3/issues/assignees/#list-assignees
      def issue_assignees(repo, options = {})
        paginate "#{Repository.path repo}/assignees", options
      end

      # Check if a user can be assigned
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @param assignee [String] The assignee of the assigned
      # @return [Boolean] A single assigned
      # @see https://developer.github.com/v3/issues/assignees/#check-if-a-user-can-be-assigned
      def issue_assigned?(repo, assignee, options = {})
        boolean_from_response :get, "#{Repository.path repo}/assignees/#{assignee}", options
      end

      # Add assignees to an issue
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @param issue_number [Integer] The number of the issue
      # @option options [Array] :assignees Usernames of people to assign this issue to. NOTE: Only users with push access can add assignees to an issue. Assignees are silently ignored otherwise.
      # @return [Sawyer::Resource] The updated issue
      # @see https://developer.github.com/v3/issues/assignees/#add-assignees-to-an-issue
      def add_issue_assignees(repo, issue_number, options = {})
        post "#{Repository.path repo}/issues/#{issue_number}/assignees", options
      end

      # Remove assignees from an issue
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @param issue_number [Integer] The number of the issue
      # @option options [Array] :assignees Usernames of assignees to remove from an issue. NOTE: Only users with push access can remove assignees from an issue. Assignees are silently ignored otherwise.
      # @return [Sawyer::Resource] The updated issue
      # @see https://developer.github.com/v3/issues/assignees/#remove-assignees-from-an-issue
      def remove_issue_assignees(repo, issue_number, options = {})
        delete "#{Repository.path repo}/issues/#{issue_number}/assignees", options
      end
    end
  end
end
