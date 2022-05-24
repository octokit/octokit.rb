# frozen_string_literal: true

module Octokit
  class Client
    # Methods for the ActivityFeeds API
    #
    # @see https://developer.github.com/v3/activity/feeds/
    module ActivityFeeds
      # Get feeds
      #
      #
      # @return [Sawyer::Resource] A single feeds
      # @see https://developer.github.com/v3/activity/feeds/#get-feeds
      def feeds(options = {})
        get 'feeds', options
      end
    end
  end
end
