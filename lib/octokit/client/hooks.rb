module Octokit
  class Client

    # Methods for the Hooks API
    module Hooks

      # List all Service Hooks supported by GitHub
      #
      # @return [Sawyer::Resource] A list of all hooks on GitHub
      # @see https://developer.github.com/v3/repos/hooks/#services
      # @example List all hooks
      #   Octokit.available_hooks
      def available_hooks(options = {})
        get "hooks", options
      end
    end
  end
end
