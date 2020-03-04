# frozen_string_literal: true

module Octokit
  class Client
    # Methods for the Hooks API
    #
    # @see https://developer.github.com/v3/orgs/hooks/
    module Hooks
      # Get single hook
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @param hook_id [Integer] The ID of the hook
      # @return [Sawyer::Resource] A single hook
      # @see https://developer.github.com/v3/repos/hooks/#get-single-hook
      def hook(repo, hook_id, options = {})
        get "#{Repository.path repo}/hooks/#{hook_id}", options
      end

      # List hooks
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @return [Array<Sawyer::Resource>] A list of hooks
      # @see https://developer.github.com/v3/repos/hooks/#list-hooks
      def hooks(repo, options = {})
        paginate "#{Repository.path repo}/hooks", options
      end

      # Create a hook
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @param config [Object] Key/value pairs to provide settings for this webhook. These are defined below (https://developer.github.com/v3/repos/hooks/#create-hook-config-params).
      # @option options [String] :name Use web to create a webhook. Default: web. This parameter only accepts the value web.
      # @option options [Array] :events Determines what events (https://developer.github.com/v3/activity/events/types/) the hook is triggered for.
      # @option options [Boolean] :active Determines if notifications are sent when the webhook is triggered. Set to true to send notifications.
      # @return [Sawyer::Resource] The new hook
      # @see https://developer.github.com/v3/repos/hooks/#create-a-hook
      def create_hook(repo, config = {}, options = {})
        opts = options
        opts[:config] = config
        fail Octokit::MissingKey.new unless config.key? :url
        post "#{Repository.path repo}/hooks", opts
      end

      # Edit a hook
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @param hook_id [Integer] The ID of the hook
      # @option options [Object] :config Key/value pairs to provide settings for this webhook. These are defined below (https://developer.github.com/v3/repos/hooks/#create-hook-config-params).
      # @option options [Array] :events Determines what events (https://developer.github.com/v3/activity/events/types/) the hook is triggered for. This replaces the entire array of events.
      # @option options [Array] :add_events Determines a list of events to be added to the list of events that the Hook triggers for.
      # @option options [Array] :remove_events Determines a list of events to be removed from the list of events that the Hook triggers for.
      # @option options [Boolean] :active Determines if notifications are sent when the webhook is triggered. Set to true to send notifications.
      # @return [Sawyer::Resource] The updated hook
      # @see https://developer.github.com/v3/repos/hooks/#edit-a-hook
      def update_hook(repo, hook_id, options = {})
        patch "#{Repository.path repo}/hooks/#{hook_id}", options
      end

      # Delete a hook
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @param hook_id [Integer] The ID of the hook
      # @return [Boolean] True on success, false otherwise
      # @see https://developer.github.com/v3/repos/hooks/#delete-a-hook
      def delete_hook(repo, hook_id, options = {})
        boolean_from_response :delete, "#{Repository.path repo}/hooks/#{hook_id}", options
      end

      # Test a push hook
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @param hook_id [Integer] The ID of the hook
      # @return [Boolean] True on success, false otherwise
      # @see https://developer.github.com/v3/repos/hooks/#test-a-push-hook
      def test_push_hook(repo, hook_id, options = {})
        boolean_from_response :post, "#{Repository.path repo}/hooks/#{hook_id}/tests", options
      end

      # Ping a hook
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @param hook_id [Integer] The ID of the hook
      # @return [Boolean] True on success, false otherwise
      # @see https://developer.github.com/v3/repos/hooks/#ping-a-hook
      def ping_hook(repo, hook_id, options = {})
        boolean_from_response :post, "#{Repository.path repo}/hooks/#{hook_id}/pings", options
      end

      # Get single org hook
      #
      # @param org [Integer, String] A GitHub organization id or login
      # @param hook_id [Integer] The ID of the hook
      # @return [Sawyer::Resource] A single hook
      # @see https://developer.github.com/v3/orgs/hooks/#get-single-hook
      def org_hook(org, hook_id, options = {})
        get "#{Organization.path org}/hooks/#{hook_id}", options
      end

      # List org hooks
      #
      # @param org [Integer, String] A GitHub organization id or login
      # @return [Array<Sawyer::Resource>] A list of hooks
      # @see https://developer.github.com/v3/orgs/hooks/#list-hooks
      def org_hooks(org, options = {})
        paginate "#{Organization.path org}/hooks", options
      end

      # Create an org hook
      #
      # @param org [Integer, String] A GitHub organization id or login
      # @param name [String] Must be passed as "web".
      # @param config [Object] Key/value pairs to provide settings for this webhook. These are defined below (https://developer.github.com/v3/orgs/hooks/#create-hook-config-params).
      # @option options [Array] :events Determines what events (https://developer.github.com/v3/activity/events/types/) the hook is triggered for.
      # @option options [Boolean] :active Determines if notifications are sent when the webhook is triggered. Set to true to send notifications.
      # @return [Sawyer::Resource] The new hook
      # @see https://developer.github.com/v3/orgs/hooks/#create-a-hook
      def create_org_hook(org, name, config = {}, options = {})
        opts = options
        opts[:name] = name
        opts[:config] = config
        fail Octokit::MissingKey.new unless config.key? :url
        post "#{Organization.path org}/hooks", opts
      end

      # Edit an org hook
      #
      # @param org [Integer, String] A GitHub organization id or login
      # @param hook_id [Integer] The ID of the hook
      # @option options [Object] :config Key/value pairs to provide settings for this webhook. These are defined below (https://developer.github.com/v3/orgs/hooks/#update-hook-config-params).
      # @option options [Array] :events Determines what events (https://developer.github.com/v3/activity/events/types/) the hook is triggered for.
      # @option options [Boolean] :active Determines if notifications are sent when the webhook is triggered. Set to true to send notifications.
      # @return [Sawyer::Resource] The updated hook
      # @see https://developer.github.com/v3/orgs/hooks/#edit-a-hook
      def update_org_hook(org, hook_id, options = {})
        patch "#{Organization.path org}/hooks/#{hook_id}", options
      end

      # Delete an org hook
      #
      # @param org [Integer, String] A GitHub organization id or login
      # @param hook_id [Integer] The ID of the hook
      # @return [Boolean] True on success, false otherwise
      # @see https://developer.github.com/v3/orgs/hooks/#delete-a-hook
      def delete_org_hook(org, hook_id, options = {})
        boolean_from_response :delete, "#{Organization.path org}/hooks/#{hook_id}", options
      end

      # Ping an org hook
      #
      # @param org [Integer, String] A GitHub organization id or login
      # @param hook_id [Integer] The ID of the hook
      # @return [Boolean] True on success, false otherwise
      # @see https://developer.github.com/v3/orgs/hooks/#ping-a-hook
      def ping_org_hook(org, hook_id, options = {})
        boolean_from_response :post, "#{Organization.path org}/hooks/#{hook_id}/pings", options
      end
    end
  end
end
