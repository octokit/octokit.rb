module Octokit
  class EnterpriseAdminClient < Octokit::Client

    # Methods for the Enterprise License API
    #
    # @see https://enterprise.github.com/help/articles/license-api
    module License

      # Get information about the Enterprise license
      #
      # @return [Sawyer::Resource] The license information
      def license
        get "enterprise/settings/license"
      end

    end
  end
end
