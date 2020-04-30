# frozen_string_literal: true

module Octokit
  class Client
    # Methods for the ReposCommits API
    #
    # @see https://developer.github.com/v3/repos/commits/
    module ReposCommits
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

      # Compare two commits
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @param base [String] The base of the commits
      # @param head [String] The head of the commits
      # @return [Sawyer::Resource] A single commits
      # @see https://developer.github.com/v3/repos/commits/#compare-two-commits
      def compare_commits(repo, base, head, options = {})
        get "#{Repository.path repo}/compare/#{base}...#{head}", options
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
    end
  end
end
