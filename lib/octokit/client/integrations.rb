module Octokit
  class Client

    # Methods for the Integrations API
    module Integrations

      # Find all installations that belong to an Integration
      #
      # @param options [Hash] An customizable set of options
      #
      # @see https://developer.github.com/v3/integrations/#find-installations
      #
      # @return [Array<Sawyer::Resource>] A list of installations
      def find_integration_installations(options = {})
        opts = ensure_api_media_type(:integrations, options)
        paginate "/integration/installations", opts
      end
      alias find_installations find_integration_installations

      # Create a new installation token
      #
      # @param installation [Integer] The id of a a GitHub Integration Installation
      # @param options [Hash] An customizable set of options
      #
      # @see https://developer.github.com/v3/integrations/#find-installations
      #
      # @return [<Sawyer::Resource>] An installation token
      def create_integration_installation_access_token(installation, options = {})
        opts = ensure_api_media_type(:integrations, options)
        post "/installations/#{installation}/access_tokens", opts
      end
      alias create_installation_access_token create_integration_installation_access_token

      # List repositories that are accessible to the authenticated installation
      #
      # @param options [Hash] An customizable set of options
      # @see https://developer.github.com/v3/integrations/installations/#list-repositories
      #
      # @return [Array<Sawyer::Resource>] A list of repositories
      def list_integration_installation_repositories(options = {})
        opts = ensure_api_media_type(:integrations, options)
        paginate "/installation/repositories", opts
      end
      alias list_installation_repos list_integration_installation_repositories

      # Add a single repository to an installation
      #
      # @param installation [Integer] The id of a a GitHub Integration Installation
      # @param repo [Integer] The id of the GitHub repository
      # @param options [Hash] An customizable set of options
      #
      # @see https://developer.github.com/v3/integrations/installations/#add-repository-to-installation
      #
      # @return [Boolean] Success
      def add_repository_to_integration_installation(installation, repo, options = {})
        opts = ensure_api_media_type(:integrations, options)
        boolean_from_response :put, "/installations/#{installation}/repositories/#{repo}", opts
      end
      alias add_repo_to_installation add_repository_to_integration_installation

      # Remove a single repository to an installation
      #
      # @param installation [Integer] The id of a a GitHub Integration Installation
      # @param repo [Integer] The id of the GitHub repository
      # @param options [Hash] An customizable set of options
      #
      # @see https://developer.github.com/v3/integrations/installations/#remove-repository-from-installation
      #
      # @return [Boolean] Success
      def remove_repository_from_integration_installation(installation, repo, options = {})
        opts = ensure_api_media_type(:integrations, options)
        boolean_from_response :delete, "/installations/#{installation}/repositories/#{repo}", opts
      end
      alias remove_repo_from_installation remove_repository_from_integration_installation
    end
  end
end
