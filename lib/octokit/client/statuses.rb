module Octokit
  class Client

    # Methods for the Commit Statuses API
    #
    # @see http://developer.github.com/v3/repos/statuses/
    module Statuses
      COMBINED_STATUS_MEDIA_TYPE = "application/vnd.github.she-hulk-preview+json"

      # List all statuses for a given commit
      #
      # @param repo [String, Repository, Hash] A GitHub repository
      # @param sha [String] The SHA1 for the commit
      # @return [Array<Sawyer::Resource>] A list of statuses
      # @see http://developer.github.com/v3/repos/statuses/#list-statuses-for-a-specific-ref
      def statuses(repo, sha, options = {})
        get "repos/#{Repository.new(repo)}/statuses/#{sha}", options
      end
      alias :list_statuses :statuses

      # Get the combined status for a ref
      #
      # @param repo [String, Repository, Hash] a GitHub repository
      # @param ref  [String] A Sha or Ref to fetch the status of
      # @return [Sawyer::Resource] The combined status for the commit
      # @see https://developer.github.com/v3/repos/statuses/#get-the-combined-status-for-a-specific-ref
      def combined_status(repo, sha, options = {})
        get "repos/#{Repository.new(repo)}/commits/#{sha}/status", options.merge(:accept => COMBINED_STATUS_MEDIA_TYPE)
      end
      alias :status, :combined_status

      # Create status for a commit
      #
      # @param repo [String, Repository, Hash] A GitHub repository
      # @param sha [String] The SHA1 for the commit
      # @param state [String] The state: pending, success, failure, error
      # @param context [String] A context to differentiate this status from others
      #
      # @return [Sawyer::Resource] A status
      # @see http://developer.github.com/v3/repos/statuses/#create-a-status
      def create_status(repo, sha, state, options = {})
        options.merge!(:state => state)
        post "repos/#{Repository.new(repo)}/statuses/#{sha}", options
      end
    end
  end
end
