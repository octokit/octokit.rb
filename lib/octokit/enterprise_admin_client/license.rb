module Octokit
  class EnterpriseAdminClient < Octokit::Client

    # Methods for the (Enterprise) License API
    #
    # @see https://enterprise.github.com/help/articles/license-api
    module Licensing

      # Get information about the Enterprise license
      #
      # @return [Sawyer::Resource] The license information
      def license
        get "api/v3/enterprise/settings/license"
      end

    end
  end
end
