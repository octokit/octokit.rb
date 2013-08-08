module Octokit
  class Client

    # Methods for the Commit Statuses API
    #
    # @see http://developer.github.com/v3/repos/statuses/
    module Statuses

      # List all statuses for a given commit
      #
      # @param repo [String, Repository, Hash] A GitHub repository
      # @param sha [String] The SHA1 for the commit
      # @return [Array<Sawyer::Resource>] A list of statuses
      # @see http://developer.github.com/v3/repos/statuses
      def statuses(repo, sha, options = {})
        get "repos/#{Repository.new(repo)}/statuses/#{sha}", options
      end
      alias :list_statuses :statuses

      # Create status for a commit
      #
      # @param repo [String, Repository, Hash] A GitHub repository
      # @param sha [String] The SHA1 for the commit
      # @param state [String] The state: pending, success, failure, error
      # @return [Sawyer::Resource] A status
      # @see http://developer.github.com/v3/repos/statuses
      def create_status(repo, sha, state, options = {})
        options.merge!(:state => state)
        post "repos/#{Repository.new(repo)}/statuses/#{sha}", options
      end
    end
  end
end
