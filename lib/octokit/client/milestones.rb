module Octokit
  class Client
    # Methods for the Milestones API
    #
    # @see https://developer.github.com/v3/issues/milestones/
    module Milestones

      # List milestones for a repository
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @param options [String] :state The state of the milestone. Either `open`, `closed`, or `all`.
      # @param options [String] :sort What to sort results by. Either `due_on` or `completeness`.
      # @param options [String] :direction The direction of the sort. Either `asc` or `desc`.
      # @return [Sawyer::Resource] A single milestones
      # @see https://developer.github.com/v3/issues/milestones/#list-milestones-for-a-repository
      def milestones(repo, options = {})
        paginate "#{Repository.path repo}/milestones", options
      end

      # Create a milestone
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @param title [String] The title of the milestone.
      # @param options [String] :state The state of the milestone. Either `open` or `closed`.
      # @param options [String] :description A description of the milestone.
      # @param options [String] :due_on The milestone due date. This is a timestamp in [ISO 8601](https://en.wikipedia.org/wiki/ISO_8601) format: `YYYY-MM-DDTHH:MM:SSZ`.
      # @return [Sawyer::Resource] The new milestone
      # @see https://developer.github.com/v3/issues/milestones/#create-a-milestone
      def create_milestone(repo, title, options = {})
        options[:title] = title
        post "#{Repository.path repo}/milestones", options
      end

      # Get a single milestone
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @param milestone_number [Integer] milestone_number parameter
      # @return [Sawyer::Resource] A single milestone
      # @see https://developer.github.com/v3/issues/milestones/#get-a-single-milestone
      def milestone(repo, milestone_number, options = {})
        get "#{Repository.path repo}/milestones/#{milestone_number}", options
      end

      # Update a milestone
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @param milestone_number [Integer] milestone_number parameter
      # @param options [String] :title The title of the milestone.
      # @param options [String] :state The state of the milestone. Either `open` or `closed`.
      # @param options [String] :description A description of the milestone.
      # @param options [String] :due_on The milestone due date. This is a timestamp in [ISO 8601](https://en.wikipedia.org/wiki/ISO_8601) format: `YYYY-MM-DDTHH:MM:SSZ`.
      # @return [Sawyer::Resource] 
      # @see https://developer.github.com/v3/issues/milestones/#update-a-milestone
      def update_milestone(repo, milestone_number, options = {})
        patch "#{Repository.path repo}/milestones/#{milestone_number}", options
      end

      # Delete a milestone
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @param milestone_number [Integer] milestone_number parameter
      # @return [Boolean] True on success, false otherwise
      # @see https://developer.github.com/v3/issues/milestones/#delete-a-milestone
      def delete_milestone(repo, milestone_number, options = {})
        boolean_from_response :delete, "#{Repository.path repo}/milestones/#{milestone_number}", options
      end

      # Get labels for every issue in a milestone
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @param milestone_number [Integer] milestone_number parameter
      # @return [Sawyer::Resource] A single milestone labels
      # @see https://developer.github.com/v3/issues/labels/#get-labels-for-every-issue-in-a-milestone
      def milestone_labels(repo, milestone_number, options = {})
        paginate "#{Repository.path repo}/milestones/#{milestone_number}/labels", options
      end
    end
  end
end
