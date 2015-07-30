module Octokit
  class EnterpriseAdminClient

    # Methods for the Enterprise User Administration API
    #
    # @see https://developer.github.com/v3/users/administration/
    module Users
      # Create a new user.
      #
      # @param login [String] The user's username.
      # @param email [String] The user's email address.
      # @see https://developer.github.com/v3/users/administration/#create-a-new-user
      # @example
      #   @admin_client.promote('foobar', 'notreal@foo.bar')
      def create(login, email, options = {})
        options[:login] = login
        options[:email] = email
        boolean_from_response :post, "admin/users", options
      end

      # Promote an ordinary user to a site administrator
      #
      # @param user [String] Username of the user to promote.
      # @return [Boolean] True if promote was successful, false otherwise.
      # @see https://developer.github.com/v3/users/administration/#promote-an-ordinary-user-to-a-site-administrator
      # @example
      #   @admin_client.promote('holman')
      def promote(user, options = {})
        boolean_from_response :put, "users/#{user}/site_admin", options
      end

      # Demote a site administrator to an ordinary user
      #
      # @param user [String] Username of the user to demote.
      # @return [Boolean] True if demote was successful, false otherwise.
      # @see https://developer.github.com/v3/users/administration/#demote-a-site-administrator-to-an-ordinary-user
      # @example
      #   @admin_client.demote('holman')
      def demote(user, options = {})
        boolean_from_response :delete, "users/#{user}/site_admin", options
      end

      # Rename a user.
      #
      # @param old_login [String] The user's old username.
      # @param new_login [String] The user's new username.
      # @see https://developer.github.com/v3/users/administration/#rename-an-existing-user
      # @example
      #   @admin_client.rename('foobar', 'foofoobar')
      def rename(old_login, new_login, options = {})
        options[:login] = new_login
        boolean_from_response :patch, "admin/users/#{old_login}", options
      end

      # Suspend a user.
      #
      # @param user [String] Username of the user to suspend.
      # @return [Boolean] True if suspend was successful, false otherwise.
      # @see https://developer.github.com/v3/users/administration/#suspend-a-user
      # @example
      #   @admin_client.suspend('holman')
      def suspend(user, options = {})
        boolean_from_response :put, "users/#{user}/suspended", options
      end

      # Unsuspend a user.
      #
      # @param user [String] Username of the user to unsuspend.
      # @return [Boolean] True if unsuspend was successful, false otherwise.
      # @see https://developer.github.com/v3/users/administration/#unsuspend-a-user
      # @example
      #   @admin_client.unsuspend('holman')
      def unsuspend(user, options = {})
        boolean_from_response :delete, "users/#{user}/suspended", options
      end
    end
  end
end
