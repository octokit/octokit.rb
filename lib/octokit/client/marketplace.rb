module Octokit
  class Client

    # Methods for the Marketplace API
    module Marketplace

      # Get a user's Marketplace purchases
      #
      # @param options [Hash] An customizable set of options
      #
      # @see https://developer.github.com/v3/apps/marketplace/#get-a-users-marketplace-purchases
      #
      # @return [Array<Sawyer::Resource>] A list of a user's Marketplace purchases
      def find_app_marketplace_purchases(options = {})
        opts = ensure_api_media_type(:marketplace, options)
        get "/user/marketplace_purchases", opts
      end
    end
  end
end
