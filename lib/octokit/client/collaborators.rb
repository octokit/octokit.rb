# frozen_string_literal: true

module Octokit
  class Client
    # Methods for the Collaborators API
    #
    # @see https://developer.github.com/v3/projects/collaborators/
    module Collaborators
      # List collaborators
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @option options [String] :affiliation Filter collaborators returned by their affiliation. Can be one of:   outside, direct, all
      # @return [Array<Sawyer::Resource>] A list of collaborators
      # @see https://developer.github.com/v3/repos/collaborators/#list-collaborators
      def collaborators(repo, options = {})
        paginate "#{Repository.path repo}/collaborators", options
      end

      # Check if a user is a collaborator
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @param username [String] The username of the collaborator
      # @return [Boolean] A single collaborator
      # @see https://developer.github.com/v3/repos/collaborators/#check-if-a-user-is-a-collaborator
      def collaborator?(repo, username, options = {})
        boolean_from_response :get, "#{Repository.path repo}/collaborators/#{username}", options
      end

      # Add user as a collaborator
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @param username [String] The username of the collaborator
      # @option options [String] :permission The permission to grant the collaborator. Only valid on organization-owned repositories. Can be one of:   pull - can pull, but not push to or administer this repository.  , push - can pull and push, but not administer this repository.  , admin - can pull, push and administer this repository.  , maintain - Recommended for project managers who need to manage the repository without access to sensitive or destructive actions.  , triage - Recommended for contributors who need to proactively manage issues and pull requests without write access.
      # @return [Sawyer::Resource] The updated repo
      # @see https://developer.github.com/v3/repos/collaborators/#add-user-as-a-collaborator
      def add_collaborator(repo, username, options = {})
        put "#{Repository.path repo}/collaborators/#{username}", options
      end

      # Remove user as a collaborator
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @param username [String] The username of the collaborator
      # @return [Boolean] True on success, false otherwise
      # @see https://developer.github.com/v3/repos/collaborators/#remove-user-as-a-collaborator
      def remove_collaborator(repo, username, options = {})
        boolean_from_response :delete, "#{Repository.path repo}/collaborators/#{username}", options
      end

      # Review a user's permission level
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @param username [String] The username of the collaborator
      # @return [Sawyer::Resource] A single level
      # @see https://developer.github.com/v3/repos/collaborators/#review-a-users-permission-level
      def collaborator_permission_level(repo, username, options = {})
        get "#{Repository.path repo}/collaborators/#{username}/permission", options
      end

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
