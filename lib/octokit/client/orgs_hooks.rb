# frozen_string_literal: true

module Octokit
  class Client
    # Methods for the OrgsHooks API
    #
    # @see https://developer.github.com/v3/orgs/hooks/
    module OrgsHooks
      # Get an organization org webhook
      #
      # @param org [Integer, String] A GitHub organization id or login
      # @param hook_id [Integer] The ID of the hook
      # @return [Sawyer::Resource] A single webhook
      # @see https://developer.github.com/v3/orgs/hooks/#get-an-organization-webhook
      def org_webhook(org, hook_id, options = {})
        get "#{Organization.path org}/hooks/#{hook_id}", options
      end

      # List organization org webhooks
      #
      # @param org [Integer, String] A GitHub organization id or login
      # @return [Array<Sawyer::Resource>] A list of webhooks
      # @see https://developer.github.com/v3/orgs/hooks/#list-organization-webhooks
      def org_webhooks(org, options = {})
        paginate "#{Organization.path org}/hooks", options
      end

      # Create an organization org webhook
      #
      # @param org [Integer, String] A GitHub organization id or login
      # @param name [String] Must be passed as "web".
      # @param config [Object] Key/value pairs to provide settings for this webhook. These are defined below (https://developer.github.com/v3/orgs/hooks/#create-hook-config-params).
      # @option options [Array] :events Determines what events (https://developer.github.com/webhooks/event-payloads) the hook is triggered for.
      # @option options [Boolean] :active Determines if notifications are sent when the webhook is triggered. Set to true to send notifications.
      # @return [Sawyer::Resource] The new webhook
      # @see https://developer.github.com/v3/orgs/hooks/#create-an-organization-webhook
      def create_org_webhook(org, name, config = {}, options = {})
        opts = options.dup
        opts[:name] = name
        opts[:config] = config
        raise Octokit::MissingKey unless config.key? :url

        post "#{Organization.path org}/hooks", opts
      end

      # Update an organization org webhook
      #
      # @param org [Integer, String] A GitHub organization id or login
      # @param hook_id [Integer] The ID of the hook
      # @option options [Object] :config Key/value pairs to provide settings for this webhook. These are defined below (https://developer.github.com/v3/orgs/hooks/#update-hook-config-params).
      # @option options [Array] :events Determines what events (https://developer.github.com/webhooks/event-payloads) the hook is triggered for.
      # @option options [Boolean] :active Determines if notifications are sent when the webhook is triggered. Set to true to send notifications.
      # @return [Sawyer::Resource] The updated webhook
      # @see https://developer.github.com/v3/orgs/hooks/#update-an-organization-webhook
      def update_org_webhook(org, hook_id, options = {})
        patch "#{Organization.path org}/hooks/#{hook_id}", options
      end

      # Delete an organization org webhook
      #
      # @param org [Integer, String] A GitHub organization id or login
      # @param hook_id [Integer] The ID of the hook
      # @return [Boolean] True on success, false otherwise
      # @see https://developer.github.com/v3/orgs/hooks/#delete-an-organization-webhook
      def delete_org_webhook(org, hook_id, options = {})
        boolean_from_response :delete, "#{Organization.path org}/hooks/#{hook_id}", options
      end

      # Ping an organization org webhook
      #
      # @param org [Integer, String] A GitHub organization id or login
      # @param hook_id [Integer] The ID of the hook
      # @return [Boolean] True on success, false otherwise
      # @see https://developer.github.com/v3/orgs/hooks/#ping-an-organization-webhook
      def ping_org_webhook(org, hook_id, options = {})
        boolean_from_response :post, "#{Organization.path org}/hooks/#{hook_id}/pings", options
      end
    end
  end
end
