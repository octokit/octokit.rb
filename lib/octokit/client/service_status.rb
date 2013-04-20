module Octokit
  class Client
    module ServiceStatus

      STATUS_ROOT = 'https://status.github.com/api.json'

      # Returns the current system status
      #
      # @return [Hash] GitHub status
      # @see https://status.github.com/api#api-current-status
      def github_status
        get(STATUS_ROOT).rels[:status].get.data
      end

      # Returns the last human communication, status, and timestamp.
      #
      # @return [Hash] GitHub status last message
      # @see https://status.github.com/api#api-last-message
      def github_status_last_message
        get(STATUS_ROOT).rels[:last_message].get.data
      end

      # Returns the most recent human communications with status and timestamp.
      #
      # @return [Array<Hash>] GitHub status messages
      # @see https://status.github.com/api#api-recent-messages
      def github_status_messages
        get(STATUS_ROOT).rels[:messages].get.data
      end

    end
  end
end
