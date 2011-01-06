module Octokit
  class Client
    module Users
      EMAIL_RE = /[\w.!#\$%+-]+@[\w-]+(?:\.[\w-]+)+/

      def search_users(search, options={})
        if search.match(EMAIL_RE)
          get("user/email/#{search}", options)
        else
          get("user/search/#{search}", options)
        end['users']
      end

      def user(username=nil, options={})
        get(["user/show", username].compact.join('/'), options)['user']
      end

      def update_user(values, options={})
        post("user/show/#{login}", options.merge({:values => values}))['user']
      end

      def followers(user=login, options={})
        get("user/show/#{user}/followers", options)['users']
      end

      def following(user=login, options={})
        get("user/show/#{user}/following", options)['users']
      end

      def follows?(*args)
        target = args.pop
        user = args.first
        user ||= login
        return if user.nil?
        following(user).include?(target)
      end

      def follow!(user, options={})
        post("user/follow/#{user}", options)['users']
      end
      alias :follow :follow!

      def unfollow!(user, options={})
        post("user/unfollow/#{user}", options)['users']
      end
      alias :unfollow :unfollow!

      def watched(user=login, options={})
        get("repos/watched/#{user}", options)['repositories']
      end

      def keys(options={})
        get("user/keys", options)['public_keys']
      end

      def add_key(title, key, options={})
        post("user/key/add", options.merge({:title => title, :key => key}))['public_keys']
      end

      def remove_key(id, options={})
        post("user/key/remove", options.merge({:id => id}))['public_keys']
      end

      def emails(options={})
        get("user/emails", options)['emails']
      end

      def add_email(email, options={})
        post("user/email/add", options.merge({:email => email}))['emails']
      end

      def remove_email(email, options={})
        post("user/email/remove", options.merge({:email => email}))['emails']
      end
    end
  end
end
