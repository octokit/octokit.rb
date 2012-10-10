module Octokit
  class Client
    module Gists

      # List gists for a user or all public gists
      #
      # @param username [String] An optional user to filter listing 
      # @return [Array<Hashie::Mash>] A list of gists
      # @example Fetch all gists for defunkt
      #   Octokit.gists('defunkt')
      # @example Fetch all public gists
      #   Octokit.gists
      # @see http://developer.github.com/v3/gists/#list-gists
      def gists(username=nil, options={})
        if username.nil?
          get 'gists', options, 3
        else
          get "users/#{username}/gists", options, 3
        end
      end
      alias :list_gists :gists

      # List public gists
      #
      # @return [Array<Hashie::Mash>] A list of gists
      # @example Fetch all public gists
      #   Octokit.public_gists
      # @see http://developer.github.com/v3/gists/#list-gists
      def public_gists(options={})
        get 'gists/public', options, 3
      end

      # List the authenticated user’s starred gists
      #
      # @return [Array<Hashie::Mash>] A list of gists
      def starred_gists(options={})
        get 'gists/starred', options, 3
      end

      # Get a single gist
      #
      # @param gist [String] ID of gist to fetch
      # @return [Hash::Mash] Gist information
      # @see http://developer.github.com/v3/gists/#get-a-single-gist
      def gist(gist, options={})
        get "gists/#{Gist.new gist}", options, 3
      end

      # Create a gist
      #
      # @param options [Hash] Gist information.
      # @option options [String] :description
      # @option options [Boolean] :public Sets gist visibility
      # @option options [Array<Hash>] :files Files that make up this gist. Keys
      #   should be the filename, the value a Hash with a :content key with text
      #   conent of the Gist.
      # @return [Hashie::Mash] Newly created gist info
      # @see http://developer.github.com/v3/gists/#create-a-gist
      def create_gist(options={})
        post 'gists', options, 3
      end

      # Edit a gist
      #
      # @param options [Hash] Gist information.
      # @option options [String] :description
      # @option options [Boolean] :public Sets gist visibility
      # @option options [Array<Hash>] :files Files that make up this gist. Keys
      #   should be the filename, the value a Hash with a :content key with text
      #   conent of the Gist. 
      #
      #   NOTE: All files from the previous version of the
      #   gist are carried over by default if not included in the hash. Deletes
      #   can be performed by including the filename with a null hash.  
      # @return
      #   [Hashie::Mash] Newly created gist info
      # @see http://developer.github.com/v3/gists/#edit-a-gist
      def edit_gist(gist, options={})
        patch "gists/#{Gist.new gist}", options, 3
      end
      #
      # Star a gist
      #
      # @param gist [String] Gist ID
      # @return [Boolean] Indicates if gist is starred successfully
      # @see http://developer.github.com/v3/gists/#star-a-gist
      def star_gist(gist, options={})
        response = put("gists/#{Gist.new gist}/star", options, 3, true, true)
        response.status == 204
      end

      # Unstar a gist
      #
      # @param gist [String] Gist ID
      # @return [Boolean] Indicates if gist is unstarred successfully
      # @see http://developer.github.com/v3/gists/#unstar-a-gist
      def unstar_gist(gist, options={})
        response = delete("gists/#{Gist.new gist}/star", options, 3, true, true)
        response.status == 204
      end

      # Check if a gist is starred
      #
      # @param gist [String] Gist ID
      # @return [Boolean] Indicates if gist is starred
      # @see http://developer.github.com/v3/gists/#check-if-a-gist-is-starred
      def gist_starred?(gist, options={})
        begin
          get("gists/#{Gist.new gist}/star", options, 3, true, true)
          return true
        rescue Octokit::NotFound
          return false
        end
      end

      # Fork a gist
      #
      # @param gist [String] Gist ID
      # @return [Hashie::Mash] Data for the new gist
      # @see http://developer.github.com/v3/gists/#fork-a-gist
      def fork_gist(gist, options={})
        post "gists/#{Gist.new gist}/fork", options, 3
      end

      # Delete a gist
      #
      # @param gist [String] Gist ID
      # @return [Boolean] Indicating success of deletion
      # @see http://developer.github.com/v3/gists/#delete-a-gist
      def delete_gist(gist, options={})
        response = delete("gists/#{Gist.new gist}", options, 3, true, true)
        response.status == 204
      end

    end
  end
end
