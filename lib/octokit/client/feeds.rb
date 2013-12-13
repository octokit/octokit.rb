module Octokit
  class Client

    # Methods for the Feeds API
    #
    # @see http://developer.github.com/v3/activity/feeds/
    module Feeds

      # List Feeds
      #
      # The feeds returned depend on authentication, see the GitHub API docs
      # for more information.
      #
      # @return [Array<Sawyer::Resource>] list of feeds
      # @see http://developer.github.com/v3/activity/feeds/#list-feeds
      def feeds
        get "feeds"
      end

    end
  end
end
