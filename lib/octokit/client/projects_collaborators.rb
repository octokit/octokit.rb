# frozen_string_literal: true

module Octokit
  class Client
    # Methods for the ProjectsCollaborators API
    #
    # @see https://developer.github.com/v3/projects/collaborators/
    module ProjectsCollaborators
      # List collaborators
      #
      # @param project_id [Integer] The ID of the project
      # @option options [String] :affiliation Filters the collaborators by their affiliation. Can be one of:   outside, direct, all
      # @return [Array<Sawyer::Resource>] A list of collaborators
      # @see https://developer.github.com/v3/projects/collaborators/#list-collaborators
      def project_collaborators(project_id, options = {})
        opts = options.dup
        opts[:accept] = 'application/vnd.github.inertia-preview+json' if opts[:accept].nil?

        paginate "projects/#{project_id}/collaborators", opts
      end

      # Add user as a collaborator
      #
      # @param project_id [Integer] The ID of the project
      # @param username [String] The username of the collaborator
      # @option options [String] :permission The permission to grant the collaborator. Note that, if you choose not to pass any parameters, you'll need to set Content-Length to zero when calling out to this endpoint. For more information, see "HTTP verbs (https://developer.github.com/v3/#http-verbs)." Can be one of:   read - can read, but not write to or administer this project.  , write - can read and write, but not administer this project.  , admin - can read, write and administer this project.
      # @return [Boolean] True on success, false otherwise
      # @see https://developer.github.com/v3/projects/collaborators/#add-user-as-a-collaborator
      def add_project_collaborator(project_id, username, options = {})
        opts = options.dup
        opts[:accept] = 'application/vnd.github.inertia-preview+json' if opts[:accept].nil?

        boolean_from_response :put, "projects/#{project_id}/collaborators/#{username}", opts
      end

      # Remove user as a collaborator
      #
      # @param project_id [Integer] The ID of the project
      # @param username [String] The username of the collaborator
      # @return [Boolean] True on success, false otherwise
      # @see https://developer.github.com/v3/projects/collaborators/#remove-user-as-a-collaborator
      def remove_project_collaborator(project_id, username, options = {})
        opts = options.dup
        opts[:accept] = 'application/vnd.github.inertia-preview+json' if opts[:accept].nil?

        boolean_from_response :delete, "projects/#{project_id}/collaborators/#{username}", opts
      end

      # Review a user's permission level
      #
      # @param project_id [Integer] The ID of the project
      # @param username [String] The username of the user
      # @return [Sawyer::Resource] A single level
      # @see https://developer.github.com/v3/projects/collaborators/#review-a-users-permission-level
      def user_permission_level(project_id, username, options = {})
        opts = options.dup
        opts[:accept] = 'application/vnd.github.inertia-preview+json' if opts[:accept].nil?

        get "projects/#{project_id}/collaborators/#{username}/permission", opts
      end
    end
  end
end
