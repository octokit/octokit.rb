# frozen_string_literal: true

module Octokit
  class Client
    # Methods for the Readme API
    #
    # @see https://developer.github.com/v3/repos/contents/
    module Readme
      # Get the README
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @option options [String] :ref The name of the commit/branch/tag. Default: the repository’s default branch (usually master)
      # @return [Sawyer::Resource] A single readme
      # @see https://developer.github.com/v3/repos/contents/#get-the-readme
      def readme(repo, options = {})
        get "#{Repository.path repo}/readme", options
      end
    end
  end
end
