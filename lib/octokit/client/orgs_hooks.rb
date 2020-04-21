# frozen_string_literal: true

module Octokit
  class Client
    # Methods for the OrgsHooks API
    #
    # @see https://developer.github.com/v3/orgs/hooks/
    module OrgsHooks
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
        opts = options.dup
        opts[:name] = name
        opts[:config] = config
        raise Octokit::MissingKey unless config.key? :url

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
