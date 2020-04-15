# frozen_string_literal: true

module Octokit
  class Client
    # Methods for the GistsComments API
    #
    # @see https://developer.github.com/v3/gists/comments/
    module GistsComments
      # Get a single comment
      #
      # @param gist_id [Integer, String] The ID of the gist
      # @param comment_id [Integer] The ID of the comment
      # @return [Sawyer::Resource] A single comment
      # @see https://developer.github.com/v3/gists/comments/#get-a-single-comment
      def gist_comment(gist_id, comment_id, options = {})
        get "gists/#{Gist.new gist_id}/comments/#{comment_id}", options
      end

      # List comments on a gist
      #
      # @param gist_id [Integer, String] The ID of the gist
      # @return [Array<Sawyer::Resource>] A list of comments
      # @see https://developer.github.com/v3/gists/comments/#list-comments-on-a-gist
      def gist_comments(gist_id, options = {})
        paginate "gists/#{Gist.new gist_id}/comments", options
      end

      # Create a comment
      #
      # @param gist_id [Integer, String] The ID of the gist
      # @param body [String] The comment text.
      # @return [Sawyer::Resource] The new comment
      # @see https://developer.github.com/v3/gists/comments/#create-a-comment
      def create_gist_comment(gist_id, body, options = {})
        opts = options.dup
        opts[:body] = body
        post "gists/#{Gist.new gist_id}/comments", opts
      end

      # Edit a comment
      #
      # @param gist_id [Integer, String] The ID of the gist
      # @param comment_id [Integer] The ID of the comment
      # @param body [String] The comment text.
      # @return [Sawyer::Resource] The updated comment
      # @see https://developer.github.com/v3/gists/comments/#edit-a-comment
      def update_gist_comment(gist_id, comment_id, body, options = {})
        opts = options.dup
        opts[:body] = body
        patch "gists/#{Gist.new gist_id}/comments/#{comment_id}", opts
      end

      # Delete a comment
      #
      # @param gist_id [Integer, String] The ID of the gist
      # @param comment_id [Integer] The ID of the comment
      # @return [Boolean] True on success, false otherwise
      # @see https://developer.github.com/v3/gists/comments/#delete-a-comment
      def delete_gist_comment(gist_id, comment_id, options = {})
        boolean_from_response :delete, "gists/#{Gist.new gist_id}/comments/#{comment_id}", options
      end
    end
  end
end
