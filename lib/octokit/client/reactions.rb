module Octokit
  class Client
    # Methods for the Reactions API
    #
    # @see https://developer.github.com/v3/reactions/
    module Reactions

      # Delete a reaction
      #
      # @param reaction_id [Integer] The ID of the reaction
      # @return [Boolean] True on success, false otherwise
      # @see https://developer.github.com/v3/reactions/#delete-a-reaction
      def delete_reaction(reaction_id, options = {})
        opts = options
        opts[:accept] = "application/vnd.github.squirrel-girl-preview+json" if opts[:accept].nil?

        boolean_from_response :delete, "reactions/#{reaction_id}", opts
      end
    end
  end
end
