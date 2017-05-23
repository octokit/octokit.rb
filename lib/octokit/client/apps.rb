module Octokit
  class Client

    # Methods for the Apps API
    module Apps

      # Find all installations that belong to an App
      #
      # @param options [Hash] An customizable set of options
      #
      # @see https://developer.github.com/v3/apps/#find-installations
      #
      # @return [Array<Sawyer::Resource>] A list of installations
      def find_app_installations(options = {})
        opts = ensure_api_media_type(:integrations, options)
        paginate "/app/installations", opts
      end
      alias find_installations find_app_installations
      alias find_integration_installations find_app_installations

      # Get a single installation
      #
      # @param id [Integer] Installation id
      #
      # @see https://developer.github.com/v3/apps/#get-a-single-installation
      #
      # @return [Sawyer::Resource] Installation information
      def installation(id, options = {})
        opts = ensure_api_media_type(:integrations, options)
        get "/app/installations/#{id}", opts
      end

      # Create a new installation token
      #
      # @param installation [Integer] The id of a a GitHub App Installation
      # @param options [Hash] An customizable set of options
      #
      # @see https://developer.github.com/v3/apps/#find-installations
      #
      # @return [<Sawyer::Resource>] An installation token
      def create_app_installation_access_token(installation, options = {})
        opts = ensure_api_media_type(:integrations, options)
        post "/installations/#{installation}/access_tokens", opts
      end
      alias create_installation_access_token create_app_installation_access_token
      alias create_integration_installation_access_token create_app_installation_access_token

      # List repositories that are accessible to the authenticated installation
      #
      # @param options [Hash] An customizable set of options
      # @see https://developer.github.com/v3/apps/installations/#list-repositories
      #
      # @return [Array<Sawyer::Resource>] A list of repositories
      def list_app_installation_repositories(options = {})
        opts = ensure_api_media_type(:integrations, options)
        paginate "/installation/repositories", opts
      end
      alias list_installation_repos list_app_installation_repositories
      alias list_integration_installation_repositories list_app_installation_repositories

      # Add a single repository to an installation
      #
      # @param installation [Integer] The id of a a GitHub App Installation
      # @param repo [Integer] The id of the GitHub repository
      # @param options [Hash] An customizable set of options
      #
      # @see https://developer.github.com/v3/apps/installations/#add-repository-to-installation
      #
      # @return [Boolean] Success
      def add_repository_to_app_installation(installation, repo, options = {})
        opts = ensure_api_media_type(:integrations, options)
        boolean_from_response :put, "/installations/#{installation}/repositories/#{repo}", opts
      end
      alias add_repo_to_installation add_repository_to_app_installation
      alias add_repository_to_integration_installation add_repository_to_app_installation

      # Remove a single repository to an installation
      #
      # @param installation [Integer] The id of a a GitHub App Installation
      # @param repo [Integer] The id of the GitHub repository
      # @param options [Hash] An customizable set of options
      #
      # @see https://developer.github.com/v3/apps/installations/#remove-repository-from-installation
      #
      # @return [Boolean] Success
      def remove_repository_from_app_installation(installation, repo, options = {})
        opts = ensure_api_media_type(:integrations, options)
        boolean_from_response :delete, "/installations/#{installation}/repositories/#{repo}", opts
      end
      alias remove_repo_from_installation remove_repository_from_app_installation
      alias remove_repository_from_integration_installation remove_repository_from_app_installation
    end
  end
end
