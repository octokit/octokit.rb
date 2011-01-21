module Octokit
  class Client
    module Timelines

      def timeline(options={})
        path = "https://github.com/timeline.json"
        get(path, options, false, false, false)
      end

      def user_timeline(username=login, options={})
        if token
          path = "https://github.com/#{username}.private.json"
          options[:token] = token
        else
          path = "https://github.com/#{username}.json"
        end
        get(path, options, false, false, false)
      end

    end
  end
end
