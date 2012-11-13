module Octokit
  class Client
    module Statuses

      # List all statuses for a given commit
      #
      # @param repo [String, Repository, Hash] A GitHub repository
      # @param sha [String] The SHA1 for the commit
      # @return [Array] A list of statuses
      # @see http://developer.github.com/v3/repos/status
      def statuses(repo, sha, options={})
        options.merge! :uri => {:sha => sha} 
        repository(repo).rels[:statuses].get(options).data
      end
      alias :list_statuses :statuses

      # Create status for a commit
      #
      # @param repo [String, Repository, Hash] A GitHub repository
      # @param sha [String] The SHA1 for the commit
      # @param state [String] The state: pending, success, failure, error
      # @return [Hash] A status
      # @see http://developer.github.com/v3/repos/status
      def create_status(repo, sha, state, options={})
        options.merge!(:state => state)
        uri_options = {:uri => {:sha => sha}}
        repository(repo).rels[:statuses].post(options, uri_options).data
      end
    end
  end
end
