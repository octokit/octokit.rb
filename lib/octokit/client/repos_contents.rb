# frozen_string_literal: true

module Octokit
  class Client
    # Methods for the ReposContents API
    #
    # @see https://developer.github.com/v3/repos/contents/
    module ReposContents
      # Get a repository README
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @option options [String] :ref The name of the commit/branch/tag. Default: the repository’s default branch (usually master)
      # @return [Sawyer::Resource] A single readme
      # @see https://developer.github.com/v3/repos/contents/#get-a-repository-readme
      def readme(repo, options = {})
        get "#{Repository.path repo}/readme", options
      end

      # Get repository content
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @param path [String] The path of the content
      # @option options [String] :ref The name of the commit/branch/tag. Default: the repository’s default branch (usually master)
      # @return [Sawyer::Resource] A single content
      # @see https://developer.github.com/v3/repos/contents/#get-repository-content
      def content(repo, path, options = {})
        get "#{Repository.path repo}/contents/#{path}", options
      end

      # Download a repository archive
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @param archive_format [String] The format of the archive
      # @param ref [String] The ref of the archive
      # @return [Sawyer::Resource] A single archive
      # @see https://developer.github.com/v3/repos/contents/#download-a-repository-archive
      def archive(repo, archive_format, ref, options = {})
        get "#{Repository.path repo}/#{archive_format}/#{ref}", options
      end

      # Create or update file contents
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @param path [String] The path of the contents
      # @param message [String] The commit message.
      # @param content [String] The new file content, using Base64 encoding.
      # @option options [String] :sha Required if you are updating a file. The blob SHA of the file being replaced.
      # @option options [String] :branch The branch name. Default: the repository’s default branch (usually master)
      # @option options [Object] :committer The person that committed the file. Default: the authenticated user.
      # @option options [Object] :author The author of the file. Default: The committer or the authenticated user if you omit committer.
      # @return [Sawyer::Resource] The updated repo
      # @see https://developer.github.com/v3/repos/contents/#create-or-update-file-contents
      def create_or_update_file_contents(repo, path, message, content, options = {})
        opts = options.dup
        opts[:message] = message
        opts[:content] = Base64.strict_encode64(content)
        put "#{Repository.path repo}/contents/#{path}", opts
      end

      alias create_contents create_or_update_file_contents
      alias update_contents create_or_update_file_contents

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
