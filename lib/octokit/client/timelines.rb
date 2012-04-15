module Octokit
  class Client
    module Timelines
      def timeline(options={})
        warn 'DEPRECATED: Please use Octokit.public_events instead.'
        path = "/timeline.json"
        get(path, options, 2, false)
      end

      def user_timeline(username=login, options={})
        warn 'DEPRECATED: Please use Octokit.user_events instead.'
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
