# frozen_string_literal: true

module Octokit
  class Client
    # Methods for the ReposStatistics API
    #
    # @see https://developer.github.com/v3/repos/statistics/
    module ReposStatistics
      # Get the weekly commit count for the repository owner and everyone else
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @return [Sawyer::Resource] A single stats
      # @see https://developer.github.com/v3/repos/statistics/#get-the-weekly-commit-count-for-the-repository-owner-and-everyone-else
      def participation_stats(repo, options = {})
        get "#{Repository.path repo}/stats/participation", options
      end

      # Get the number of additions and deletions per week
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @return [Array<Sawyer::Resource>] A list of stats
      # @see https://developer.github.com/v3/repos/statistics/#get-the-number-of-additions-and-deletions-per-week
      def code_frequency_stats(repo, options = {})
        get "#{Repository.path repo}/stats/code_frequency", options
      end

      # Get the last year of commit activity data
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @return [Array<Sawyer::Resource>] A list of stats
      # @see https://developer.github.com/v3/repos/statistics/#get-the-last-year-of-commit-activity-data
      def commit_activity_stats(repo, options = {})
        get "#{Repository.path repo}/stats/commit_activity", options
      end

      # Get contributors list with additions, deletions, and commit counts
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @return [Array<Sawyer::Resource>] A list of stats
      # @see https://developer.github.com/v3/repos/statistics/#get-contributors-list-with-additions-deletions-and-commit-counts
      def contributors_stats(repo, options = {})
        get "#{Repository.path repo}/stats/contributors", options
      end

      # Get the number of commits per hour in each day
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @return [Array<Sawyer::Resource>] A list of stats
      # @see https://developer.github.com/v3/repos/statistics/#get-the-number-of-commits-per-hour-in-each-day
      def punch_card_stats(repo, options = {})
        get "#{Repository.path repo}/stats/punch_card", options
      end
    end
  end
end
