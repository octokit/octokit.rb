module Octokit
  class Client

    # Methods for the the unpublished Emojis API
    module Emojis

      # List all emojis used on GitHub
      #
      # @return [Sawyer::Resource] A list of all emojis on GitHub
      # @example List all emojis
      #   Octokit.emojis
      def emojis(options = {})
        get "emojis", options
      end
    end
  end
end
