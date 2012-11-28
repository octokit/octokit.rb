module Octokit
  class Client
    module Emojis
      # List all emojis used on GitHub
      #
      # @return [Hash] A list of all emojis on GitHub
      # @example List all emojis
      #   Octokit.emojis
      def emojis
        get "emojis"
      end
    end
  end
end
