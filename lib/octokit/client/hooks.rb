module Octokit
  class Client

    # Methods for the Hooks API
    module Hooks

      # List all Service Hooks supported by GitHub
      #
      # @return [Sawyer::Resource] A list of all hooks on GitHub
      # @see https://developer.github.com/v3/repos/hooks/#services
      # @example List all hooks
      #   Octokit.available_hooks
      def available_hooks(options = {})
        get "hooks", options
      end

      # List repo hooks
      #
      # Requires authenticated client.
      #
      # @param repo [Integer, String, Hash, Repository] A GitHub repository.
      # @return [Array<Sawyer::Resource>] Array of hashes representing hooks.
      # @see https://developer.github.com/v3/repos/hooks/#list-hooks
      # @example
      #   @client.hooks('octokit/octokit.rb')
      def hooks(repo, options = {})
        paginate "#{Repository.path repo}/hooks", options
      end

      # Get single hook
      #
      # Requires authenticated client.
      #
      # @param repo [Integer, String, Hash, Repository] A GitHub repository.
      # @param id [Integer] Id of the hook to get.
      # @return [Sawyer::Resource] Hash representing hook.
      # @see https://developer.github.com/v3/repos/hooks/#get-single-hook
      # @example
      #   @client.hook('octokit/octokit.rb', 100000)
      def hook(repo, id, options = {})
        get "#{Repository.path repo}/hooks/#{id}", options
      end

      # Create a hook
      #
      # Requires authenticated client.
      #
      # @param repo [Integer, String, Hash, Repository] A GitHub repository.
      # @param name [String] The name of the service that is being called. See
      #   {https://api.github.com/hooks Hooks} for the possible names.
      # @param config [Hash] A Hash containing key/value pairs to provide
      #   settings for this hook. These settings vary between the services and
      #   are defined in the {https://github.com/github/github-services github-services} repo.
      # @option options [Array<String>] :events ('["push"]') Determines what
      #   events the hook is triggered for.
      # @option options [Boolean] :active Determines whether the hook is
      #   actually triggered on pushes.
      # @return [Sawyer::Resource] Hook info for the new hook
      # @see https://api.github.com/hooks
      # @see https://github.com/github/github-services
      # @see https://developer.github.com/v3/repos/hooks/#create-a-hook
      # @example
      #   @client.create_hook(
      #     'octokit/octokit.rb',
      #     'web',
      #     {
      #       :url => 'http://something.com/webhook',
      #       :content_type => 'json'
      #     },
      #     {
      #       :events => ['push', 'pull_request'],
      #       :active => true
      #     }
      #   )
      def create_hook(repo, name, config, options = {})
        options = {:name => name, :config => config, :events => ["push"], :active => true}.merge(options)
        post "#{Repository.path repo}/hooks", options
      end

      # Edit a hook
      #
      # Requires authenticated client.
      #
      # @param repo [Integer, String, Hash, Repository] A GitHub repository.
      # @param id [Integer] Id of the hook being updated.
      # @param name [String] The name of the service that is being called. See
      #   {https://api.github.com/hooks Hooks} for the possible names.
      # @param config [Hash] A Hash containing key/value pairs to provide
      #   settings for this hook. These settings vary between the services and
      #   are defined in the {https://github.com/github/github-services github-services} repo.
      # @option options [Array<String>] :events ('["push"]') Determines what
      #   events the hook is triggered for.
      # @option options [Array<String>] :add_events Determines a list of events
      #   to be added to the list of events that the Hook triggers for.
      # @option options [Array<String>] :remove_events Determines a list of events
      #   to be removed from the list of events that the Hook triggers for.
      # @option options [Boolean] :active Determines whether the hook is
      #   actually triggered on pushes.
      # @return [Sawyer::Resource] Hook info for the updated hook
      # @see https://api.github.com/hooks
      # @see https://github.com/github/github-services
      # @see https://developer.github.com/v3/repos/hooks/#edit-a-hook
      # @example
      #   @client.edit_hook(
      #     'octokit/octokit.rb',
      #     100000,
      #     'web',
      #     {
      #       :url => 'http://something.com/webhook',
      #       :content_type => 'json'
      #     },
      #     {
      #       :add_events => ['status'],
      #       :remove_events => ['pull_request'],
      #       :active => true
      #     }
      #   )
      def edit_hook(repo, id, name, config, options = {})
        options = {:name => name, :config => config, :events => ["push"], :active => true}.merge(options)
        patch "#{Repository.path repo}/hooks/#{id}", options
      end

      # Delete hook
      #
      # Requires authenticated client.
      #
      # @param repo [Integer, String, Hash, Repository] A GitHub repository.
      # @param id [Integer] Id of the hook to remove.
      # @return [Boolean] True if hook removed, false otherwise.
      # @see https://developer.github.com/v3/repos/hooks/#delete-a-hook
      # @example
      #   @client.remove_hook('octokit/octokit.rb', 1000000)
      def remove_hook(repo, id, options = {})
        boolean_from_response :delete, "#{Repository.path repo}/hooks/#{id}", options
      end

      # Test hook
      #
      # Requires authenticated client.
      #
      # @param repo [Integer, String, Hash, Repository] A GitHub repository.
      # @param id [Integer] Id of the hook to test.
      # @return [Boolean] Success
      # @see https://developer.github.com/v3/repos/hooks/#test-a-push-hook
      # @example
      #   @client.test_hook('octokit/octokit.rb', 1000000)
      def test_hook(repo, id, options = {})
        boolean_from_response :post, "#{Repository.path repo}/hooks/#{id}/tests", options
      end

    end
  end
end
