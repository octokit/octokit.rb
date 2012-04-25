module Octokit
  class Client
    module Users

      EMAIL_RE = /[\w.!#\$%+-]+@[\w-]+(?:\.[\w-]+)+/
      def search_users(search, options={})
        if search.match(EMAIL_RE)
          warn 'DEPRECATED: V3 of the API does not allow searching users by email'
          get("/api/v2/json/user/email/#{search}", options, 2)['user']
        else
          get("/legacy/user/search/#{search}", options, 3)['users']
        end
      end

      # Get a single user
      #
      # @param user [String] A GitHub user name.
      # @return [Hashie::Mash]
      # @example
      #   Octokit.user("sferik")
      def user(user=nil)
        if user
          get("/users/#{user}", {}, 3)
        else
          get("/user", {}, 3)
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
        patch("/user", options, 3)
      end

      def followers(user=login, options={})
        get("/users/#{user}/followers", options, 3)
      end

      def following(user=login, options={})
        get("/users/#{user}/following", options, 3)
      end

      def follows?(*args)
        target = args.pop
        user = args.first
        user ||= login
        return if user.nil?
        get("/user/following/#{target}", {}, 3, true, raw=true).status == 204
      rescue Octokit::NotFound
        false
      end

      def follow(user, options={})
        put("/user/following/#{user}", options, 3, true, raw=true).status == 204
      end

      def unfollow(user, options={})
        delete("/user/following/#{user}", options, 3, true, raw=true).status == 204
      end

      def watched(user=login, options={})
        get("/users/#{user}/watched", options, 3)
      end

      # Not yet supported: get a single key, update an existing key

      def keys(options={})
        get("/user/keys", options, 3)
      end

      def add_key(title, key, options={})
        post("/user/keys", options.merge({:title => title, :key => key}), 3)
      end

      def remove_key(id, options={})
        delete("/user/keys/#{id}", options, 3, true, raw=true)
      end

      def emails(options={})
        get("/user/emails", options, 3)
      end

      def add_email(email, options={})
        post("/user/emails", options.merge({:email => email}), 3)
      end

      def remove_email(email, options={})
        delete("/user/emails", options.merge({:email => email}), 3, true, raw=true).status == 204
      end
    end
  end
end
