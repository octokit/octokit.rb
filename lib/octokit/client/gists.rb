# frozen_string_literal: true

module Octokit
  class Client
    # Methods for the Gists API
    #
    # @see https://developer.github.com/v3/gists/
    module Gists
      # Get a gist
      #
      # @param gist_id [Integer, String] The ID of the gist
      # @return [Sawyer::Resource] A single gist
      # @see https://developer.github.com/v3/gists/#get-a-gist
      def gist(gist_id, options = {})
        get "gists/#{Gist.new gist_id}", options
      end

      # List gists for the authenticated user
      #
      # @option options [String] :since This is a timestamp in ISO 8601 (https://en.wikipedia.org/wiki/ISO_8601) format: YYYY-MM-DDTHH:MM:SSZ. Only gists updated at or after this time are returned.
      # @return [Array<Sawyer::Resource>] A list of gists
      # @see https://developer.github.com/v3/gists/#list-gists-for-the-authenticated-user
      def gists(options = {})
        paginate 'gists', options
      end

      # Create a gist
      #
      # @param files [Object] The filenames and content of each file in the gist. The keys in the files object represent the filename and have the type string.
      # @option options [String] :description A descriptive name for this gist.
      # @option options [Boolean] :public When true, the gist will be public and available for anyone to see.
      # @return [Sawyer::Resource] The new gist
      # @see https://developer.github.com/v3/gists/#create-a-gist
      def create_gist(files, options = {})
        opts = options.dup
        opts[:files] = files
        post 'gists', opts
      end

      # Update a gist
      #
      # @param gist_id [Integer, String] The ID of the gist
      # @option options [String] :description A descriptive name for this gist.
      # @option options [Object] :files The filenames and content that make up this gist.
      # @return [Sawyer::Resource] The updated gist
      # @see https://developer.github.com/v3/gists/#update-a-gist
      def update_gist(gist_id, options = {})
        patch "gists/#{Gist.new gist_id}", options
      end

      # Delete a gist
      #
      # @param gist_id [Integer, String] The ID of the gist
      # @return [Boolean] True on success, false otherwise
      # @see https://developer.github.com/v3/gists/#delete-a-gist
      def delete_gist(gist_id, options = {})
        boolean_from_response :delete, "gists/#{Gist.new gist_id}", options
      end

      # Get a gist revision
      #
      # @param gist_id [Integer, String] The ID of the gist
      # @param sha [String] The sha of the revision
      # @return [Sawyer::Resource] A single revision
      # @see https://developer.github.com/v3/gists/#get-a-gist-revision
      def gist_revision(gist_id, sha, options = {})
        get "gists/#{Gist.new gist_id}/#{sha}", options
      end

      # Check if a gist is starred
      #
      # @param gist_id [Integer, String] The ID of the gist
      # @return [Boolean] A single starred
      # @see https://developer.github.com/v3/gists/#check-if-a-gist-is-starred
      def gist_starred?(gist_id, options = {})
        boolean_from_response :get, "gists/#{Gist.new gist_id}/star", options
      end

      # List gist commits
      #
      # @param gist_id [Integer, String] The ID of the gist
      # @return [Array<Sawyer::Resource>] A list of commits
      # @see https://developer.github.com/v3/gists/#list-gist-commits
      def gist_commits(gist_id, options = {})
        paginate "gists/#{Gist.new gist_id}/commits", options
      end

      # List public gists
      #
      # @option options [String] :since This is a timestamp in ISO 8601 (https://en.wikipedia.org/wiki/ISO_8601) format: YYYY-MM-DDTHH:MM:SSZ. Only gists updated at or after this time are returned.
      # @return [Array<Sawyer::Resource>] A list of gists
      # @see https://developer.github.com/v3/gists/#list-public-gists
      def public_gists(options = {})
        paginate 'gists/public', options
      end

      # List starred gists
      #
      # @option options [String] :since This is a timestamp in ISO 8601 (https://en.wikipedia.org/wiki/ISO_8601) format: YYYY-MM-DDTHH:MM:SSZ. Only gists updated at or after this time are returned.
      # @return [Array<Sawyer::Resource>] A list of gists
      # @see https://developer.github.com/v3/gists/#list-starred-gists
      def starred_gists(options = {})
        paginate 'gists/starred', options
      end

      # List gist forks
      #
      # @param gist_id [Integer, String] The ID of the gist
      # @return [Array<Sawyer::Resource>] A list of forks
      # @see https://developer.github.com/v3/gists/#list-gist-forks
      def gist_forks(gist_id, options = {})
        paginate "gists/#{Gist.new gist_id}/forks", options
      end

      # Fork a gist
      #
      # @param gist_id [Integer, String] The ID of the gist
      # @return [Sawyer::Resource] The new gist
      # @see https://developer.github.com/v3/gists/#fork-a-gist
      def fork_gist(gist_id, options = {})
        post "gists/#{Gist.new gist_id}/forks", options
      end

      # Star a gist
      #
      # @param gist_id [Integer, String] The ID of the gist
      # @return [Boolean] True on success, false otherwise
      # @see https://developer.github.com/v3/gists/#star-a-gist
      def star_gist(gist_id, options = {})
        boolean_from_response :put, "gists/#{Gist.new gist_id}/star", options
      end

      # Unstar a gist
      #
      # @param gist_id [Integer, String] The ID of the gist
      # @return [Boolean] True on success, false otherwise
      # @see https://developer.github.com/v3/gists/#unstar-a-gist
      def unstar_gist(gist_id, options = {})
        boolean_from_response :delete, "gists/#{Gist.new gist_id}/star", options
      end

      # List gists for a user
      #
      # @param user [Integer, String] A GitHub user id or login
      # @option options [String] :since This is a timestamp in ISO 8601 (https://en.wikipedia.org/wiki/ISO_8601) format: YYYY-MM-DDTHH:MM:SSZ. Only gists updated at or after this time are returned.
      # @return [Array<Sawyer::Resource>] A list of gists
      # @see https://developer.github.com/v3/gists/#list-gists-for-a-user
      def user_gists(user, options = {})
        paginate "#{User.path user}/gists", options
      end
    end
  end
end
