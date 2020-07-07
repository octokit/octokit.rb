# frozen_string_literal: true

module Octokit
  class Client
    # Methods for the IssuesMilestones API
    #
    # @see https://developer.github.com/v3/issues/milestones/
    module IssuesMilestones
      # List milestones
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @option options [String] :state The state of the milestone. Either open, closed, or all.
      # @option options [String] :sort What to sort results by. Either due_on or completeness.
      # @option options [String] :direction The direction of the sort. Either asc or desc.
      # @return [Array<Sawyer::Resource>] A list of milestones
      # @see https://developer.github.com/v3/issues/milestones/#list-milestones
      def issue_milestones(repo, options = {})
        paginate "#{Repository.path repo}/milestones", options
      end

      # Create a milestone
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @param title [String] The title of the milestone.
      # @option options [String] :state The state of the milestone. Either open or closed.
      # @option options [String] :description A description of the milestone.
      # @option options [String] :due_on The milestone due date. This is a timestamp in ISO 8601 (https://en.wikipedia.org/wiki/ISO_8601) format: YYYY-MM-DDTHH:MM:SSZ.
      # @return [Sawyer::Resource] The new milestone
      # @see https://developer.github.com/v3/issues/milestones/#create-a-milestone
      def create_issue_milestone(repo, title, options = {})
        opts = options.dup
        opts[:title] = title
        post "#{Repository.path repo}/milestones", opts
      end

      # Get a milestone
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @param milestone_number [Integer] The number of the milestone
      # @return [Sawyer::Resource] A single milestone
      # @see https://developer.github.com/v3/issues/milestones/#get-a-milestone
      def issue_milestone(repo, milestone_number, options = {})
        get "#{Repository.path repo}/milestones/#{milestone_number}", options
      end

      # Update a milestone
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @param milestone_number [Integer] The number of the milestone
      # @option options [String] :title The title of the milestone.
      # @option options [String] :state The state of the milestone. Either open or closed.
      # @option options [String] :description A description of the milestone.
      # @option options [String] :due_on The milestone due date. This is a timestamp in ISO 8601 (https://en.wikipedia.org/wiki/ISO_8601) format: YYYY-MM-DDTHH:MM:SSZ.
      # @return [Sawyer::Resource] The updated milestone
      # @see https://developer.github.com/v3/issues/milestones/#update-a-milestone
      def update_issue_milestone(repo, milestone_number, options = {})
        patch "#{Repository.path repo}/milestones/#{milestone_number}", options
      end

      # Delete a milestone
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @param milestone_number [Integer] The number of the milestone
      # @return [Boolean] True on success, false otherwise
      # @see https://developer.github.com/v3/issues/milestones/#delete-a-milestone
      def delete_issue_milestone(repo, milestone_number, options = {})
        boolean_from_response :delete, "#{Repository.path repo}/milestones/#{milestone_number}", options
      end
    end
  end
end
