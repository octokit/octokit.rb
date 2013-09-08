module Octokit
  class Client

    # Methods for the Gists API
    #
    # @see http://developer.github.com/v3/gists/
    module Gists

      # List gists for a user or all public gists
      #
      # @param username [String] An optional user to filter listing
      # @return [Array<Sawyer::Resource>] A list of gists
      # @example Fetch all gists for defunkt
      #   Octokit.gists('defunkt')
      # @example Fetch all public gists
      #   Octokit.gists
      # @see http://developer.github.com/v3/gists/#list-gists
      def gists(username=nil, options = {})
        if username.nil?
          paginate 'gists', options
        else
          paginate "users/#{username}/gists", options
        end
      end
      alias :list_gists :gists

      # List public gists
      #
      # @return [Array<Sawyer::Resource>] A list of gists
      # @example Fetch all public gists
      #   Octokit.public_gists
      # @see http://developer.github.com/v3/gists/#list-gists
      def public_gists(options = {})
        paginate 'gists/public', options
      end

      # List the authenticated user’s starred gists
      #
      # @return [Array<Sawyer::Resource>] A list of gists
      def starred_gists(options = {})
        paginate 'gists/starred', options
      end

      # Get a single gist
      #
      # @param gist [String] ID of gist to fetch
      # @return [Sawyer::Resource] Gist information
      # @see http://developer.github.com/v3/gists/#get-a-single-gist
      def gist(gist, options = {})
        get "gists/#{Gist.new gist}", options
      end

      # Create a gist
      #
      # @param options [Hash] Gist information.
      # @option options [String] :description
      # @option options [Boolean] :public Sets gist visibility
      # @option options [Array<Hash>] :files Files that make up this gist. Keys
      #   should be the filename, the value a Hash with a :content key with text
      #   content of the Gist.
      # @return [Sawyer::Resource] Newly created gist info
      # @see http://developer.github.com/v3/gists/#create-a-gist
      def create_gist(options = {})
        post 'gists', options
      end

      # Edit a gist
      #
      # @param options [Hash] Gist information.
      # @option options [String] :description
      # @option options [Boolean] :public Sets gist visibility
      # @option options [Hash] :files Files that make up this gist. Keys
      #   should be the filename, the value a Hash with a :content key with text
      #   content of the Gist.
      #
      #   NOTE: All files from the previous version of the
      #   gist are carried over by default if not included in the hash. Deletes
      #   can be performed by including the filename with a null hash.
      # @return
      #   [Sawyer::Resource] Newly created gist info
      # @see http://developer.github.com/v3/gists/#edit-a-gist
      # @example Update a gist
      #   @client.edit_gist('some_id', {
      #     :files => {"boo.md" => {"content" => "updated stuff"}}
      #   })
      def edit_gist(gist, options = {})
        patch "gists/#{Gist.new gist}", options
      end

      #
      # Star a gist
      #
      # @param gist [String] Gist ID
      # @return [Boolean] Indicates if gist is starred successfully
      # @see http://developer.github.com/v3/gists/#star-a-gist
      def star_gist(gist, options = {})
        boolean_from_response :put, "gists/#{Gist.new gist}/star", options
      end

      # Unstar a gist
      #
      # @param gist [String] Gist ID
      # @return [Boolean] Indicates if gist is unstarred successfully
      # @see http://developer.github.com/v3/gists/#unstar-a-gist
      def unstar_gist(gist, options = {})
        boolean_from_response :delete, "gists/#{Gist.new gist}/star", options
      end

      # Check if a gist is starred
      #
      # @param gist [String] Gist ID
      # @return [Boolean] Indicates if gist is starred
      # @see http://developer.github.com/v3/gists/#check-if-a-gist-is-starred
      def gist_starred?(gist, options = {})
        boolean_from_response :get, "gists/#{Gist.new gist}/star", options
      end

      # Fork a gist
      #
      # @param gist [String] Gist ID
      # @return [Sawyer::Resource] Data for the new gist
      # @see http://developer.github.com/v3/gists/#fork-a-gist
      def fork_gist(gist, options = {})
        post "gists/#{Gist.new gist}/forks", options
      end

      # Delete a gist
      #
      # @param gist [String] Gist ID
      # @return [Boolean] Indicating success of deletion
      # @see http://developer.github.com/v3/gists/#delete-a-gist
      def delete_gist(gist, options = {})
        boolean_from_response :delete, "gists/#{Gist.new gist}", options
      end

      # List gist comments
      #
      # @param gist_id [String] Gist Id.
      # @return [Array<Sawyer::Resource>] Array of hashes representing comments.
      # @see http://developer.github.com/v3/gists/comments/#list-comments-on-a-gist
      # @example
      #   Octokit.gist_comments('3528ae645')
      def gist_comments(gist_id, options = {})
        paginate "gists/#{gist_id}/comments", options
      end

      # Get gist comment
      #
      # @param gist_id [String] Id of the gist.
      # @param gist_comment_id [Integer] Id of the gist comment.
      # @return [Sawyer::Resource] Hash representing gist comment.
      # @see http://developer.github.com/v3/gists/comments/#get-a-single-comment
      # @example
      #   Octokit.gist_comment('208sdaz3', 1451398)
      def gist_comment(gist_id, gist_comment_id, options = {})
        get "gists/#{gist_id}/comments/#{gist_comment_id}", options
      end

      # Create gist comment
      #
      # Requires authenticated client.
      #
      # @param gist_id [String] Id of the gist.
      # @param comment [String] Comment contents.
      # @return [Sawyer::Resource] Hash representing the new comment.
      # @see http://developer.github.com/v3/gists/comments/#create-a-comment
      # @example
      #   @client.create_gist_comment('3528645', 'This is very helpful.')
      def create_gist_comment(gist_id, comment, options = {})
        options.merge!({:body => comment})
        post "gists/#{gist_id}/comments", options
      end

      # Update gist comment
      #
      # Requires authenticated client
      #
      # @param gist_id [String] Id of the gist.
      # @param gist_comment_id [Integer] Id of the gist comment to update.
      # @param comment [String] Updated comment contents.
      # @return [Sawyer::Resource] Hash representing the updated comment.
      # @see http://developer.github.com/v3/gists/comments/#edit-a-comment
      # @example
      #   @client.update_gist_comment('208sdaz3', '3528645', ':heart:')
      def update_gist_comment(gist_id, gist_comment_id, comment, options = {})
        options.merge!({:body => comment})
        patch "gists/#{gist_id}/comments/#{gist_comment_id}", options
      end

      # Delete gist comment
      #
      # Requires authenticated client.
      #
      # @param gist_id [String] Id of the gist.
      # @param gist_comment_id [Integer] Id of the gist comment to delete.
      # @return [Boolean] True if comment deleted, false otherwise.
      # @see http://developer.github.com/v3/gists/comments/#delete-a-comment
      # @example
      #   @client.delete_gist_comment('208sdaz3', '586399')
      def delete_gist_comment(gist_id, gist_comment_id, options = {})
        boolean_from_response(:delete, "gists/#{gist_id}/comments/#{gist_comment_id}", options)
      end
    end
  end
end
