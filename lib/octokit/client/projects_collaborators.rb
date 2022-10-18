# frozen_string_literal: true

module Octokit
  class Client
    # Methods for the ProjectsCollaborators API
    #
    # @see https://developer.github.com/v3/projects/collaborators/
    module ProjectsCollaborators
      # List project collaborators
      #
      # @param project_id [Integer] The ID of the project
      # @option options [String] :affiliation Filters the collaborators by their affiliation. Can be one of:   outside, direct, all
      # @return [Array<Sawyer::Resource>] A list of collaborators
      # @see https://developer.github.com/v3/projects/collaborators/#list-project-collaborators
      def project_collaborators(project_id, options = {})
        opts = options.dup
        opts[:accept] = 'application/vnd.github.inertia-preview+json' if opts[:accept].nil?

        paginate "projects/#{project_id}/collaborators", opts
      end

      # Add project collaborator
      #
      # @param project_id [Integer] The ID of the project
      # @param username [String] The username of the collaborator
      # @option options [String] :permission The permission to grant the collaborator. Note that, if you choose not to pass any parameters, you'll need to set Content-Length to zero when calling out to this endpoint. For more information, see "HTTP verbs (https://developer.github.com/v3/#http-verbs)." Can be one of:   read - can read, but not write to or administer this project.  , write - can read and write, but not administer this project.  , admin - can read, write and administer this project.
      # @return [Boolean] True on success, false otherwise
      # @see https://developer.github.com/v3/projects/collaborators/#add-project-collaborator
      def add_project_collaborator(project_id, username, options = {})
        opts = options.dup
        opts[:accept] = 'application/vnd.github.inertia-preview+json' if opts[:accept].nil?

        boolean_from_response :put, "projects/#{project_id}/collaborators/#{username}", opts
      end

      # Remove project collaborator
      #
      # @param project_id [Integer] The ID of the project
      # @param username [String] The username of the collaborator
      # @return [Boolean] True on success, false otherwise
      # @see https://developer.github.com/v3/projects/collaborators/#remove-project-collaborator
      def remove_project_collaborator(project_id, username, options = {})
        opts = options.dup
        opts[:accept] = 'application/vnd.github.inertia-preview+json' if opts[:accept].nil?

        boolean_from_response :delete, "projects/#{project_id}/collaborators/#{username}", opts
      end

      # Get project permission for a user
      #
      # @param project_id [Integer] The ID of the project
      # @param username [String] The username of the permission
      # @return [Sawyer::Resource] A single permission
      # @see https://developer.github.com/v3/projects/collaborators/#get-project-permission-for-a-user
      def user_permission(project_id, username, options = {})
        opts = options.dup
        opts[:accept] = 'application/vnd.github.inertia-preview+json' if opts[:accept].nil?

        get "projects/#{project_id}/collaborators/#{username}/permission", opts
      end
    end
  end
end
