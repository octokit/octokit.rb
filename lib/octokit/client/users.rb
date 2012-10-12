module Octokit
  class Client
    #@todo Add support for getting a single public key by id.
    #  http://developer.github.com/v3/users/keys/#get-a-single-public-key
    #@todo Add support for updating a public key.
    #  http://developer.github.com/v3/users/keys/#update-a-public-key
    module Users

      # Search for user.
      #
      # @param search [String] User to search for.
      # @return [Array<Hashie::Mash>] Array of hashes representing users.
      # @see http://developer.github.com/v3/search/#search-users
      # @example
      #   Octokit.search_users('pengwynn')
      def search_users(search, options={})
        get("legacy/user/search/#{search}", options, 3)['users']
      end

      # Get a single user
      #
      # @param user [String] A GitHub user name.
      # @return [Hashie::Mash]
      # @see http://developer.github.com/v3/users/#get-a-single-user
      # @example
      #   Octokit.user("sferik")
      def user(user=nil)
        if user
          get("users/#{user}", {}, 3)
        else
          get("user", {}, 3)
        end
      end

      # Update the authenticated user
      #
      # @param options [Hash] A customizable set of options.
      # @option options [String] :name
      # @option options [String] :email Publically visible email address.
      # @option options [String] :blog
      # @option options [String] :company
      # @option options [String] :location
      # @option options [Boolean] :hireable
      # @option options [String] :bio
      # @return [Hashie::Mash]
      # @example
      #   Octokit.user(:name => "Erik Michaels-Ober", :email => "sferik@gmail.com", :company => "Code for America", :location => "San Francisco", :hireable => false)
      def update_user(options)
        patch("user", options, 3)
      end

      # Get a user's followers.
      #
      # @param user [String] Username of the user whose list of followers you are getting.
      # @return [Array<Hashie::Mash>] Array of hashes representing users followers.
      # @see http://developer.github.com/v3/users/followers/#list-followers-of-a-user
      # @example
      #   Octokit.followers('pengwynn')
      def followers(user=login, options={})
        get("users/#{user}/followers", options, 3)
      end

      # Get list of users a user is following.
      #
      # @param user [String] Username of the user who you are getting the list of the people they follow.
      # @return [Array<Hashie::Mash>] Array of hashes representing users a user is following.
      # @see  http://developer.github.com/v3/users/followers/#list-users-following-another-user
      # @example
      #   Octokit.following('pengwynn')
      def following(user=login, options={})
        get("users/#{user}/following", options, 3)
      end

      # Check if you are following a user.
      #
      # Requries an authenticated client.
      # 
      # @param user [String] Username of the user that you want to check if you are following.
      # @return [Boolean] True if you are following the user, false otherwise.
      # @see Octokit::Client
      # @see http://developer.github.com/v3/users/followers/#check-if-you-are-following-a-user
      # @example
      #   @client.follows?('pengwynn')
      def follows?(*args)
        target = args.pop
        user = args.first
        user ||= login
        return if user.nil?
        get("user/following/#{target}", {}, 3, true, raw=true).status == 204
      rescue Octokit::NotFound
        false
      end

      # Follow a user.
      #
      # Requires authenticatied client.
      #
      # @param user [String] Username of the user to follow.
      # @return [Boolean] True if follow was successful, false otherwise.
      # @see Octokit::Client
      # @see http://developer.github.com/v3/users/followers/#follow-a-user
      # @example
      #   @client.follow('holman')
      def follow(user, options={})
        put("user/following/#{user}", options, 3, true, raw=true).status == 204
      end

      # Unfollow a user.
      #
      # Requires authenticated client.
      #
      # @param user [String] Username of the user to unfollow.
      # @return [Boolean] True if unfollow was successful, false otherwise.
      # @see Octokit::Client
      # @see http://developer.github.com/v3/users/followers/#unfollow-a-user
      # @example
      #   @client.unfollow('holman')
      def unfollow(user, options={})
        delete("user/following/#{user}", options, 3, true, raw=true).status == 204
      end

      # Get list of repos starred by a user.
      #
      # @param user [String] Username of the user to get the list of their starred repositories.
      # @return [Array<Hashie::Mash>] Array of hashes representing repositories starred by user.
      # @see http://developer.github.com/v3/repos/starring/#list-repositories-being-starred
      # @example
      #   Octokit.starred('pengwynn')
      def starred(user=login, options={})
        get("users/#{user}/starred", options, 3)
      end

      # Check if you are starring a repo.
      #
      # Requires authenticated client.
      #
      # @param user [String] Username of repository owner.
      # @param repo [String] Name of the repository.
      # @return [Boolean] True if you are following the repo, false otherwise.
      # @see Octokit::Client
      # @see http://developer.github.com/v3/repos/starring/#check-if-you-are-starring-a-repository
      # @example
      #   @client.starred?('pengwynn', 'octokit')
      def starred?(user, repo, options={})
        get("user/starred/#{user}/#{repo}", options, 3, true, raw=true).status == 204
      rescue Octokit::NotFound
        false
      end

      # Get list of repos watched by a user.
      # 
      # Legacy, using github.beta media type. Use `Users#starred` instead.
      #
      # @param user [String] Username of the user to get the list of repositories they are watching.
      # @return [Array<Hashie::Mash>] Array of hashes representing repositories watched by user.
      # @see Users#starred
      # @see http://developer.github.com/v3/repos/starring/#list-stargazers
      # @example
      #   Octokit.watched('pengwynn')
      def watched(user=login, options={})
        get("users/#{user}/watched", options, 3)
      end

      # Get list of public keys for user.
      #
      # Requires authenticated client.
      #
      # @return [Array<Hashie::Mash>] Array of hashes representing public keys.
      # @see Octokit::Client
      # @see http://developer.github.com/v3/users/keys/#list-public-keys-for-a-user
      # @example
      #   @client.keys
      def keys(options={})
        get("user/keys", options, 3)
      end

      # Add public key to user account.
      #
      # Requires authenticated client.
      #
      # @param title [String] Title to give reference to the public key.
      # @param key [String] Public key.
      # @return [Hashie::Mash] Hash representing the newly added public key.
      # @see Octokit::Client
      # @see http://developer.github.com/v3/users/keys/#create-a-public-key
      # @example
      #   @client.add_key('Personal projects key', 'ssh-rsa AAA...')
      def add_key(title, key, options={})
        post("user/keys", options.merge({:title => title, :key => key}), 3)
      end

      # Remove a public key from user account.
      #
      # Requires authenticated client.
      #
      # @param id [String] Id of the public key to remove.
      # @return [Boolean] True if removal was successful, false otherwise.
      # @see Octokit::Client
      # @see http://developer.github.com/v3/users/keys/#delete-a-public-key
      # @example
      #   @client.remove_key(1)
      def remove_key(id, options={})
        delete("user/keys/#{id}", options, 3, true, raw=true)
      end

      # List email addresses for a user.
      #
      # Requires authenticated client.
      #
      # @return [Array<String>] Array of email addresses.
      # @see Octokit::Client
      # @see http://developer.github.com/v3/users/emails/#list-email-addresses-for-a-user
      # @example
      #   @client.emails
      def emails(options={})
        get("user/emails", options, 3)
      end

      # Add email address to user.
      #
      # Requires authenticated client.
      #
      # @param email [String] Email address to add to the user.
      # @return [Array<String>] Array of all email addresses of the user.
      # @see Octokit::Client
      # @see http://developer.github.com/v3/users/emails/#add-email-addresses
      # @example
      #   @client.add_email('new_email@user.com')
      def add_email(email, options={})
        post("user/emails", options.merge({:email => email}), 3)
      end

      # Remove email from user.
      #
      # Requires authenticated client.
      #
      # @param email [String] Email address to remove.
      # @return [Array<String>] Array of all email addresses of the user.
      # @see Octokit::Client
      # @see http://developer.github.com/v3/users/emails/#delete-email-addresses
      # @example
      #   @client.remove_email('old_email@user.com')
      def remove_email(email, options={})
        delete("user/emails", options.merge({:email => email}), 3, true, raw=true).status == 204
      end
    end
  end
end
