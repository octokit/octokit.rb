module Octokit
  class Client
    module Timelines
      def timeline(options={})
        path = "/timeline.json"
        get(path, options, 2, false)
      end

      def user_timeline(username=login, options={})
        if authenticated?
          path = "/#{username}.private.json"
        else
          path = "/#{username}.json"
        end
        get(path, options, 2, false)
      end
    end
  end
end
