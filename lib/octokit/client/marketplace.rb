module Octokit
  class Client

    # Methods for the Marketplace Listing API
    #
    # @see https://developer.github.com/v3/apps/marketplace/
    module Marketplace

      # List all plans for an app's marketplace listing
      #
      # @param options [Hash] An customizable set of options
      #
      # @see https://developer.github.com/v3/apps/marketplace/#list-all-plans-for-your-marketplace-listing
      #
      # @return [Array<Sawyer::Resource>] A list of plans
      def list_plans(options = {})
        opts = ensure_api_media_type(:marketplace, options)
        paginate "/marketplace_listing/plans", opts
      end

      # List all GitHub accounts on a specific plan
      #
      # @param options [Hash] An customizable set of options
      #
      # @see https://developer.github.com/v3/apps/marketplace/#list-all-github-accounts-user-or-organization-on-a-specific-plan
      #
      # @return [Array<Sawyer::Resource>] A list of accounts
      def list_accounts_for_plan(plan, options = {})
        opts = ensure_api_media_type(:marketplace, options)
        paginate "/marketplace_listing/plans/#{plan}/accounts", opts
      end

      # Get the plan associated with a given GitHub account
      #
      # @param options [Hash] An customizable set of options
      #
      # @see https://developer.github.com/v3/apps/marketplace/#check-if-a-github-account-is-associated-with-any-marketplace-listing
      #
      # @return <Sawyer::Resource> Account with plan details, or nil
      def plan_for_account(account_id, options = {})
        opts = ensure_api_media_type(:marketplace, options)
        get "/marketplace_listing/accounts/#{account_id}", opts
      end
    end
  end
end
