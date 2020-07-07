# frozen_string_literal: true

module Octokit
  class Client
    # Methods for the ReposStatuses API
    #
    # @see https://developer.github.com/v3/repos/statuses/
    module ReposStatuses
      # Create a commit status
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @param sha [String] The sha of the status
      # @param state [String] The state of the status. Can be one of error, failure, pending, or success.
      # @option options [String] :target_url The target URL to associate with this status. This URL will be linked from the GitHub UI to allow users to easily see the source of the status.  For example, if your continuous integration system is posting build status, you would want to provide the deep link for the build output for this specific SHA:  http://ci.example.com/user/repo/build/sha
      # @option options [String] :description A short description of the status.
      # @option options [String] :context A string label to differentiate this status from the status of other systems.
      # @return [Sawyer::Resource] The new status
      # @see https://developer.github.com/v3/repos/statuses/#create-a-commit-status
      def create_commit_status(repo, sha, state, options = {})
        opts = options.dup
        opts[:state] = state.to_s.downcase
        post "#{Repository.path repo}/statuses/#{sha}", opts
      end

      # Get the combined status for a specific reference
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @param ref [String] The ref of the status
      # @return [Sawyer::Resource] A single status
      # @see https://developer.github.com/v3/repos/statuses/#get-the-combined-status-for-a-specific-reference
      def ref_combined_status(repo, ref, options = {})
        get "#{Repository.path repo}/commits/#{ref}/status", options
      end

      # List commit statuses for a reference
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @param ref [String] The ref of the statuses
      # @return [Array<Sawyer::Resource>] A list of statuses
      # @see https://developer.github.com/v3/repos/statuses/#list-commit-statuses-for-a-reference
      def ref_commit_statuses(repo, ref, options = {})
        paginate "#{Repository.path repo}/commits/#{ref}/statuses", options
      end
    end
  end
end
