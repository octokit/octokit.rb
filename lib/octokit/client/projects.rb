# frozen_string_literal: true

module Octokit
  class Client
    # Methods for the Projects API
    #
    # @see https://developer.github.com/v3/projects/
    module Projects
      # Get a project
      #
      # @param project_id [Integer] The ID of the project
      # @return [Sawyer::Resource] A single project
      # @see https://developer.github.com/v3/projects/#get-a-project
      def project(project_id, options = {})
        opts = options.dup
        opts[:accept] = 'application/vnd.github.inertia-preview+json' if opts[:accept].nil?

        get "projects/#{project_id}", opts
      end

      # Update a project
      #
      # @param project_id [Integer] The ID of the project
      # @option options [String] :name The name of the project.
      # @option options [String] :body The description of the project.
      # @option options [String] :state State of the project. Either open or closed.
      # @option options [String] :organization_permission The permission level that determines whether all members of the project's organization can see and/or make changes to the project. Setting organization_permission is only available for organization projects. If an organization member belongs to a team with a higher level of access or is a collaborator with a higher level of access, their permission level is not lowered by organization_permission. For information on changing access for a team or collaborator, see Add or update team project permissions (https://developer.github.com/v3/teams/#add-or-update-team-project-permissions) or Add project collaborator (https://developer.github.com/v3/projects/collaborators/#add-project-collaborator).  Note: Updating a project's organization_permission requires admin access to the project.  Can be one of:   read - Organization members can read, but not write to or administer this project.  , write - Organization members can read and write, but not administer this project.  , admin - Organization members can read, write and administer this project.  , none - Organization members can only see this project if it is public.
      # @option options [Boolean] :private Sets the visibility of a project board. Setting private is only available for organization and user projects. Note: Updating a project's visibility requires admin access to the project.  Can be one of:   false - Anyone can see the project.  , true - Only the user can view a project board created on a user account. Organization members with the appropriate organization_permission can see project boards in an organization account.
      # @return [Sawyer::Resource] The updated project
      # @see https://developer.github.com/v3/projects/#update-a-project
      def update_project(project_id, options = {})
        opts = options.dup
        opts[:accept] = 'application/vnd.github.inertia-preview+json' if opts[:accept].nil?

        patch "projects/#{project_id}", opts
      end

      # Reopen a project
      #
      # @param project_id [Integer] The ID of the project
      # @option options [String] :name The name of the project.
      # @option options [String] :body The description of the project.
      # @option options [String] :organization_permission The permission level that determines whether all members of the project's organization can see and/or make changes to the project. Setting organization_permission is only available for organization projects. If an organization member belongs to a team with a higher level of access or is a collaborator with a higher level of access, their permission level is not lowered by organization_permission. For information on changing access for a team or collaborator, see Add or update team project permissions (https://developer.github.com/v3/teams/#add-or-update-team-project-permissions) or Add project collaborator (https://developer.github.com/v3/projects/collaborators/#add-project-collaborator).  Note: Updating a project's organization_permission requires admin access to the project.  Can be one of:   read - Organization members can read, but not write to or administer this project.  , write - Organization members can read and write, but not administer this project.  , admin - Organization members can read, write and administer this project.  , none - Organization members can only see this project if it is public.
      # @option options [Boolean] :private Sets the visibility of a project board. Setting private is only available for organization and user projects. Note: Updating a project's visibility requires admin access to the project.  Can be one of:   false - Anyone can see the project.  , true - Only the user can view a project board created on a user account. Organization members with the appropriate organization_permission can see project boards in an organization account.
      def reopen_project(project_id, options = {})
        options[:state] = 'open'
        opts = options.dup
        opts[:accept] = 'application/vnd.github.inertia-preview+json' if opts[:accept].nil?

        patch "projects/#{project_id}", opts
      end

      # Close a project
      #
      # @param project_id [Integer] The ID of the project
      # @option options [String] :name The name of the project.
      # @option options [String] :body The description of the project.
      # @option options [String] :organization_permission The permission level that determines whether all members of the project's organization can see and/or make changes to the project. Setting organization_permission is only available for organization projects. If an organization member belongs to a team with a higher level of access or is a collaborator with a higher level of access, their permission level is not lowered by organization_permission. For information on changing access for a team or collaborator, see Add or update team project permissions (https://developer.github.com/v3/teams/#add-or-update-team-project-permissions) or Add project collaborator (https://developer.github.com/v3/projects/collaborators/#add-project-collaborator).  Note: Updating a project's organization_permission requires admin access to the project.  Can be one of:   read - Organization members can read, but not write to or administer this project.  , write - Organization members can read and write, but not administer this project.  , admin - Organization members can read, write and administer this project.  , none - Organization members can only see this project if it is public.
      # @option options [Boolean] :private Sets the visibility of a project board. Setting private is only available for organization and user projects. Note: Updating a project's visibility requires admin access to the project.  Can be one of:   false - Anyone can see the project.  , true - Only the user can view a project board created on a user account. Organization members with the appropriate organization_permission can see project boards in an organization account.
      def close_project(project_id, options = {})
        options[:state] = 'closed'
        opts = options.dup
        opts[:accept] = 'application/vnd.github.inertia-preview+json' if opts[:accept].nil?

        patch "projects/#{project_id}", opts
      end

      # Delete a project
      #
      # @param project_id [Integer] The ID of the project
      # @return [Sawyer::Resource] The updated project
      # @see https://developer.github.com/v3/projects/#delete-a-project
      def delete_project(project_id, options = {})
        opts = options.dup
        opts[:accept] = 'application/vnd.github.inertia-preview+json' if opts[:accept].nil?

        delete "projects/#{project_id}", opts
      end

      # Create a user project
      #
      # @param name [String] The name of the project.
      # @option options [String] :body The description of the project.
      # @return [Sawyer::Resource] The new project
      # @see https://developer.github.com/v3/projects/#create-a-user-project
      def create_user_project(name, options = {})
        opts = options.dup
        opts[:name] = name
        opts[:accept] = 'application/vnd.github.inertia-preview+json' if opts[:accept].nil?

        post 'user/projects', opts
      end

      # List user projects
      #
      # @param user [Integer, String] A GitHub user id or login
      # @option options [String] :state Indicates the state of the projects to return. Can be either open, closed, or all.
      # @return [Array<Sawyer::Resource>] A list of projects
      # @see https://developer.github.com/v3/projects/#list-user-projects
      def user_projects(user, options = {})
        opts = options.dup
        opts[:accept] = 'application/vnd.github.inertia-preview+json' if opts[:accept].nil?

        paginate "#{User.path user}/projects", opts
      end

      # List organization projects
      #
      # @param org [Integer, String] A GitHub organization id or login
      # @option options [String] :state Indicates the state of the projects to return. Can be either open, closed, or all.
      # @return [Array<Sawyer::Resource>] A list of projects
      # @see https://developer.github.com/v3/projects/#list-organization-projects
      def org_projects(org, options = {})
        opts = options.dup
        opts[:accept] = 'application/vnd.github.inertia-preview+json' if opts[:accept].nil?

        paginate "#{Organization.path org}/projects", opts
      end

      # Create an organization project
      #
      # @param org [Integer, String] A GitHub organization id or login
      # @param name [String] The name of the project.
      # @option options [String] :body The description of the project.
      # @return [Sawyer::Resource] The new project
      # @see https://developer.github.com/v3/projects/#create-an-organization-project
      def create_org_project(org, name, options = {})
        opts = options.dup
        opts[:name] = name
        opts[:accept] = 'application/vnd.github.inertia-preview+json' if opts[:accept].nil?

        post "#{Organization.path org}/projects", opts
      end

      # List repository projects
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @option options [String] :state Indicates the state of the projects to return. Can be either open, closed, or all.
      # @return [Array<Sawyer::Resource>] A list of projects
      # @see https://developer.github.com/v3/projects/#list-repository-projects
      def repo_projects(repo, options = {})
        opts = options.dup
        opts[:accept] = 'application/vnd.github.inertia-preview+json' if opts[:accept].nil?

        paginate "#{Repository.path repo}/projects", opts
      end

      # Create a repository project
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @param name [String] The name of the project.
      # @option options [String] :body The description of the project.
      # @return [Sawyer::Resource] The new project
      # @see https://developer.github.com/v3/projects/#create-a-repository-project
      def create_repo_project(repo, name, options = {})
        opts = options.dup
        opts[:name] = name
        opts[:accept] = 'application/vnd.github.inertia-preview+json' if opts[:accept].nil?

        post "#{Repository.path repo}/projects", opts
      end
    end
  end
end
