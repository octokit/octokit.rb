# frozen_string_literal: true

module Octokit
  class Client
    # Methods for the Reactions API
    #
    # @see https://developer.github.com/v3/reactions/
    module Reactions
      # Delete a reaction (Legacy)
      #
      # @param reaction_id [Integer] The ID of the reaction
      # @return [Boolean] True on success, false otherwise
      # @see https://developer.github.com/v3/reactions/#delete-a-reaction-legacy
      def delete_reaction_legacy(reaction_id, options = {})
        opts = options.dup
        opts[:accept] = 'application/vnd.github.squirrel-girl-preview+json' if opts[:accept].nil?

        boolean_from_response :delete, "reactions/#{reaction_id}", opts
      end
    end
  end
end
