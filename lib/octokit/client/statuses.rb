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
        get("repos/#{Repository.new(repo)}/statuses/#{sha}", options)
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
        post("repos/#{Repository.new(repo)}/statuses/#{sha}", options)
      end

      # Returns the current system status
      #
      # @return [Hash] GitHub status
      # @see https://status.github.com/api#api-current-status
      def github_status
        get('status.json', {:endpoint => Octokit.status_api_endpoint})
      end

      # Returns the last human communication, status, and timestamp.
      #
      # @return [Hash] GitHub status last message
      # @see https://status.github.com/api#api-last-message
      def github_status_last_message
        get('last-message.json', {:endpoint => Octokit.status_api_endpoint})
      end

      # Returns the most recent human communications with status and timestamp.
      #
      # @return [Array<Hash>] GitHub status messages
      # @see https://status.github.com/api#api-recent-messages
      def github_status_messages
        get('messages.json', {:endpoint => Octokit.status_api_endpoint})
      end

    end
  end
end
