# frozen_string_literal: true

module Octokit
  class Client
    # Methods for the Agent Secrets API
    #
    # @see https://docs.github.com/en/rest/agents/secrets
    module AgentSecrets
      # Get public key for agent secrets encryption
      #
      # @param repo [Integer, String, Hash, Repository] A GitHub repository
      # @return [Hash] key_id and key
      # @see https://docs.github.com/en/rest/agents/secrets?apiVersion=2026-03-10#get-a-repository-public-key
      def get_agent_public_key(repo)
        get "#{Repository.path repo}/agents/secrets/public-key"
      end

      # Get public key for org agent secrets encryption
      #
      # @param org [String] A GitHub organization
      # @return [Hash] key_id and key
      # @see https://docs.github.com/en/rest/agents/secrets?apiVersion=2026-03-10#get-an-organization-public-key
      def get_org_agent_public_key(org)
        get "#{Organization.path org}/agents/secrets/public-key"
      end

      # List agent secrets for a repository
      #
      # @param repo [Integer, String, Hash, Repository] A GitHub repository
      # @return [Hash] total_count and list of secrets (each item is hash with name, created_at and updated_at)
      # @see https://docs.github.com/en/rest/agents/secrets?apiVersion=2026-03-10#list-repository-secrets
      def list_agent_secrets(repo)
        paginate "#{Repository.path repo}/agents/secrets" do |data, last_response|
          data.secrets.concat last_response.data.secrets
        end
      end

      # List organization agent secrets visible to a repository
      #
      # @param repo [Integer, String, Hash, Repository] A GitHub repository
      # @return [Hash] total_count and list of secrets (each item is hash with name, created_at and updated_at)
      # @see https://docs.github.com/en/rest/agents/secrets?apiVersion=2026-03-10#list-repository-organization-secrets
      def list_agent_organization_secrets(repo)
        paginate "#{Repository.path repo}/agents/organization-secrets" do |data, last_response|
          data.secrets.concat last_response.data.secrets
        end
      end

      # List org agent secrets
      #
      # @param org [String] A GitHub organization
      # @return [Hash] total_count and list of secrets (each item is hash with name, created_at and updated_at)
      # @see https://docs.github.com/en/rest/agents/secrets?apiVersion=2026-03-10#list-organization-secrets
      def list_org_agent_secrets(org)
        paginate "#{Organization.path org}/agents/secrets" do |data, last_response|
          data.secrets.concat last_response.data.secrets
        end
      end

      # Get an agent secret for a repository
      #
      # @param repo [Integer, String, Hash, Repository] A GitHub repository
      # @param name [String] Name of secret
      # @return [Hash] name, created_at and updated_at
      # @see https://docs.github.com/en/rest/agents/secrets?apiVersion=2026-03-10#get-a-repository-secret
      def get_agent_secret(repo, name)
        get "#{Repository.path repo}/agents/secrets/#{name}"
      end

      # Get an org agent secret
      #
      # @param org [String] A GitHub organization
      # @param name [String] Name of secret
      # @return [Hash] name, created_at, updated_at, and visibility
      # @see https://docs.github.com/en/rest/agents/secrets?apiVersion=2026-03-10#get-an-organization-secret
      def get_org_agent_secret(org, name)
        get "#{Organization.path org}/agents/secrets/#{name}"
      end

      # Create or update an agent secret for a repository
      #
      # @param repo [Integer, String, Hash, Repository] A GitHub repository
      # @param name [String] Name of secret
      # @param options [Hash] encrypted_value and key_id
      # @see https://docs.github.com/en/rest/agents/secrets?apiVersion=2026-03-10#create-or-update-a-repository-secret
      def create_or_update_agent_secret(repo, name, options)
        put "#{Repository.path repo}/agents/secrets/#{name}", options
      end

      # Create or update an org agent secret
      #
      # @param org [String] A GitHub organization
      # @param name [String] Name of secret
      # @param options [Hash] encrypted_value, key_id, visibility, and optional selected_repository_ids
      # @see https://docs.github.com/en/rest/agents/secrets?apiVersion=2026-03-10#create-or-update-an-organization-secret
      def create_or_update_org_agent_secret(org, name, options)
        put "#{Organization.path org}/agents/secrets/#{name}", options
      end

      # Delete an agent secret for a repository
      #
      # @param repo [Integer, String, Hash, Repository] A GitHub repository
      # @param name [String] Name of secret
      # @see https://docs.github.com/en/rest/agents/secrets?apiVersion=2026-03-10#delete-a-repository-secret
      def delete_agent_secret(repo, name)
        boolean_from_response :delete, "#{Repository.path repo}/agents/secrets/#{name}"
      end

      # Delete an org agent secret
      #
      # @param org [String] A GitHub organization
      # @param name [String] Name of secret
      # @see https://docs.github.com/en/rest/agents/secrets?apiVersion=2026-03-10#delete-an-organization-secret
      def delete_org_agent_secret(org, name)
        boolean_from_response :delete, "#{Organization.path org}/agents/secrets/#{name}"
      end

      # List selected repositories for an org agent secret
      #
      # @param org [String] A GitHub organization
      # @param name [String] Name of secret
      # @return [Hash] total_count and list of repositories
      # @see https://docs.github.com/en/rest/agents/secrets?apiVersion=2026-03-10#list-selected-repositories-for-an-organization-secret
      def list_org_agent_secret_repositories(org, name)
        paginate "#{Organization.path org}/agents/secrets/#{name}/repositories" do |data, last_response|
          data.repositories.concat last_response.data.repositories
        end
      end

      # Set selected repositories for an org agent secret
      #
      # @param org [String] A GitHub organization
      # @param name [String] Name of secret
      # @param selected_repository_ids [Array<Integer>] Array of repository IDs that can access the secret
      # @see https://docs.github.com/en/rest/agents/secrets?apiVersion=2026-03-10#set-selected-repositories-for-an-organization-secret
      def set_org_agent_secret_repositories(org, name, selected_repository_ids)
        put "#{Organization.path org}/agents/secrets/#{name}/repositories",
            selected_repository_ids: selected_repository_ids
      end

      # Add a repository to an org agent secret
      #
      # @param org [String] A GitHub organization
      # @param name [String] Name of secret
      # @param repo_id [Integer] Repository ID
      # @see https://docs.github.com/en/rest/agents/secrets?apiVersion=2026-03-10#add-selected-repository-to-an-organization-secret
      def add_org_agent_secret_repository(org, name, repo_id)
        boolean_from_response :put, "#{Organization.path org}/agents/secrets/#{name}/repositories/#{repo_id}"
      end

      # Remove a repository from an org agent secret
      #
      # @param org [String] A GitHub organization
      # @param name [String] Name of secret
      # @param repo_id [Integer] Repository ID
      # @see https://docs.github.com/en/rest/agents/secrets?apiVersion=2026-03-10#remove-selected-repository-from-an-organization-secret
      def remove_org_agent_secret_repository(org, name, repo_id)
        boolean_from_response :delete, "#{Organization.path org}/agents/secrets/#{name}/repositories/#{repo_id}"
      end
    end
  end
end
