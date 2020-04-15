# frozen_string_literal: true

module Octokit
  class Client
    # Methods for the ReposDownloads API
    #
    # @see https://developer.github.com/v3/repos/downloads/
    module ReposDownloads
      # Get a single download
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @param download_id [Integer] The ID of the download
      # @return [Sawyer::Resource] A single download
      # @see https://developer.github.com/v3/repos/downloads/#get-a-single-download
      def download(repo, download_id, options = {})
        get "#{Repository.path repo}/downloads/#{download_id}", options
      end

      # List downloads for a repository
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @return [Array<Sawyer::Resource>] A list of downloads
      # @see https://developer.github.com/v3/repos/downloads/#list-downloads-for-a-repository
      def downloads(repo, options = {})
        paginate "#{Repository.path repo}/downloads", options
      end

      # Delete a download
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @param download_id [Integer] The ID of the download
      # @return [Boolean] True on success, false otherwise
      # @see https://developer.github.com/v3/repos/downloads/#delete-a-download
      def delete_download(repo, download_id, options = {})
        boolean_from_response :delete, "#{Repository.path repo}/downloads/#{download_id}", options
      end
    end
  end
end
