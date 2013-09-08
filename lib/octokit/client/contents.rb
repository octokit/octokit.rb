require 'base64'

module Octokit
  class Client

    # Methods for the Repo Contents API
    #
    # @see http://developer.github.com/v3/repos/contents/
    module Contents

      # Receive the default Readme for a repository
      #
      # @param repo [String, Repository, Hash] A GitHub repository
      # @option options [String] :ref name of the Commit/Branch/Tag. Defaults to “master”.
      # @return [Sawyer::Resource] The detail of the readme
      # @see http://developer.github.com/v3/repos/contents/
      # @example Get the readme file for a repo
      #   Octokit.readme("octokit/octokit.rb")
      def readme(repo, options={})
        get "repos/#{Repository.new repo}/readme", options
      end

      # Receive a listing of a repository folder or the contents of a file
      #
      # @param repo [String, Repository, Hash] A GitHub repository
      # @option options [String] :path A folder or file path
      # @option options [String] :ref name of the Commit/Branch/Tag. Defaults to “master”.
      # @return [Sawyer::Resource] The contents of a file or list of the files in the folder
      # @see http://developer.github.com/v3/repos/contents/
      # @example List the contents of lib/octokit.rb
      #   Octokit.contents("octokit/octokit.rb", :path => 'lib/octokit.rb')
      def contents(repo, options={})
        repo_path = options.delete :path
        url = "repos/#{Repository.new repo}/contents/#{repo_path}"
        get url, options
      end
      alias :content :contents

      # Add content to a repository
      #
      # @overload create_contents(repo, path, message, content = nil, options = {})
      #   @param repo [String, Repository, Hash] A GitHub repository
      #   @param path [String] A path for the new content
      #   @param message [String] A commit message for adding the content
      #   @param optional content [String] The Base64-encoded content for the file
      #   @option options [String] :branch The branch on which to add the content
      #   @option options [String] :file Path or Ruby File object for content
      # @return [Sawyer::Resource] The contents and commit info for the addition
      # @see http://developer.github.com/v3/repos/contents/#create-a-file
      # @example Add content at lib/octokit.rb
      #   Octokit.create_contents("octokit/octokit.rb",
      #                    "lib/octokit.rb",
      #                    "Adding content",
      #                    "asdf9as0df9asdf8as0d9f8==...",
      #                    :branch => "my-new-feature")
      def create_contents(*args)
        options = args.last.is_a?(Hash) ? args.pop : {}
        repo    = args.shift
        path    = args.shift
        message = args.shift
        content = args.shift
        if content.nil? && file = options.delete(:file)
          case file
          when String
            if File.exists?(file)
              file = File.open(file, "r")
              content = file.read
              file.close
            end
          when File
            content = file.read
            file.close
          end
        end
        raise ArgumentError.new "content or :file option required" if content.nil?
        options[:content] = Base64.encode64(content)
        options[:message] = message
        url = "repos/#{Repository.new repo}/contents/#{path}"
        put url, options
      end
      alias :create_content :create_contents
      alias :add_content :create_contents
      alias :add_contents :create_contents

      # Update content in a repository
      #
      # @overload update_contents(repo, path, message, sha, content = nil, options = {})
      #   @param repo [String, Repository, Hash] A GitHub repository
      #   @param path [String] A path for the content to update
      #   @param message [String] A commit message for updating the content
      #   @param sha [String] The _blob sha_ of the content to update
      #   @param content [String] The Base64-encoded content for the file
      #   @option options [String] :branch The branch on which to update the content
      #   @option options [String] :file Path or Ruby File object for content
      # @return [Sawyer::Resource] The contents and commit info for the update
      # @see http://developer.github.com/v3/repos/contents/#update-a-file
      # @example Update content at lib/octokit.rb
      #   Octokit.update_contents("octokit/octokit.rb",
      #                    "lib/octokit.rb",
      #                    "Updating content",
      #                    "7eb95f97e1a0636015df3837478d3f15184a5f49",
      #                    "asdf9as0df9asdf8as0d9f8==...",
      #                    :branch => "my-new-feature")
      def update_contents(*args)
        options = args.last.is_a?(Hash) ? args.pop : {}
        repo    = args.shift
        path    = args.shift
        message = args.shift
        sha     = args.shift
        content = args.shift
        options.merge!(:sha => sha)
        create_contents(repo, path, message, content, options)
      end
      alias :update_content :update_contents

      # Delete content in a repository
      #
      # @param repo [String, Repository, Hash] A GitHub repository
      # @param path [String] A path for the content to delete
      # @param message [String] A commit message for deleting the content
      # @param sha [String] The _blob sha_ of the content to delete
      # @option options [String] :branch The branch on which to delete the content
      # @return [Sawyer::Resource] The commit info for the delete
      # @see http://developer.github.com/v3/repos/contents/#delete-a-file
      # @example Delete content at lib/octokit.rb
      #   Octokit.delete_contents("octokit/octokit.rb",
      #                    "lib/octokit.rb",
      #                    "Deleting content",
      #                    "7eb95f97e1a0636015df3837478d3f15184a5f49",
      #                    :branch => "my-new-feature")
      def delete_contents(repo, path, message, sha, options = {})
        options[:message] = message
        options[:sha] = sha
        url = "repos/#{Repository.new repo}/contents/#{path}"
        delete url, options
      end
      alias :delete_content :delete_contents
      alias :remove_content :delete_contents
      alias :remove_contents :delete_contents

      # This method will provide a URL to download a tarball or zipball archive for a repository.
      #
      # @param repo [String, Repository, Hash] A GitHub repository.
      # @option options format [String] Either tarball (default) or zipball.
      # @option options [String] :ref Optional valid Git reference, defaults to master.
      # @return [String] Location of the download
      # @see http://developer.github.com/v3/repos/contents/
      # @example Get archive link for octokit/octokit.rb
      #   Octokit.archive_link("octokit/octokit.rb")
      def archive_link(repo, options={})
        repo_ref = options.delete :ref
        format = (options.delete :format) || 'tarball'
        url = "repos/#{Repository.new repo}/#{format}/#{repo_ref}"
        request :head, url, options

        last_response.headers['Location']
      end
    end
  end
end
