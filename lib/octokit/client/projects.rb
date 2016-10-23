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
      # Requires authenticated client
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

      # Delete a project
      #
      # Requires authenticated client
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @param number [Integer] Project number
      # @return [Boolean] Result of deletion
      # @see https://developer.github.com/v3/repos/projects/#delete-a-project
      # @example
      #   @client.delete_project("octokit/octokit.rb", 1)
      def delete_project(repo, number, options = {})
        opts = ensure_api_media_type(:projects, options)
        boolean_from_response :delete, "#{Repository.path repo}/projects/#{number}", opts
      end

      # Get project columns
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @param number [Integer] Project number
      # @return [Array<Sawyer::Resource>] List of project columns
      # @see https://developer.github.com/v3/repos/projects/#list-columns
      # @example
      #   @client.project_columns("octokit/octokit.rb", 1)
      def project_columns(repo, number, options = {})
        opts = ensure_api_media_type(:projects, options)
        paginate "#{Repository.path repo}/projects/#{number}/columns", opts
      end

      # Create a project column
      #
      # Requires authenticated client
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @param number [Integer] Project number
      # @param name [String] New column name
      # @return [Sawyer::Resource] Newly created column
      # @see https://developer.github.com/v3/repos/projects/#create-a-column
      # @example
      #   @client.create_project_column("octokit/octokit.rb", 1, "To Dones")
      def create_project_column(repo, number, name, options = {})
        opts = ensure_api_media_type(:projects, options)
        opts[:name] = name
        post "#{Repository.path repo}/projects/#{number}/columns", opts
      end

      # Get a project column by ID
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @param number [Integer] Project number
      # @param id [Integer] Column id
      # @return [Sawyer::Resource] Project column
      # @see https://developer.github.com/v3/repos/projects/#get-a-column
      # @example
      #   Octokit.project_column("octokit/octokit.rb", 1, 30)
      def project_column(repo, number, id, options = {})
        opts = ensure_api_media_type(:projects, options)
        get "#{Repository.path repo}/projects/#{number}/columns/#{id}", opts
      end

      # Update a project column
      #
      # Requires authenticated client
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @param number [Integer] Project number
      # @param id [Integer] Column ID
      # @param name [String] New column name
      # @return [Sawyer::Resource] Updated column
      # @see https://developer.github.com/v3/repos/projects/#update-a-column
      # @example
      #   @client.update_project_column("octokit/octokit.rb", 1, 30294, "new column name")
      def update_project_column(repo, number, id, name, options = {})
        opts = ensure_api_media_type(:projects, options)
        opts[:name] = name
        patch "#{Repository.path repo}/projects/#{number}/columns/#{id}", opts
      end

      # Delete a project column
      #
      # Requires authenticated client
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @param number [Integer] Project number
      # @param id [Integer] Project column id
      # @return [Boolean] Result of deletion request, true when deleted
      # @see https://developer.github.com/v3/repos/projects/#delete-a-column
      # @example
      #   @client.delete_project_column("octokit/octokit.rb", 1, 30294)
      def delete_project_column(repo, number, id, options = {})
        opts = ensure_api_media_type(:projects, options)
        boolean_from_response :delete, "#{Repository.path repo}/projects/#{number}/columns/#{id}", opts
      end

      # Move a project column
      #
      # Requires authenticated client
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @param number [Integer] Project number
      # @param id [Integer] Project column id
      # @param position [String] New position for the column. Can be one of 
      #   <tt>first</tt>, <tt>last</tt>, or <tt>after:<column-id></tt>, where
      #   <tt><column-id></tt> is the id value of a column in the same project.
      # @return [Boolean] Move result, true if successful
      # @see https://developer.github.com/v3/repos/projects/#move-a-column
      # @example
      #   @client.move_project_column("octokit/octokit.rb", 1, 3049, "last")
      def move_project_column(repo, number, id, position, options = {})
        opts = ensure_api_media_type(:projects, options)
        boolean_from_response :post, "#{Repository.path repo}/projects/#{number}/columns/#{id}/moves", opts
      end

      # Get the list of cards for a project column
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @param number [Integer] Project number
      # @param id [Integer] Project column id
      # @return [Array<Sawyer::Resource>] List of cards in the column
      # @see https://developer.github.com/v3/repos/projects/#list-projects-cards
      # @example
      #   @client.projects_cards("octokit/octokit.rb", 1, 39484)
      def projects_cards(repo, number, id, optons = {})
        opts = ensure_api_media_type(:projects, options)
        paginate "#{Repository.path repo}/projects/#{number}/columns/#{id}/cards", opts
      end

    end # Projects
  end
end
