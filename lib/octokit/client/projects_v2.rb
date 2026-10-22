# frozen_string_literal: true

module Octokit
  class Client
    # Methods for Projects V2 API
    #
    # @see https://docs.github.com/en/rest/projects
    module ProjectsV2
      # List organization projects
      #
      # Requires authenticated client
      #
      # @param org [String] The organization name. The name is not case sensitive.
      # @param options [Hash] Pagination and filter options (e.g. :q, :per_page, :before, :after)
      # @return [Array<Sawyer::Resource>] Organization projects
      # @see https://docs.github.com/en/rest/projects/projects?apiVersion=2026-03-10#list-projects-for-organization
      # @example
      #   @client.org_projects_v2("octokit")
      def org_projects_v2(org, options = {})
        paginate "#{Organization.path org}/projectsV2", options
      end
      alias organization_projects_v2 org_projects_v2

      # List projects for user
      #
      # Requires authenticated client
      #
      # @param username [String] The handle for the GitHub user account.
      # @param options [Hash] Pagination and filter options (e.g. :q, :per_page, :before, :after)
      # @return [Array<Sawyer::Resource>] User projects
      # @see https://docs.github.com/en/rest/projects/projects?apiVersion=2026-03-10#list-projects-for-user
      # @example
      #   @client.user_projects_v2("octokit")
      def user_projects_v2(username, options = {})
        paginate "#{User.path username}/projectsV2", options
      end

      # Get a specific organization-owned project
      #
      # @param org [String] The organization name. The name is not case sensitive.
      # @param project_number [Integer] The project's number.
      # @param options [Hash] Additional options
      #
      # @return [Sawyer::Resource] Project
      # @see https://docs.github.com/en/rest/projects/projects?apiVersion=2026-03-10#get-project-for-organization
      # @example
      #   Octokit.org_project_v2("octokit", 1)
      def org_project_v2(org, project_number, options = {})
        get "#{Organization.path org}/projectsV2/#{project_number}", options
      end
      alias organization_project_v2 org_project_v2

      # Get a specific user-owned project
      #
      # @param username [String] The handle for the GitHub user account.
      # @param project_number [Integer] The project's number.
      # @param options [Hash] Additional options
      #
      # @return [Sawyer::Resource] Project
      # @see https://docs.github.com/en/rest/projects/projects?apiVersion=2026-03-10#get-project-for-user
      # @example
      #   Octokit.user_project_v2("octocat", 1)
      def user_project_v2(username, project_number, options = {})
        get "#{User.path username}/projectsV2/#{project_number}", options
      end

      # List project fields for organization
      #
      # @param org [String] The organization name. The name is not case sensitive.
      # @param project_number [Integer] The project's number.
      # @param options [Hash] Pagination options (e.g. :per_page, :before, :after)
      # @return [Array<Sawyer::Resource>] Project fields
      # @see https://docs.github.com/en/rest/projects/fields?apiVersion=2026-03-10#list-project-fields-for-organization
      # @example
      #   @client.org_project_v2_fields("octokit", 1)
      def org_project_v2_fields(org, project_number, options = {})
        paginate "#{Organization.path org}/projectsV2/#{project_number}/fields", options
      end
      alias organization_project_v2_fields org_project_v2_fields

      # Get project field for organization
      #
      # @param org [String] The organization name. The name is not case sensitive.
      # @param project_number [Integer] The project's number.
      # @param field_id [Integer] The unique identifier of the field.
      # @param options [Hash] Additional options
      # @return [Sawyer::Resource] Project field
      # @see https://docs.github.com/en/rest/projects/fields?apiVersion=2026-03-10#get-project-field-for-organization
      # @example
      #   @client.org_project_v2_field("octokit", 1, 12345)
      def org_project_v2_field(org, project_number, field_id, options = {})
        get "#{Organization.path org}/projectsV2/#{project_number}/fields/#{field_id}", options
      end
      alias organization_project_v2_field org_project_v2_field

      # Add a field to an organization-owned project
      #
      # @param org [String] The organization name. The name is not case sensitive.
      # @param project_number [Integer] The project's number.
      # @param options [Hash] Field attributes. Either :name and :data_type
      #   (plus :single_select_options or :iteration_configuration where needed), or :issue_field_id
      # @return [Sawyer::Resource] The new project field
      # @see https://docs.github.com/en/rest/projects/fields?apiVersion=2026-03-10#add-a-field-to-an-organization-owned-project
      # @example
      #   @client.create_org_project_v2_field("octokit", 1, name: "Priority", data_type: "text")
      def create_org_project_v2_field(org, project_number, options = {})
        post "#{Organization.path org}/projectsV2/#{project_number}/fields", options
      end
      alias create_organization_project_v2_field create_org_project_v2_field

      # List items for an organization owned project
      #
      # @param org [String] The organization name. The name is not case sensitive.
      # @param project_number [Integer] The project's number.
      # @param options [Hash] Pagination and filter options (e.g. :q, :fields, :per_page, :before, :after)
      # @return [Array<Sawyer::Resource>] Project items
      # @see https://docs.github.com/en/rest/projects/items?apiVersion=2026-03-10#list-items-for-an-organization-owned-project
      # @example
      #   @client.org_project_v2_items("octokit", 1)
      def org_project_v2_items(org, project_number, options = {})
        paginate "#{Organization.path org}/projectsV2/#{project_number}/items", options
      end
      alias organization_project_v2_items org_project_v2_items

      # Get an item for an organization owned project
      #
      # @param org [String] The organization name. The name is not case sensitive.
      # @param project_number [Integer] The project's number.
      # @param item_id [Integer] The unique identifier of the project item.
      # @param options [Hash] Additional options (e.g. :fields)
      # @return [Sawyer::Resource] Project item
      # @see https://docs.github.com/en/rest/projects/items?apiVersion=2026-03-10#get-an-item-for-an-organization-owned-project
      # @example
      #   @client.org_project_v2_item("octokit", 1, 12345)
      def org_project_v2_item(org, project_number, item_id, options = {})
        get "#{Organization.path org}/projectsV2/#{project_number}/items/#{item_id}", options
      end
      alias organization_project_v2_item org_project_v2_item

      # Add item to an organization owned project
      #
      # @param org [String] The organization name. The name is not case sensitive.
      # @param project_number [Integer] The project's number.
      # @param type [String] The type of item: "Issue" or "PullRequest".
      # @param options [Hash] Either :id, or :owner, :repo and :number of the issue or pull request
      # @return [Sawyer::Resource] The added project item
      # @see https://docs.github.com/en/rest/projects/items?apiVersion=2026-03-10#add-item-to-organization-owned-project
      # @example
      #   @client.add_org_project_v2_item("octokit", 1, "Issue", owner: "octokit", repo: "octokit.rb", number: 1)
      def add_org_project_v2_item(org, project_number, type, options = {})
        post "#{Organization.path org}/projectsV2/#{project_number}/items", options.merge(type: type)
      end
      alias add_organization_project_v2_item add_org_project_v2_item

      # Update project item for organization
      #
      # @param org [String] The organization name. The name is not case sensitive.
      # @param project_number [Integer] The project's number.
      # @param item_id [Integer] The unique identifier of the project item.
      # @param fields [Array<Hash>] Field updates, each with :id and :value
      # @param options [Hash] Additional options
      # @return [Sawyer::Resource] The updated project item
      # @see https://docs.github.com/en/rest/projects/items?apiVersion=2026-03-10#update-project-item-for-organization
      # @example
      #   @client.update_org_project_v2_item("octokit", 1, 12345, [{ id: 678, value: "Done" }])
      def update_org_project_v2_item(org, project_number, item_id, fields, options = {})
        patch "#{Organization.path org}/projectsV2/#{project_number}/items/#{item_id}", options.merge(fields: fields)
      end
      alias update_organization_project_v2_item update_org_project_v2_item

      # Delete project item for organization
      #
      # @param org [String] The organization name. The name is not case sensitive.
      # @param project_number [Integer] The project's number.
      # @param item_id [Integer] The unique identifier of the project item.
      # @param options [Hash] Additional options
      # @return [Boolean] true if the item was deleted
      # @see https://docs.github.com/en/rest/projects/items?apiVersion=2026-03-10#delete-project-item-for-organization
      # @example
      #   @client.delete_org_project_v2_item("octokit", 1, 12345)
      def delete_org_project_v2_item(org, project_number, item_id, options = {})
        boolean_from_response :delete, "#{Organization.path org}/projectsV2/#{project_number}/items/#{item_id}", options
      end
      alias delete_organization_project_v2_item delete_org_project_v2_item

      # Create draft item for organization owned project
      #
      # @param org [String] The organization name. The name is not case sensitive.
      # @param project_number [Integer] The project's number.
      # @param title [String] The title of the draft issue item.
      # @param options [Hash] Additional options (e.g. :body)
      # @return [Sawyer::Resource] The new draft item
      # @see https://docs.github.com/en/rest/projects/drafts?apiVersion=2026-03-10#create-draft-item-for-organization-owned-project
      # @example
      #   @client.create_org_project_v2_draft_item("octokit", 1, "Write docs", body: "Details")
      def create_org_project_v2_draft_item(org, project_number, title, options = {})
        post "#{Organization.path org}/projectsV2/#{project_number}/drafts", options.merge(title: title)
      end
      alias create_organization_project_v2_draft_item create_org_project_v2_draft_item

      # Create a view for an organization-owned project
      #
      # @param org [String] The organization name. The name is not case sensitive.
      # @param project_number [Integer] The project's number.
      # @param name [String] The name of the view.
      # @param layout [String] The layout of the view: "table", "board" or "roadmap".
      # @param options [Hash] Additional options (e.g. :filter, :visible_fields, :sort_by, :group_by, :vertical_group_by)
      # @return [Sawyer::Resource] The new project view
      # @see https://docs.github.com/en/rest/projects/views?apiVersion=2026-03-10#create-a-view-for-an-organization-owned-project
      # @example
      #   @client.create_org_project_v2_view("octokit", 1, "Board", "board")
      def create_org_project_v2_view(org, project_number, name, layout, options = {})
        post "#{Organization.path org}/projectsV2/#{project_number}/views", options.merge(name: name, layout: layout)
      end
      alias create_organization_project_v2_view create_org_project_v2_view

      # List items for an organization project view
      #
      # @param org [String] The organization name. The name is not case sensitive.
      # @param project_number [Integer] The project's number.
      # @param view_number [Integer] The number that identifies the project view.
      # @param options [Hash] Pagination options (e.g. :fields, :per_page, :before, :after)
      # @return [Array<Sawyer::Resource>] Project view items
      # @see https://docs.github.com/en/rest/projects/items?apiVersion=2026-03-10#list-items-for-an-organization-project-view
      # @example
      #   @client.org_project_v2_view_items("octokit", 1, 1)
      def org_project_v2_view_items(org, project_number, view_number, options = {})
        paginate "#{Organization.path org}/projectsV2/#{project_number}/views/#{view_number}/items", options
      end
      alias organization_project_v2_view_items org_project_v2_view_items

      # List project fields for user
      #
      # @param username [String] The handle for the GitHub user account.
      # @param project_number [Integer] The project's number.
      # @param options [Hash] Pagination options (e.g. :per_page, :before, :after)
      # @return [Array<Sawyer::Resource>] Project fields
      # @see https://docs.github.com/en/rest/projects/fields?apiVersion=2026-03-10#list-project-fields-for-user
      # @example
      #   @client.user_project_v2_fields("octocat", 1)
      def user_project_v2_fields(username, project_number, options = {})
        paginate "#{User.path username}/projectsV2/#{project_number}/fields", options
      end

      # Get project field for user
      #
      # @param username [String] The handle for the GitHub user account.
      # @param project_number [Integer] The project's number.
      # @param field_id [Integer] The unique identifier of the field.
      # @param options [Hash] Additional options
      # @return [Sawyer::Resource] Project field
      # @see https://docs.github.com/en/rest/projects/fields?apiVersion=2026-03-10#get-project-field-for-user
      # @example
      #   @client.user_project_v2_field("octocat", 1, 12345)
      def user_project_v2_field(username, project_number, field_id, options = {})
        get "#{User.path username}/projectsV2/#{project_number}/fields/#{field_id}", options
      end

      # Add a field to a user-owned project
      #
      # @param username [String] The handle for the GitHub user account.
      # @param project_number [Integer] The project's number.
      # @param options [Hash] Field attributes. Either :name and :data_type
      #   (plus :single_select_options or :iteration_configuration where needed)
      # @return [Sawyer::Resource] The new project field
      # @see https://docs.github.com/en/rest/projects/fields?apiVersion=2026-03-10#add-field-to-user-owned-project
      # @example
      #   @client.create_user_project_v2_field("octocat", 1, name: "Priority", data_type: "text")
      def create_user_project_v2_field(username, project_number, options = {})
        post "#{User.path username}/projectsV2/#{project_number}/fields", options
      end

      # List items for a user owned project
      #
      # @param username [String] The handle for the GitHub user account.
      # @param project_number [Integer] The project's number.
      # @param options [Hash] Pagination and filter options (e.g. :q, :fields, :per_page, :before, :after)
      # @return [Array<Sawyer::Resource>] Project items
      # @see https://docs.github.com/en/rest/projects/items?apiVersion=2026-03-10#list-items-for-a-user-owned-project
      # @example
      #   @client.user_project_v2_items("octocat", 1)
      def user_project_v2_items(username, project_number, options = {})
        paginate "#{User.path username}/projectsV2/#{project_number}/items", options
      end

      # Get an item for a user owned project
      #
      # @param username [String] The handle for the GitHub user account.
      # @param project_number [Integer] The project's number.
      # @param item_id [Integer] The unique identifier of the project item.
      # @param options [Hash] Additional options (e.g. :fields)
      # @return [Sawyer::Resource] Project item
      # @see https://docs.github.com/en/rest/projects/items?apiVersion=2026-03-10#get-an-item-for-a-user-owned-project
      # @example
      #   @client.user_project_v2_item("octocat", 1, 12345)
      def user_project_v2_item(username, project_number, item_id, options = {})
        get "#{User.path username}/projectsV2/#{project_number}/items/#{item_id}", options
      end

      # Add item to a user owned project
      #
      # @param username [String] The handle for the GitHub user account.
      # @param project_number [Integer] The project's number.
      # @param type [String] The type of item: "Issue" or "PullRequest".
      # @param options [Hash] Either :id, or :owner, :repo and :number of the issue or pull request
      # @return [Sawyer::Resource] The added project item
      # @see https://docs.github.com/en/rest/projects/items?apiVersion=2026-03-10#add-item-to-user-owned-project
      # @example
      #   @client.add_user_project_v2_item("octocat", 1, "Issue", owner: "octokit", repo: "octokit.rb", number: 1)
      def add_user_project_v2_item(username, project_number, type, options = {})
        post "#{User.path username}/projectsV2/#{project_number}/items", options.merge(type: type)
      end

      # Update project item for user
      #
      # @param username [String] The handle for the GitHub user account.
      # @param project_number [Integer] The project's number.
      # @param item_id [Integer] The unique identifier of the project item.
      # @param fields [Array<Hash>] Field updates, each with :id and :value
      # @param options [Hash] Additional options
      # @return [Sawyer::Resource] The updated project item
      # @see https://docs.github.com/en/rest/projects/items?apiVersion=2026-03-10#update-project-item-for-user
      # @example
      #   @client.update_user_project_v2_item("octocat", 1, 12345, [{ id: 678, value: "Done" }])
      def update_user_project_v2_item(username, project_number, item_id, fields, options = {})
        patch "#{User.path username}/projectsV2/#{project_number}/items/#{item_id}", options.merge(fields: fields)
      end

      # Delete project item for user
      #
      # @param username [String] The handle for the GitHub user account.
      # @param project_number [Integer] The project's number.
      # @param item_id [Integer] The unique identifier of the project item.
      # @param options [Hash] Additional options
      # @return [Boolean] true if the item was deleted
      # @see https://docs.github.com/en/rest/projects/items?apiVersion=2026-03-10#delete-project-item-for-user
      # @example
      #   @client.delete_user_project_v2_item("octocat", 1, 12345)
      def delete_user_project_v2_item(username, project_number, item_id, options = {})
        boolean_from_response :delete, "#{User.path username}/projectsV2/#{project_number}/items/#{item_id}", options
      end

      # Create draft item for user owned project
      #
      # @param user_id [Integer] The unique identifier of the user.
      # @param project_number [Integer] The project's number.
      # @param title [String] The title of the draft issue item.
      # @param options [Hash] Additional options (e.g. :body)
      # @return [Sawyer::Resource] The new draft item
      # @see https://docs.github.com/en/rest/projects/drafts?apiVersion=2026-03-10#create-draft-item-for-user-owned-project
      # @example
      #   @client.create_user_project_v2_draft_item(583231, 1, "Write docs", body: "Details")
      def create_user_project_v2_draft_item(user_id, project_number, title, options = {})
        post "user/#{user_id}/projectsV2/#{project_number}/drafts", options.merge(title: title)
      end

      # Create a view for a user-owned project
      #
      # @param username [String] The handle for the GitHub user account.
      # @param project_number [Integer] The project's number.
      # @param name [String] The name of the view.
      # @param layout [String] The layout of the view: "table", "board" or "roadmap".
      # @param options [Hash] Additional options (e.g. :filter, :visible_fields, :sort_by, :group_by, :vertical_group_by)
      # @return [Sawyer::Resource] The new project view
      # @see https://docs.github.com/en/rest/projects/views?apiVersion=2026-03-10#create-a-view-for-a-user-owned-project
      # @example
      #   @client.create_user_project_v2_view("octocat", 1, "Board", "board")
      def create_user_project_v2_view(username, project_number, name, layout, options = {})
        post "#{User.path username}/projectsV2/#{project_number}/views", options.merge(name: name, layout: layout)
      end

      # List items for a user project view
      #
      # @param username [String] The handle for the GitHub user account.
      # @param project_number [Integer] The project's number.
      # @param view_number [Integer] The number that identifies the project view.
      # @param options [Hash] Pagination options (e.g. :fields, :per_page, :before, :after)
      # @return [Array<Sawyer::Resource>] Project view items
      # @see https://docs.github.com/en/rest/projects/items?apiVersion=2026-03-10#list-items-for-a-user-project-view
      # @example
      #   @client.user_project_v2_view_items("octocat", 1, 1)
      def user_project_v2_view_items(username, project_number, view_number, options = {})
        paginate "#{User.path username}/projectsV2/#{project_number}/views/#{view_number}/items", options
      end
    end # ProjectsV2
  end
end
