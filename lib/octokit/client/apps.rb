# frozen_string_literal: true

module Octokit
  class Client
    # Methods for the Apps API
    module Apps
      # Get the authenticated App
      #
      # @param options [Hash] A customizable set of options
      #
      # @see https://docs.github.com/en/rest/apps/apps#get-the-authenticated-app
      #
      # @return [Sawyer::Resource] App information
      def app(options = {})
        get 'app', options
      end

      # List all installations that belong to an App
      #
      # @param options [Hash] A customizable set of options
      #
      # @see https://docs.github.com/en/rest/apps/apps#list-installations-for-the-authenticated-app
      #
      # @return [Array<Sawyer::Resource>] the total_count and an array of installations
      def list_app_installations(options = {})
        paginate 'app/installations', options
      end
      alias find_installations list_app_installations
      alias find_app_installations list_app_installations

      # List all installations that are accessible to the authenticated user
      #
      # @param options [Hash] A customizable set of options
      #
      # @see https://docs.github.com/en/rest/apps/installations#list-app-installations-accessible-to-the-user-access-token
      #
      # @return [Sawyer::Resource] the total_count and an array of installations
      def list_user_installations(options = {})
        paginate('user/installations', options) do |data, last_response|
          data.installations.concat last_response.data.installations
        end
      end
      alias find_user_installations list_user_installations

      # Get a single installation
      #
      # @param id [Integer] Installation id
      #
      # @see https://docs.github.com/en/rest/apps/apps#get-an-installation-for-the-authenticated-app
      #
      # @return [Sawyer::Resource] Installation information
      def installation(id, options = {})
        get "app/installations/#{id}", options
      end

      # Create a new installation token
      #
      # @param installation [Integer] The id of a GitHub App Installation
      # @param options [Hash] A customizable set of options
      #
      # @see https://docs.github.com/en/rest/apps/apps#create-an-installation-access-token-for-an-app
      #
      # @return [<Sawyer::Resource>] An installation token
      def create_app_installation_access_token(installation, options = {})
        post "app/installations/#{installation}/access_tokens", options
      end
      alias create_installation_access_token create_app_installation_access_token

      # Enables an app to find the organization's installation information.
      #
      # @param organization [String] Organization GitHub login
      # @param options [Hash] A customizable set of options
      #
      # @see https://docs.github.com/en/rest/apps/apps#get-an-organization-installation-for-the-authenticated-app
      #
      # @return [Sawyer::Resource] Installation information
      def find_organization_installation(organization, options = {})
        get "#{Organization.path(organization)}/installation", options
      end

      # Enables an app to find the repository's installation information.
      #
      # @param repo [String] A GitHub repository
      # @param options [Hash] A customizable set of options
      #
      # @see https://docs.github.com/en/rest/apps/apps#get-a-repository-installation-for-the-authenticated-app
      #
      # @return [Sawyer::Resource] Installation information
      def find_repository_installation(repo, options = {})
        get "#{Repository.path(repo)}/installation", options
      end

      # Enables an app to find the user's installation information.
      #
      # @param user [String] GitHub user login
      # @param options [Hash] A customizable set of options
      #
      # @see https://docs.github.com/en/rest/apps/apps#get-a-user-installation-for-the-authenticated-app
      #
      # @return [Sawyer::Resource] Installation information
      def find_user_installation(user, options = {})
        get "#{User.path(user)}/installation", options
      end

      # List repositories that are accessible to the authenticated installation
      #
      # @param options [Hash] A customizable set of options
      #
      # @see https://docs.github.com/en/rest/apps/installations#list-repositories-accessible-to-the-app-installation
      #
      # @return [Sawyer::Resource] the total_count and an array of repositories
      def list_app_installation_repositories(options = {})
        paginate('installation/repositories', options) do |data, last_response|
          data.repositories.concat last_response.data.repositories
        end
      end
      alias list_installation_repos list_app_installation_repositories

      # Add a single repository to an installation
      #
      # @param installation [Integer] The id of a GitHub App Installation
      # @param repo [Integer] The id of the GitHub repository
      # @param options [Hash] A customizable set of options
      #
      # @see https://docs.github.com/en/rest/apps/installations#add-a-repository-to-an-app-installation
      #
      # @return [Boolean] Success
      def add_repository_to_app_installation(installation, repo, options = {})
        boolean_from_response :put, "user/installations/#{installation}/repositories/#{repo}", options
      end
      alias add_repo_to_installation add_repository_to_app_installation

      # Remove a single repository to an installation
      #
      # @param installation [Integer] The id of a GitHub App Installation
      # @param repo [Integer] The id of the GitHub repository
      # @param options [Hash] A customizable set of options
      #
      # @see https://docs.github.com/en/rest/apps/installations#remove-a-repository-from-an-app-installation
      #
      # @return [Boolean] Success
      def remove_repository_from_app_installation(installation, repo, options = {})
        boolean_from_response :delete, "user/installations/#{installation}/repositories/#{repo}", options
      end
      alias remove_repo_from_installation remove_repository_from_app_installation

      # List repositories accessible to the user for an installation
      #
      # @param installation [Integer] The id of a GitHub App Installation
      # @param options [Hash] A customizable set of options
      #
      # @see https://docs.github.com/en/rest/apps/installations#list-repositories-accessible-to-the-user-access-token
      #
      # @return [Sawyer::Resource] the total_count and an array of repositories
      def find_installation_repositories_for_user(installation, options = {})
        paginate("user/installations/#{installation}/repositories", options) do |data, last_response|
          data.repositories.concat last_response.data.repositories
        end
      end

      # Delete an installation and uninstall a GitHub App
      #
      # @param installation [Integer] The id of a GitHub App Installation
      # @param options [Hash] A customizable set of options
      #
      # @see https://docs.github.com/en/rest/apps/apps#delete-an-installation-for-the-authenticated-app
      #
      # @return [Boolean] Success
      def delete_installation(installation, options = {})
        boolean_from_response :delete, "app/installations/#{installation}", options
      end

      # Returns a list of webhook deliveries for the webhook configured for a GitHub App.
      #
      # @param options [Hash] A customizable set of options
      #
      # @see https://docs.github.com/en/rest/apps/webhooks#list-deliveries-for-an-app-webhook
      #
      # @return [Array<Hash>] an array of hook deliveries
      def list_app_hook_deliveries(options = {})
        paginate('app/hook/deliveries', options) do |data, last_response|
          data.concat last_response.data
        end
      end

      # Returns a delivery for the webhook configured for a GitHub App.
      #
      # @param delivery_id [String] The id of a GitHub App Hook Delivery
      # @param options [Hash] A customizable set of options
      #
      # @see https://docs.github.com/en/rest/apps/webhooks#get-a-delivery-for-an-app-webhook
      #
      # @return [<Sawyer::Resource>] The webhook delivery
      def app_hook_delivery(delivery_id, options = {})
        get "/app/hook/deliveries/#{delivery_id}", options
      end

      # Redeliver a delivery for the webhook configured for a GitHub App.
      #
      # @param delivery_id [Integer] The id of a GitHub App Hook Delivery
      # @param options [Hash] A customizable set of options
      #
      # @see https://docs.github.com/en/rest/apps/webhooks#redeliver-a-delivery-for-an-app-webhook
      #
      # @return [Boolean] Success
      def deliver_app_hook(delivery_id, options = {})
        boolean_from_response :post, "app/hook/deliveries/#{delivery_id}/attempts", options
      end
    end
  end
end
