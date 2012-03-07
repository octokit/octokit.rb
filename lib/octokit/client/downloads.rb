module Octokit
  class Client
    module Downloads 

      # List available downloads for a repository
      #
      # @param repo [String, Repository, Hash] A Github Repository
      # @return [Array] A list of available downloads
      # @see http://developer.github.com/v3/repos/downloads/#list-downloads-for-a-repository
      # @example List all downloads for Github/Hubot
      #   Octokit.downloads("github/hubot")
      def downloads(repo, options={})
        get("repos/#{Repository.new(repo)}/downloads", options, 3)
      end

      # Get single download for a repository
      #
      # @param repo [String, Repository, Hash] A GitHub repository
      # @param id [Integer] ID of the download 
      # @return [Download] A single download from the repository
      # @see http://developer.github.com/v3/repos/downloads/#get-a-single-download
      # @example Get the "Robawt" download from Github/Hubot 
      #   Octokit.download("github/hubot")
      def download(repo, id, options={})
        get("repos/#{Repository.new(repo)}/downloads/#{id}", options, 3)
      end
    end
  end
end
