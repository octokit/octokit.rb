module Octokit
  class Client
    # Methods for the Projects API
    #
    # @see https://developer.github.com/v3/projects/
    module Projects

      # Get a project
      #
      # @param project_id [Integer] The ID of the project
      # @return [Sawyer::Resource] A list of projects
      # @see https://developer.github.com/v3/projects/#get-a-project
      def project(project_id, options = {})
        opts = ensure_api_media_type(:projects, options)
        paginate "projects/#{project_id}", opts
      end

      # Update a project
      #
      # @param project_id [Integer] The ID of the project
      # @option options [String] :name The name of the project.
      # @option options [String] :body The description of the project.
      # @option options [String] :state State of the project. Either `open` or `closed`.
      # @option options [String] :organization_permission The permission level that determines whether all members of the project's organization can see and/or make changes to the project. Setting `organization_permission` is only available for organization projects. If an organization member belongs to a team with a higher level of access or is a collaborator with a higher level of access, their permission level is not lowered by `organization_permission`. For information on changing access for a team or collaborator, see [Add or update team project](https://developer.github.com/v3/teams/#add-or-update-team-project) or [Add user as a collaborator](https://developer.github.com/v3/projects/collaborators/#add-user-as-a-collaborator).    **Note:** Updating a project's `organization_permission` requires `admin` access to the project.    Can be one of:  read, write, admin, none
      # @option options [Boolean] :private Sets the visibility of a project board. Setting `private` is only available for organization and user projects. **Note:** Updating a project's visibility requires `admin` access to the project.    Can be one of:  false, true
      # @return [Sawyer::Resource] The updated project
      # @see https://developer.github.com/v3/projects/#update-a-project
      def update_project(project_id, options = {})
        opts = ensure_api_media_type(:projects, options)
        patch "projects/#{project_id}", opts
      end

     # Open an project
     #
     # @param project_id [Integer] The ID of the project
     # @option options [String] :name The name of the project.
     # @option options [String] :body The description of the project.
     # @option options [String] :organization_permission The permission level that determines whether all members of the project's organization can see and/or make changes to the project. Setting `organization_permission` is only available for organization projects. If an organization member belongs to a team with a higher level of access or is a collaborator with a higher level of access, their permission level is not lowered by `organization_permission`. For information on changing access for a team or collaborator, see [Add or update team project](https://developer.github.com/v3/teams/#add-or-update-team-project) or [Add user as a collaborator](https://developer.github.com/v3/projects/collaborators/#add-user-as-a-collaborator).    **Note:** Updating a project's `organization_permission` requires `admin` access to the project.    Can be one of:  read, write, admin, none
     # @option options [Boolean] :private Sets the visibility of a project board. Setting `private` is only available for organization and user projects. **Note:** Updating a project's visibility requires `admin` access to the project.    Can be one of:  false, true
     def open_project(project_id, options = {})
        options[:state] = "open"
        opts = ensure_api_media_type(:projects, options)
        patch "projects/#{project_id}", opts
      end

     # Close an project
     #
     # @param project_id [Integer] The ID of the project
     # @option options [String] :name The name of the project.
     # @option options [String] :body The description of the project.
     # @option options [String] :organization_permission The permission level that determines whether all members of the project's organization can see and/or make changes to the project. Setting `organization_permission` is only available for organization projects. If an organization member belongs to a team with a higher level of access or is a collaborator with a higher level of access, their permission level is not lowered by `organization_permission`. For information on changing access for a team or collaborator, see [Add or update team project](https://developer.github.com/v3/teams/#add-or-update-team-project) or [Add user as a collaborator](https://developer.github.com/v3/projects/collaborators/#add-user-as-a-collaborator).    **Note:** Updating a project's `organization_permission` requires `admin` access to the project.    Can be one of:  read, write, admin, none
     # @option options [Boolean] :private Sets the visibility of a project board. Setting `private` is only available for organization and user projects. **Note:** Updating a project's visibility requires `admin` access to the project.    Can be one of:  false, true
     def close_project(project_id, options = {})
        options[:state] = "closed"
        opts = ensure_api_media_type(:projects, options)
        patch "projects/#{project_id}", opts
      end

      # Delete a project
      #
      # @param project_id [Integer] The ID of the project
      # @return [Sawyer::Resource] The updated project
      # @see https://developer.github.com/v3/projects/#delete-a-project
      def delete_project(project_id, options = {})
        opts = ensure_api_media_type(:projects, options)
        delete "projects/#{project_id}", opts
      end

      # Get a project column
      #
      # @param column_id [Integer] The ID of the column
      # @return [Array<Sawyer::Resource>] A list of columns
      # @see https://developer.github.com/v3/projects/columns/#get-a-project-column
      def project_column(column_id, options = {})
        opts = ensure_api_media_type(:projects, options)
        get "projects/columns/#{column_id}", opts
      end

      # List project columns
      #
      # @param project_id [Integer] The ID of the project
      # @return [Array<Sawyer::Resource>] A list of columns
      # @see https://developer.github.com/v3/projects/columns/#list-project-columns
      def project_columns(project_id, options = {})
        opts = ensure_api_media_type(:projects, options)
        paginate "projects/#{project_id}/columns", opts
      end

      # List collaborators
      #
      # @param project_id [Integer] The ID of the project
      # @option options [String] :affiliation Filters the collaborators by their affiliation. Can be one of:  outside, direct, all
      # @return [Array<Sawyer::Resource>] A list of collaborators
      # @see https://developer.github.com/v3/projects/collaborators/#list-collaborators
      def project_collaborators(project_id, options = {})
        opts = ensure_api_media_type(:projects, options)
        paginate "projects/#{project_id}/collaborators", opts
      end

      # Create a project column
      #
      # @param project_id [Integer] The ID of the project
      # @param name [String] The name of the column.
      # @return [Sawyer::Resource] The new column
      # @see https://developer.github.com/v3/projects/columns/#create-a-project-column
      def create_project_column(project_id, name, options = {})
        options[:name] = name
        opts = ensure_api_media_type(:projects, options)
        post "projects/#{project_id}/columns", opts
      end

      # Update a project column
      #
      # @param column_id [Integer] The ID of the column
      # @param name [String] The new name of the column.
      # @return [Sawyer::Resource] The updated column
      # @see https://developer.github.com/v3/projects/columns/#update-a-project-column
      def update_project_column(column_id, name, options = {})
        options[:name] = name
        opts = ensure_api_media_type(:projects, options)
        patch "projects/columns/#{column_id}", opts
      end

      # Delete a project column
      #
      # @param column_id [Integer] The ID of the column
      # @return [Boolean] True on success, false otherwise
      # @see https://developer.github.com/v3/projects/columns/#delete-a-project-column
      def delete_project_column(column_id, options = {})
        opts = ensure_api_media_type(:projects, options)
        boolean_from_response :delete, "projects/columns/#{column_id}", opts
      end

      # List user projects
      #
      # @param user [Integer, String] A GitHub user
      # @option options [String] :state Indicates the state of the projects to return. Can be either `open`, `closed`, or `all`.
      # @return [Array<Sawyer::Resource>] A list of projects
      # @see https://developer.github.com/v3/projects/#list-user-projects
      def user_projects(user, options = {})
        opts = ensure_api_media_type(:projects, options)
        paginate "#{User.path user}/projects", opts
      end

      # Get a project card
      #
      # @param card_id [Integer] The ID of the card
      # @return [Array<Sawyer::Resource>] A list of cards
      # @see https://developer.github.com/v3/projects/cards/#get-a-project-card
      def project_card(card_id, options = {})
        opts = ensure_api_media_type(:projects, options)
        get "projects/columns/cards/#{card_id}", opts
      end

      # List project cards
      #
      # @param column_id [Integer] The ID of the column
      # @option options [String] :archived_state Filters the project cards that are returned by the card's state. Can be one of `all`,`archived`, or `not_archived`.
      # @return [Array<Sawyer::Resource>] A list of cards
      # @see https://developer.github.com/v3/projects/cards/#list-project-cards
      def project_cards(column_id, options = {})
        opts = ensure_api_media_type(:projects, options)
        paginate "projects/columns/#{column_id}/cards", opts
      end

      # List organization projects
      #
      # @param org [Integer, String] A GitHub organization
      # @option options [String] :state Indicates the state of the projects to return. Can be either `open`, `closed`, or `all`.
      # @return [Array<Sawyer::Resource>] A list of projects
      # @see https://developer.github.com/v3/projects/#list-organization-projects
      def org_projects(org, options = {})
        opts = ensure_api_media_type(:projects, options)
        paginate "#{Organization.path org}/projects", opts
      end

      # Create a project card
      #
      # @param column_id [Integer] The ID of the column
      # @option options [String] :note The card's note content. Only valid for cards without another type of content, so you must omit when specifying `content_id` and `content_type`.
      # @option options [Integer] :content_id The ID of the content
      # @option options [String] :content_type **Required if you provide `content_id`**. The type of content you want to associate with this card. Use `Issue` when `content_id` is an issue id and use `PullRequest` when `content_id` is a pull request id.
      # @return [Sawyer::Resource] The new card
      # @see https://developer.github.com/v3/projects/cards/#create-a-project-card
      def create_project_card(column_id, options = {})
        opts = ensure_api_media_type(:projects, options)
        post "projects/columns/#{column_id}/cards", opts
      end

      # Create an organization project
      #
      # @param org [Integer, String] A GitHub organization
      # @param name [String] The name of the project.
      # @option options [String] :body The description of the project.
      # @return [Sawyer::Resource] The new project
      # @see https://developer.github.com/v3/projects/#create-an-organization-project
      def create_org_project(org, name, options = {})
        options[:name] = name
        opts = ensure_api_media_type(:projects, options)
        post "#{Organization.path org}/projects", opts
      end

      # Move a project column
      #
      # @param column_id [Integer] The ID of the column
      # @param position [String] Can be one of `first`, `last`, or `after:<column_id>`, where `<column_id>` is the `id` value of a column in the same project.
      # @return [Sawyer::Resource] The new column
      # @see https://developer.github.com/v3/projects/columns/#move-a-project-column
      def move_project_column(column_id, position, options = {})
        options[:position] = position
        opts = ensure_api_media_type(:projects, options)
        post "projects/columns/#{column_id}/moves", opts
      end

      # Add user as a collaborator
      #
      # @param project_id [Integer] The ID of the project
      # @param username [String] The username of the collaborator
      # @option options [String] :permission The permission to grant the collaborator. Note that, if you choose not to pass any parameters, you'll need to set `Content-Length` to zero when calling out to this endpoint. For more information, see "[HTTP verbs](https://developer.github.com/v3/#http-verbs)." Can be one of:  read, write, admin
      # @return [Boolean] True on success, false otherwise
      # @see https://developer.github.com/v3/projects/collaborators/#add-user-as-a-collaborator
      def add_project_collaborator(project_id, username, options = {})
        opts = ensure_api_media_type(:projects, options)
        boolean_from_response :put, "projects/#{project_id}/collaborators/#{username}", opts
      end

      # Update a project card
      #
      # @param card_id [Integer] The ID of the card
      # @option options [String] :note The card's note content. Only valid for cards without another type of content, so this cannot be specified if the card already has a `content_id` and `content_type`.
      # @option options [Boolean] :archived Use `true` to archive a project card. Specify `false` if you need to restore a previously archived project card.
      # @return [Sawyer::Resource] The updated card
      # @see https://developer.github.com/v3/projects/cards/#update-a-project-card
      def update_project_card(card_id, options = {})
        opts = ensure_api_media_type(:projects, options)
        patch "projects/columns/cards/#{card_id}", opts
      end

      # Delete a project card
      #
      # @param card_id [Integer] The ID of the card
      # @return [Boolean] True on success, false otherwise
      # @see https://developer.github.com/v3/projects/cards/#delete-a-project-card
      def delete_project_card(card_id, options = {})
        opts = ensure_api_media_type(:projects, options)
        boolean_from_response :delete, "projects/columns/cards/#{card_id}", opts
      end

      # Remove user as a collaborator
      #
      # @param project_id [Integer] The ID of the project
      # @param username [String] The username of the collaborator
      # @return [Boolean] True on success, false otherwise
      # @see https://developer.github.com/v3/projects/collaborators/#remove-user-as-a-collaborator
      def remove_project_collaborator(project_id, username, options = {})
        opts = ensure_api_media_type(:projects, options)
        boolean_from_response :delete, "projects/#{project_id}/collaborators/#{username}", opts
      end

      # Review a user's permission level
      #
      # @param project_id [Integer] The ID of the project
      # @param username [String] The username of the level
      # @return [Sawyer::Resource] A single level
      # @see https://developer.github.com/v3/projects/collaborators/#review-a-users-permission-level
      def user_permission_level(project_id, username, options = {})
        opts = ensure_api_media_type(:projects, options)
        get "projects/#{project_id}/collaborators/#{username}/permission", opts
      end

      # List repository projects
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @option options [String] :state Indicates the state of the projects to return. Can be either `open`, `closed`, or `all`.
      # @return [Array<Sawyer::Resource>] A list of projects
      # @see https://developer.github.com/v3/projects/#list-repository-projects
      def repository_projects(repo, options = {})
        opts = ensure_api_media_type(:projects, options)
        paginate "#{Repository.path repo}/projects", opts
      end

      # Create a repository project
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @param name [String] The name of the project.
      # @option options [String] :body The description of the project.
      # @return [Sawyer::Resource] The new project
      # @see https://developer.github.com/v3/projects/#create-a-repository-project
      def create_repository_project(repo, name, options = {})
        options[:name] = name
        opts = ensure_api_media_type(:projects, options)
        post "#{Repository.path repo}/projects", opts
      end

      # Move a project card
      #
      # @param card_id [Integer] The ID of the card
      # @param position [String] Can be one of `top`, `bottom`, or `after:<card_id>`, where `<card_id>` is the `id` value of a card in the same column, or in the new column specified by `column_id`.
      # @option options [Integer] :column_id The ID of the column
      # @return [Sawyer::Resource] The new card
      # @see https://developer.github.com/v3/projects/cards/#move-a-project-card
      def move_project_card(card_id, position, options = {})
        options[:position] = position
        opts = ensure_api_media_type(:projects, options)
        post "projects/columns/cards/#{card_id}/moves", opts
      end
    end
  end
end
