# frozen_string_literal: true

module Octokit
  class Client
    # Methods for the ProjectsCards API
    #
    # @see https://developer.github.com/v3/projects/cards/
    module ProjectsCards
      # Get a project card
      #
      # @param card_id [Integer] The ID of the card
      # @return [Sawyer::Resource] A single card
      # @see https://developer.github.com/v3/projects/cards/#get-a-project-card
      def project_card(card_id, options = {})
        opts = options.dup
        opts[:accept] = 'application/vnd.github.inertia-preview+json' if opts[:accept].nil?

        get "projects/columns/cards/#{card_id}", opts
      end

      # List project cards
      #
      # @param column_id [Integer] The ID of the column
      # @option options [String] :archived_state Filters the project cards that are returned by the card's state. Can be one of all,archived, or not_archived.
      # @return [Array<Sawyer::Resource>] A list of cards
      # @see https://developer.github.com/v3/projects/cards/#list-project-cards
      def project_cards(column_id, options = {})
        opts = options.dup
        opts[:accept] = 'application/vnd.github.inertia-preview+json' if opts[:accept].nil?

        paginate "projects/columns/#{column_id}/cards", opts
      end

      # Create a project card
      #
      # @param column_id [Integer] The ID of the column
      # @option options [String] :note The card's note content. Only valid for cards without another type of content, so you must omit when specifying content_id and content_type.
      # @option options [Integer] :content_id The ID of the content
      # @option options [String] :content_type Required if you provide content_id. The type of content you want to associate with this card. Use Issue when content_id is an issue id and use PullRequest when content_id is a pull request id.
      # @return [Sawyer::Resource] The new card
      # @see https://developer.github.com/v3/projects/cards/#create-a-project-card
      def create_project_card(column_id, options = {})
        opts = options.dup
        opts[:accept] = 'application/vnd.github.inertia-preview+json' if opts[:accept].nil?

        post "projects/columns/#{column_id}/cards", opts
      end

      # Update a project card
      #
      # @param card_id [Integer] The ID of the card
      # @option options [String] :note The card's note content. Only valid for cards without another type of content, so this cannot be specified if the card already has a content_id and content_type.
      # @option options [Boolean] :archived Use true to archive a project card. Specify false if you need to restore a previously archived project card.
      # @return [Sawyer::Resource] The updated card
      # @see https://developer.github.com/v3/projects/cards/#update-a-project-card
      def update_project_card(card_id, options = {})
        opts = options.dup
        opts[:accept] = 'application/vnd.github.inertia-preview+json' if opts[:accept].nil?

        patch "projects/columns/cards/#{card_id}", opts
      end

      # Delete a project card
      #
      # @param card_id [Integer] The ID of the card
      # @return [Boolean] True on success, false otherwise
      # @see https://developer.github.com/v3/projects/cards/#delete-a-project-card
      def delete_project_card(card_id, options = {})
        opts = options.dup
        opts[:accept] = 'application/vnd.github.inertia-preview+json' if opts[:accept].nil?

        boolean_from_response :delete, "projects/columns/cards/#{card_id}", opts
      end

      # Move a project card
      #
      # @param card_id [Integer] The ID of the card
      # @param position [String] Can be one of top, bottom, or after:<card_id>, where <card_id> is the id value of a card in the same column, or in the new column specified by column_id.
      # @option options [Integer] :column_id The ID of the column
      # @return [Boolean] True on success, false otherwise
      # @see https://developer.github.com/v3/projects/cards/#move-a-project-card
      def move_project_card(card_id, position, options = {})
        opts = options.dup
        opts[:position] = position
        opts[:accept] = 'application/vnd.github.inertia-preview+json' if opts[:accept].nil?

        boolean_from_response :post, "projects/columns/cards/#{card_id}/moves", opts
      end
    end
  end
end
