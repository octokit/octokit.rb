module Octokit
  class Client

    # Methods for Projects API
    #
    # @see https://developer.github.com/v3/repos/projects/#projects
    module Projects

      # List projects for a repository
      #
      # Requires authenticated client
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @return [Array<Sawyer::Resource>] Repository projects
      # @see https://developer.github.com/v3/repos/projects/#list-projects
      # @example
      #   @client.projects('octokit/octokit.rb')
      def projects(repo, options = {})
        opts = ensure_api_media_type(:projects, options)
        paginate "#{Repository.path repo}/projects", opts
      end

    end # Projects
  end
end
