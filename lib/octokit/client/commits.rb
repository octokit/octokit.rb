# frozen_string_literal: true

module Octokit
  class Client
    # Methods for the Commits API
    #
    # @see https://developer.github.com/v3/repos/commits/
    module Commits
      # List commits on a repository
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @option options [String] :sha SHA or branch to start listing commits from. Default: the repository’s default branch (usually master).
      # @option options [String] :path Only commits containing this file path will be returned.
      # @option options [String] :author GitHub login or email address by which to filter by commit author.
      # @option options [String] :since Only commits after this date will be returned. This is a timestamp in ISO 8601 (https://en.wikipedia.org/wiki/ISO_8601) format: YYYY-MM-DDTHH:MM:SSZ.
      # @option options [String] :until Only commits before this date will be returned. This is a timestamp in ISO 8601 (https://en.wikipedia.org/wiki/ISO_8601) format: YYYY-MM-DDTHH:MM:SSZ.
      # @return [Array<Sawyer::Resource>] A list of commits
      # @see https://developer.github.com/v3/repos/commits/#list-commits-on-a-repository
      def commits(repo, options = {})
        paginate "#{Repository.path repo}/commits", options
      end

      # Get a single commit
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @param ref [String] The ref of the commit
      # @return [Sawyer::Resource] A single commit
      # @see https://developer.github.com/v3/repos/commits/#get-a-single-commit
      def commit(repo, ref, options = {})
        get "#{Repository.path repo}/commits/#{ref}", options
      end

      # Get the combined status for a specific ref
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @param ref [String] The ref of the ref
      # @return [Sawyer::Resource] A single status
      # @see https://developer.github.com/v3/repos/statuses/#get-the-combined-status-for-a-specific-ref
      def ref_combined_status(repo, ref, options = {})
        get "#{Repository.path repo}/commits/#{ref}/status", options
      end

      # List pull requests associated with commit
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @param commit_sha [String] The sha of the commit
      # @return [Array<Sawyer::Resource>] A list of requests
      # @see https://developer.github.com/v3/repos/commits/#list-pull-requests-associated-with-commit
      def commit_pull_requests(repo, commit_sha, options = {})
        opts = options.dup
        opts[:accept] = 'application/vnd.github.groot-preview+json' if opts[:accept].nil?

        paginate "#{Repository.path repo}/commits/#{commit_sha}/pulls", opts
      end

      # List branches for HEAD commit
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @param commit_sha [String] The sha of the commit
      # @return [Array<Sawyer::Resource>] A list of branches
      # @see https://developer.github.com/v3/repos/commits/#list-branches-for-head-commit
      def commit_branches(repo, commit_sha, options = {})
        opts = options.dup
        opts[:accept] = 'application/vnd.github.groot-preview+json' if opts[:accept].nil?

        get "#{Repository.path repo}/commits/#{commit_sha}/branches-where-head", opts
      end

      # List comments for a single commit
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @param commit_sha [String] The sha of the commit
      # @return [Array<Sawyer::Resource>] A list of comments
      # @see https://developer.github.com/v3/repos/comments/#list-comments-for-a-single-commit
      def commit_comments(repo, commit_sha, options = {})
        paginate "#{Repository.path repo}/commits/#{commit_sha}/comments", options
      end

      # List statuses for a specific ref
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @param ref [String] The ref of the statuses
      # @return [Array<Sawyer::Resource>] A list of statuses
      # @see https://developer.github.com/v3/repos/statuses/#list-statuses-for-a-specific-ref
      def ref_statuses(repo, ref, options = {})
        paginate "#{Repository.path repo}/commits/#{ref}/statuses", options
      end

      # Create a commit comment
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @param commit_sha [String] The sha of the commit
      # @param body [String] The contents of the comment.
      # @option options [String] :path Relative path of the file to comment on.
      # @option options [Integer] :position Line index in the diff to comment on.
      # @option options [Integer] :line Deprecated. Use position parameter instead. Line number in the file to comment on.
      # @return [Sawyer::Resource] The new comment
      # @see https://developer.github.com/v3/repos/comments/#create-a-commit-comment
      def create_commit_comment(repo, commit_sha, body, options = {})
        opts = options.dup
        opts[:body] = body
        post "#{Repository.path repo}/commits/#{commit_sha}/comments", opts
      end

      # List check suites for a Git reference
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @param ref [String] The ref of the suites
      # @option options [Integer] :app_id The ID of the app
      # @option options [String] :check_name Filters checks suites by the name of the check run (https://developer.github.com/v3/checks/runs/).
      # @return [Array<Sawyer::Resource>] A list of suites
      # @see https://developer.github.com/v3/checks/suites/#list-check-suites-for-a-git-reference
      def ref_suites(repo, ref, options = {})
        opts = options.dup
        opts[:accept] = 'application/vnd.github.antiope-preview+json' if opts[:accept].nil?

        paginate "#{Repository.path repo}/commits/#{ref}/check-suites", opts
      end

      # List check runs for a Git reference
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @param ref [String] The ref of the checks
      # @option options [String] :check_name Returns check runs with the specified name.
      # @option options [String] :status Returns check runs with the specified status. Can be one of queued, in_progress, or completed.
      # @option options [String] :filter Filters check runs by their completed_at timestamp. Can be one of latest (returning the most recent check runs) or all.
      # @return [Array<Sawyer::Resource>] A list of checks
      # @see https://developer.github.com/v3/checks/runs/#list-check-runs-for-a-git-reference
      def ref_checks(repo, ref, options = {})
        opts = options.dup
        opts[:accept] = 'application/vnd.github.antiope-preview+json' if opts[:accept].nil?

        paginate "#{Repository.path repo}/commits/#{ref}/check-runs", opts
      end
    end
  end
end
