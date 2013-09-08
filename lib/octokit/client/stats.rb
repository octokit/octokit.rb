module Octokit
  class Client

    # Methods for the Repository Statistics API
    #
    # @see http://developer.github.com/v3/repos/statistics/
    module Stats

      # Get contributors list with additions, deletions, and commit counts
      #
      # @param repo [String, Hash, Repository] A GitHub repository
      # @return [Array<Sawyer::Resource>] Array of contributor stats
      # @see http://developer.github.com/v3/repos/statistics/#get-contributors-list-with-additions-deletions-and-commit-counts
      # @example Get contributor stats for octokit
      #   @client.contributors_stats('octokit/octokit.rb')
      def contributors_stats(repo, options = {})
        get_stats(repo, "contributors", options)
      end
      alias :contributor_stats :contributors_stats

      # Get the last year of commit activity data
      #
      # @param repo [String, Hash, Repository] A GitHub repository
      # @return [Array<Sawyer::Resource>] The last year of commit activity grouped by
      #   week. The days array is a group of commits per day, starting on Sunday.
      # @see http://developer.github.com/v3/repos/statistics/#get-the-last-year-of-commit-activity-data
      # @example Get commit activity for octokit
      #   @client.commit_activity_stats('octokit/octokit.rb')
      def commit_activity_stats(repo, options = {})
        get_stats(repo, "commit_activity", options)
      end

      # Get the number of additions and deletions per week
      #
      # @param repo [String, Hash, Repository] A GitHub repository
      # @return [Array<Sawyer::Resource>] Weekly aggregate of the number of additions
      #   and deletions pushed to a repository.
      # @see http://developer.github.com/v3/repos/statistics/#get-the-number-of-additions-and-deletions-per-week
      # @example Get code frequency stats for octokit
      #   @client.code_frequency_stats('octokit/octokit.rb')
      def code_frequency_stats(repo, options = {})
        get_stats(repo, "code_frequency", options)
      end

      # Get the weekly commit count for the repo owner and everyone else
      #
      # @param repo [String, Hash, Repository] A GitHub repository
      # @return [Sawyer::Resource] Total commit counts for the owner and total commit
      #   counts in all. all is everyone combined, including the owner in the last
      #   52 weeks. If you’d like to get the commit counts for non-owners, you can
      #   subtract all from owner.
      # @see http://developer.github.com/v3/repos/statistics/#get-the-weekly-commit-count-for-the-repo-owner-and-everyone-else
      # @example Get weekly commit counts for octokit
      #   @client.participation_stats("octokit/octokit.rb")
      def participation_stats(repo, options = {})
        get_stats(repo, "participation", options)
      end

      # Get the number of commits per hour in each day
      #
      # @param repo [String, Hash, Repository] A GitHub repository
      # @return [Array<Array>] Arrays containing the day number, hour number, and
      #   number of commits
      # @see http://developer.github.com/v3/repos/statistics/#get-the-number-of-commits-per-hour-in-each-day
      # @example Get octokit punch card
      #   @octokit.punch_card_stats
      def punch_card_stats(repo, options = {})
        get_stats(repo, "punch_card", options)
      end
      alias :punch_card :punch_card_stats

      private

      # @private Get stats for a repository
      #
      # @param repo [String, Hash, Repository] A GitHub repository
      # @param metric [String] The metrics you are looking for
      # @return [Array<Sawyer::Resource>] Magical unicorn stats
      def get_stats(repo, metric, options = {})
        data = get("repos/#{Repository.new repo}/stats/#{metric}", options)

        last_response.status == 202 ? nil : data
      end
    end
  end
end
