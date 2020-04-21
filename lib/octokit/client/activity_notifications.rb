# frozen_string_literal: true

module Octokit
  class Client
    # Methods for the ActivityNotifications API
    #
    # @see https://developer.github.com/v3/activity/notifications/
    module ActivityNotifications
      # List notifications for the authenticated user
      #
      # @option options [Boolean] :all If true, show notifications marked as read.
      # @option options [Boolean] :participating If true, only shows notifications in which the user is directly participating or mentioned.
      # @option options [String] :since Only show notifications updated after the given time. This is a timestamp in ISO 8601 (https://en.wikipedia.org/wiki/ISO_8601) format: YYYY-MM-DDTHH:MM:SSZ.
      # @option options [String] :before Only show notifications updated before the given time. This is a timestamp in ISO 8601 (https://en.wikipedia.org/wiki/ISO_8601) format: YYYY-MM-DDTHH:MM:SSZ.
      # @return [Array<Sawyer::Resource>] A list of notifications
      # @see https://developer.github.com/v3/activity/notifications/#list-notifications-for-the-authenticated-user
      def user_notifications(options = {})
        paginate 'notifications', options
      end

      # Mark notifications as read
      #
      # @option options [String] :last_read_at Describes the last point that notifications were checked. Anything updated since this time will not be marked as read. If you omit this parameter, all notifications are marked as read. This is a timestamp in ISO 8601 (https://en.wikipedia.org/wiki/ISO_8601) format: YYYY-MM-DDTHH:MM:SSZ. Default: The current timestamp.
      # @return [Boolean] True on success, false otherwise
      # @see https://developer.github.com/v3/activity/notifications/#mark-notifications-as-read
      def mark_notifications_as_read(options = {})
        boolean_from_response :put, 'notifications', options
      end

      # Get a thread
      #
      # @param thread_id [Integer] The ID of the thread
      # @return [Sawyer::Resource] A single thread
      # @see https://developer.github.com/v3/activity/notifications/#get-a-thread
      def thread(thread_id, options = {})
        get "notifications/threads/#{thread_id}", options
      end

      # Mark a thread as read
      #
      # @param thread_id [Integer] The ID of the thread
      # @return [Boolean] True on success, false otherwise
      # @see https://developer.github.com/v3/activity/notifications/#mark-a-thread-as-read
      def mark_thread_as_read(thread_id, options = {})
        boolean_from_response :patch, "notifications/threads/#{thread_id}", options
      end

      # Get a thread subscription for the authenticated user
      #
      # @param thread_id [Integer] The ID of the thread
      # @return [Sawyer::Resource] A single subscription
      # @see https://developer.github.com/v3/activity/notifications/#get-a-thread-subscription-for-the-authenticated-user
      def user_thread_subscription(thread_id, options = {})
        get "notifications/threads/#{thread_id}/subscription", options
      end

      # Set a thread subscription
      #
      # @param thread_id [Integer] The ID of the thread
      # @option options [Boolean] :ignored Unsubscribes and subscribes you to a conversation. Set ignored to true to block all notifications from this thread.
      # @return [Sawyer::Resource] The updated activity
      # @see https://developer.github.com/v3/activity/notifications/#set-a-thread-subscription
      def set_thread_subscription(thread_id, options = {})
        put "notifications/threads/#{thread_id}/subscription", options
      end

      # Delete a thread subscription
      #
      # @param thread_id [Integer] The ID of the thread
      # @return [Boolean] True on success, false otherwise
      # @see https://developer.github.com/v3/activity/notifications/#delete-a-thread-subscription
      def delete_thread_subscription(thread_id, options = {})
        boolean_from_response :delete, "notifications/threads/#{thread_id}/subscription", options
      end

      # List repository notifications for the authenticated user
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @option options [Boolean] :all If true, show notifications marked as read.
      # @option options [Boolean] :participating If true, only shows notifications in which the user is directly participating or mentioned.
      # @option options [String] :since Only show notifications updated after the given time. This is a timestamp in ISO 8601 (https://en.wikipedia.org/wiki/ISO_8601) format: YYYY-MM-DDTHH:MM:SSZ.
      # @option options [String] :before Only show notifications updated before the given time. This is a timestamp in ISO 8601 (https://en.wikipedia.org/wiki/ISO_8601) format: YYYY-MM-DDTHH:MM:SSZ.
      # @return [Array<Sawyer::Resource>] A list of notifications
      # @see https://developer.github.com/v3/activity/notifications/#list-repository-notifications-for-the-authenticated-user
      def user_repo_notifications(repo, options = {})
        paginate "#{Repository.path repo}/notifications", options
      end

      # Mark repository notifications as read
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @option options [String] :last_read_at Describes the last point that notifications were checked. Anything updated since this time will not be marked as read. If you omit this parameter, all notifications are marked as read. This is a timestamp in ISO 8601 (https://en.wikipedia.org/wiki/ISO_8601) format: YYYY-MM-DDTHH:MM:SSZ. Default: The current timestamp.
      # @return [Boolean] True on success, false otherwise
      # @see https://developer.github.com/v3/activity/notifications/#mark-repository-notifications-as-read
      def mark_repo_notifications_as_read(repo, options = {})
        boolean_from_response :put, "#{Repository.path repo}/notifications", options
      end
    end
  end
end
