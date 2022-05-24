# frozen_string_literal: true

module Octokit
  class Client
    # Methods for the ProjectsColumns API
    #
    # @see https://developer.github.com/v3/projects/columns/
    module ProjectsColumns
      # Get a project column
      #
      # @param column_id [Integer] The ID of the column
      # @return [Sawyer::Resource] A single column
      # @see https://developer.github.com/v3/projects/columns/#get-a-project-column
      def project_column(column_id, options = {})
        opts = options.dup
        opts[:accept] = 'application/vnd.github.inertia-preview+json' if opts[:accept].nil?

        get "projects/columns/#{column_id}", opts
      end

      # List project columns
      #
      # @param project_id [Integer] The ID of the project
      # @return [Array<Sawyer::Resource>] A list of columns
      # @see https://developer.github.com/v3/projects/columns/#list-project-columns
      def project_columns(project_id, options = {})
        opts = options.dup
        opts[:accept] = 'application/vnd.github.inertia-preview+json' if opts[:accept].nil?

        paginate "projects/#{project_id}/columns", opts
      end

      # Create a project column
      #
      # @param project_id [Integer] The ID of the project
      # @param name [String] The name of the column.
      # @return [Sawyer::Resource] The new column
      # @see https://developer.github.com/v3/projects/columns/#create-a-project-column
      def create_project_column(project_id, name, options = {})
        opts = options.dup
        opts[:name] = name
        opts[:accept] = 'application/vnd.github.inertia-preview+json' if opts[:accept].nil?

        post "projects/#{project_id}/columns", opts
      end

      # Update a project column
      #
      # @param column_id [Integer] The ID of the column
      # @param name [String] The new name of the column.
      # @return [Sawyer::Resource] The updated column
      # @see https://developer.github.com/v3/projects/columns/#update-a-project-column
      def update_project_column(column_id, name, options = {})
        opts = options.dup
        opts[:name] = name
        opts[:accept] = 'application/vnd.github.inertia-preview+json' if opts[:accept].nil?

        patch "projects/columns/#{column_id}", opts
      end

      # Delete a project column
      #
      # @param column_id [Integer] The ID of the column
      # @return [Boolean] True on success, false otherwise
      # @see https://developer.github.com/v3/projects/columns/#delete-a-project-column
      def delete_project_column(column_id, options = {})
        opts = options.dup
        opts[:accept] = 'application/vnd.github.inertia-preview+json' if opts[:accept].nil?

        boolean_from_response :delete, "projects/columns/#{column_id}", opts
      end

      # Move a project column
      #
      # @param column_id [Integer] The ID of the column
      # @param position [String] Can be one of first, last, or after:<column_id>, where <column_id> is the id value of a column in the same project.
      # @return [Boolean] True on success, false otherwise
      # @see https://developer.github.com/v3/projects/columns/#move-a-project-column
      def move_project_column(column_id, position, options = {})
        opts = options.dup
        opts[:position] = position
        opts[:accept] = 'application/vnd.github.inertia-preview+json' if opts[:accept].nil?

        boolean_from_response :post, "projects/columns/#{column_id}/moves", opts
      end
    end
  end
end
