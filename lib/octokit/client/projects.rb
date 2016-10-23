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

      # Create a project
      #
      # Requires authenticated client
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @param name [String] Project name
      # @option options [String] :body Body of the project
      # @return [Sawyer::Resource] Fresh new project
      # @see https://developer.github.com/v3/repos/projects/#create-a-project
      # @example Create project with only a name
      #   @client.create_project('octokit/octokit.rb', 'implement new APIs')
      #
      # @example Create project with name and body
      #   @client.create_project('octokit/octokit.rb', 'bugs be gone', body: 'Fix all the bugs @joeyw creates')
      def create_project(repo, name, options = {})
        opts = ensure_api_media_type(:projects, options)
        opts[:name] = name
        post "#{Repository.path repo}/projects", opts
      end

      # Get a project by number
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub Repository
      # @param number [Integer] The project number
      # @return [Sawyer::Resource] Project
      # @see https://developer.github.com/v3/repos/projects/#get-a-project
      # @example
      #   Octokit.project("octokit/octokit.rb", 1)
      def project(repo, number, options = {})
        opts = ensure_api_media_type(:projects, options)
        get "#{Repository.path repo}/projects/#{number}", opts
      end

      # Update a project
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @param number [Integer] Project number
      # @option options [String] :name Project name
      # @option options [String] :body Project body
      # @return [Sawyer::Resource] Project
      # @see https://developer.github.com/v3/repos/projects/#update-a-project
      # @example Update project name
      #   @client.update_project("octokit/octokit.rb", 1, name: 'New name')
      def update_project(repo, number, options = {})
        opts = ensure_api_media_type(:projects, options)
        patch "#{Repository.path repo}/projects/#{number}", opts
      end

    end # Projects
  end
end
