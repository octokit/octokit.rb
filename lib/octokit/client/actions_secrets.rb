module Octokit
  class Client

    # Methods for the Actions Secrets API
    #
    # @see https://developer.github.com/v3/actions/secrets/
    module ActionsSecrets

      # Get public key for secrets encryption
      #
      # @param repo [Integer, String, Hash, Repository] A GitHub repository
      # @return [Hash] key_id and key
      def get_public_key(repo)
        get "#{Repository.path repo}/actions/secrets/public-key"
      end


      # List secrets
      #
      # @param repo [Integer, String, Hash, Repository] A GitHub repository
      # @return [Hash] total_count and list of secrets (each item is hash with name, created_at and updated_at)
      def list_secrets(repo)
        get "#{Repository.path repo}/actions/secrets"
      end

      # Get a secret
      #
      # @param repo [Integer, String, Hash, Repository] A GitHub repository
      # @param name [String] Name of secret
      # @return [Hash] name, created_at and updated_at
      def get_secret(repo, name)
        get "#{Repository.path repo}/actions/secrets/#{name}"
      end

      # Create or update secrets
      #
      # @param repo [Integer, String, Hash, Repository] A GitHub repository
      # @param name [String] Name of secret
      # @param options [Hash] encrypted_value and key_id
      def create_or_update_secret(repo, name, options)
        put "#{Repository.path repo}/actions/secrets/#{name}", options
      end

      # Delete a secret
      #
      # @param repo [Integer, String, Hash, Repository] A GitHub repository
      # @param name [String] Name of secret
      def delete_secret(repo, name)
        delete "#{Repository.path repo}/actions/secrets/#{name}"
      end
    end
  end
end
