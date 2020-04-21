# frozen_string_literal: true

module Octokit
  class Client
    # Methods for the ReposContents API
    #
    # @see https://developer.github.com/v3/repos/contents/
    module ReposContents
      # Get the README
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @option options [String] :ref The name of the commit/branch/tag. Default: the repository’s default branch (usually master)
      # @return [Sawyer::Resource] A single readme
      # @see https://developer.github.com/v3/repos/contents/#get-the-readme
      def readme(repo, options = {})
        get "#{Repository.path repo}/readme", options
      end

      # Get contents
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @param path [String] The path of the contents
      # @option options [String] :ref The name of the commit/branch/tag. Default: the repository’s default branch (usually master)
      # @return [Sawyer::Resource] A single contents
      # @see https://developer.github.com/v3/repos/contents/#get-contents
      def contents(repo, path, options = {})
        get "#{Repository.path repo}/contents/#{path}", options
      end

      # Get archive link
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @param archive_format [String] The format of the archive
      # @param ref [String] The ref of the link
      # @return [Sawyer::Resource] A single link
      # @see https://developer.github.com/v3/repos/contents/#get-archive-link
      def archive_link(repo, archive_format, ref, options = {})
        get "#{Repository.path repo}/#{archive_format}/#{ref}", options
      end

      # Create or update a file
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @param path [String] The path of the or
      # @param message [String] The commit message.
      # @param content [String] The new file content, using Base64 encoding.
      # @option options [String] :sha Required if you are updating a file. The blob SHA of the file being replaced.
      # @option options [String] :branch The branch name. Default: the repository’s default branch (usually master)
      # @option options [Object] :committer The person that committed the file. Default: the authenticated user.
      # @option options [Object] :author The author of the file. Default: The committer or the authenticated user if you omit committer.
      # @return [Sawyer::Resource] The updated repo
      # @see https://developer.github.com/v3/repos/contents/#create-or-update-a-file
      def create_or_update_file(repo, path, message, content, options = {})
        opts = options.dup
        opts[:message] = message
        opts[:content] = Base64.strict_encode64(content)
        put "#{Repository.path repo}/contents/#{path}", opts
      end

      alias create_file create_or_update_file
      alias update_file create_or_update_file

      # Delete a file
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @param path [String] The path of the file
      # @param message [String] The commit message.
      # @param sha [String] The blob SHA of the file being replaced.
      # @option options [String] :branch The branch name. Default: the repository’s default branch (usually master)
      # @option options [Object] :committer object containing information about the committer.
      # @option options [Object] :author object containing information about the author.
      # @return [Sawyer::Resource] The updated repo
      # @see https://developer.github.com/v3/repos/contents/#delete-a-file
      def delete_file(repo, path, message, sha, options = {})
        opts = options.dup
        opts[:message] = message
        opts[:sha] = sha
        delete "#{Repository.path repo}/contents/#{path}", opts
      end
    end
  end
end
