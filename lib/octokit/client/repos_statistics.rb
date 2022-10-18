# frozen_string_literal: true

module Octokit
  class Client
    # Methods for the ReposStatistics API
    #
    # @see https://developer.github.com/v3/repos/statistics/
    module ReposStatistics
      # Get the weekly commit count
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @return [Sawyer::Resource] A single stats
      # @see https://developer.github.com/v3/repos/statistics/#get-the-weekly-commit-count
      def participation_stats(repo, options = {})
        get "#{Repository.path repo}/stats/participation", options
      end

      # Get the weekly commit activity
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @return [Array<Sawyer::Resource>] A list of stats
      # @see https://developer.github.com/v3/repos/statistics/#get-the-weekly-commit-activity
      def code_frequency_stats(repo, options = {})
        get "#{Repository.path repo}/stats/code_frequency", options
      end

      # Get the last year of commit activity
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @return [Array<Sawyer::Resource>] A list of stats
      # @see https://developer.github.com/v3/repos/statistics/#get-the-last-year-of-commit-activity
      def commit_activity_stats(repo, options = {})
        get "#{Repository.path repo}/stats/commit_activity", options
      end

      # Get all contributor commit activity
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @return [Array<Sawyer::Resource>] A list of stats
      # @see https://developer.github.com/v3/repos/statistics/#get-all-contributor-commit-activity
      def contributors_stats(repo, options = {})
        get "#{Repository.path repo}/stats/contributors", options
      end

      # Get the hourly commit count for each day
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @return [Array<Sawyer::Resource>] A list of stats
      # @see https://developer.github.com/v3/repos/statistics/#get-the-hourly-commit-count-for-each-day
      def punch_card_stats(repo, options = {})
        get "#{Repository.path repo}/stats/punch_card", options
      end
    end
  end
end
