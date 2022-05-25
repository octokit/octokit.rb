# frozen_string_literal: true

module Octokit
  class Client
    # Methods for the Pulls API
    #
    # @see https://developer.github.com/v3/pulls/
    module Pulls
      # List pull requests
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @option options [String] :state Either open, closed, or all to filter by state.
      # @option options [String] :head Filter pulls by head user or head organization and branch name in the format of user:ref-name or organization:ref-name. For example: github:new-script-format or octocat:test-branch.
      # @option options [String] :base Filter pulls by base branch name. Example: gh-pages.
      # @option options [String] :sort What to sort results by. Can be either created, updated, popularity (comment count) or long-running (age, filtering by pulls updated in the last month).
      # @option options [String] :direction The direction of the sort. Can be either asc or desc. Default: desc when sort is created or sort is not specified, otherwise asc.
      # @return [Array<Sawyer::Resource>] A list of pulls
      # @see https://developer.github.com/v3/pulls/#list-pull-requests
      def pulls(repo, options = {})
        paginate "#{Repository.path repo}/pulls", options
      end

      # Create a pull request
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @param title [String] The title of the new pull request.
      # @param head [String] The name of the branch where your changes are implemented. For cross-repository pull requests in the same network, namespace head with a user like this: username:branch.
      # @param base [String] The name of the branch you want the changes pulled into. This should be an existing branch on the current repository. You cannot submit a pull request to one repository that requests a merge to a base of another repository.
      # @option options [String] :body The contents of the pull request.
      # @option options [Boolean] :maintainer_can_modify Indicates whether maintainers can modify (https://help.github.com/articles/allowing-changes-to-a-pull-request-branch-created-from-a-fork/) the pull request.
      # @option options [Boolean] :draft Indicates whether the pull request is a draft. See "Draft Pull Requests (https://help.github.com/en/articles/about-pull-requests#draft-pull-requests)" in the GitHub Help documentation to learn more.
      # @return [Sawyer::Resource] The new pull
      # @see https://developer.github.com/v3/pulls/#create-a-pull-request
      def create_pull(repo, title, head, base, options = {})
        opts = options.dup
        opts[:title] = title
        opts[:head] = head
        opts[:base] = base
        post "#{Repository.path repo}/pulls", opts
      end

      # Get a pull request
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @param pull_number [Integer] The number of the pull
      # @return [Sawyer::Resource] A single pull
      # @see https://developer.github.com/v3/pulls/#get-a-pull-request
      def pull(repo, pull_number, options = {})
        get "#{Repository.path repo}/pulls/#{pull_number}", options
      end

      # Update a pull request
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @param pull_number [Integer] The number of the pull
      # @option options [String] :title The title of the pull request.
      # @option options [String] :body The contents of the pull request.
      # @option options [String] :state State of this Pull Request. Either open or closed.
      # @option options [String] :base The name of the branch you want your changes pulled into. This should be an existing branch on the current repository. You cannot update the base branch on a pull request to point to another repository.
      # @option options [Boolean] :maintainer_can_modify Indicates whether maintainers can modify (https://help.github.com/articles/allowing-changes-to-a-pull-request-branch-created-from-a-fork/) the pull request.
      # @return [Sawyer::Resource] The updated pull
      # @see https://developer.github.com/v3/pulls/#update-a-pull-request
      def update_pull(repo, pull_number, options = {})
        patch "#{Repository.path repo}/pulls/#{pull_number}", options
      end

      # Reopen a pull request
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @param pull_number [Integer] The number of the pull
      # @option options [String] :title The title of the pull request.
      # @option options [String] :body The contents of the pull request.
      # @option options [String] :base The name of the branch you want your changes pulled into. This should be an existing branch on the current repository. You cannot update the base branch on a pull request to point to another repository.
      # @option options [Boolean] :maintainer_can_modify Indicates whether maintainers can modify (https://help.github.com/articles/allowing-changes-to-a-pull-request-branch-created-from-a-fork/) the pull request.
      def reopen_pull(repo, pull_number, options = {})
        options[:state] = 'open'
        patch "#{Repository.path repo}/pulls/#{pull_number}", options
      end

      # Close a pull request
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @param pull_number [Integer] The number of the pull
      # @option options [String] :title The title of the pull request.
      # @option options [String] :body The contents of the pull request.
      # @option options [String] :base The name of the branch you want your changes pulled into. This should be an existing branch on the current repository. You cannot update the base branch on a pull request to point to another repository.
      # @option options [Boolean] :maintainer_can_modify Indicates whether maintainers can modify (https://help.github.com/articles/allowing-changes-to-a-pull-request-branch-created-from-a-fork/) the pull request.
      def close_pull(repo, pull_number, options = {})
        options[:state] = 'closed'
        patch "#{Repository.path repo}/pulls/#{pull_number}", options
      end

      # Check if a pull request has been merged
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @param pull_number [Integer] The number of the pull
      # @return [Boolean] A single merged
      # @see https://developer.github.com/v3/pulls/#check-if-a-pull-request-has-been-merged
      def pull_merged?(repo, pull_number, options = {})
        boolean_from_response :get, "#{Repository.path repo}/pulls/#{pull_number}/merge", options
      end

      # List commits on a pull request
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @param pull_number [Integer] The number of the pull
      # @return [Array<Sawyer::Resource>] A list of commits
      # @see https://developer.github.com/v3/pulls/#list-commits-on-a-pull-request
      def pull_commits(repo, pull_number, options = {})
        paginate "#{Repository.path repo}/pulls/#{pull_number}/commits", options
      end

      # List pull requests files
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @param pull_number [Integer] The number of the pull
      # @return [Array<Sawyer::Resource>] A list of files
      # @see https://developer.github.com/v3/pulls/#list-pull-requests-files
      def pull_files(repo, pull_number, options = {})
        paginate "#{Repository.path repo}/pulls/#{pull_number}/files", options
      end

      # Merge a pull request
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @param pull_number [Integer] The number of the pull
      # @option options [String] :commit_title Title for the automatic commit message.
      # @option options [String] :commit_message Extra detail to append to automatic commit message.
      # @option options [String] :sha SHA that pull request head must match to allow merge.
      # @option options [String] :merge_method Merge method to use. Possible values are merge, squash or rebase. Default is merge.
      # @return [Sawyer::Resource] The updated pull
      # @see https://developer.github.com/v3/pulls/#merge-a-pull-request
      def merge_pull(repo, pull_number, options = {})
        put "#{Repository.path repo}/pulls/#{pull_number}/merge", options
      end

      # Update a pull request branch
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @param pull_number [Integer] The number of the pull
      # @option options [String] :expected_head_sha The expected SHA of the pull request's HEAD ref. This is the most recent commit on the pull request's branch. If the expected SHA does not match the pull request's HEAD, you will receive a 422 Unprocessable Entity status. You can use the "List commits (https://developer.github.com/v3/repos/commits/#list-commits)" endpoint to find the most recent commit SHA. Default: SHA of the pull request's current HEAD ref.
      # @return [Sawyer::Resource] The updated pull
      # @see https://developer.github.com/v3/pulls/#update-a-pull-request-branch
      def update_pull_branch(repo, pull_number, options = {})
        opts = options.dup
        opts[:accept] = 'application/vnd.github.lydian-preview+json' if opts[:accept].nil?

        put "#{Repository.path repo}/pulls/#{pull_number}/update-branch", opts
      end
    end
  end
end
