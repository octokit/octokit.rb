module Octokit
  class EnterpriseAdminClient < Octokit::Client

    # Methods for the Enterprise Management Console API
    #
    # @see https://enterprise.github.com/help/articles/license-api
    module ManagementConsole

      # Get information about the Enterprise installation
      #
      # @return [Sawyer::Resource] The installation information
      def config_status
        get "/setup/api/configcheck", license_hash
      end
      alias :config_check :config_status

      # Get information about the Enterprise installation
      #
      # @return [Sawyer::Resource] The installation information
      def settings
        get "/setup/api/settings", license_hash
      end
      alias :get_settings :settings

private

      def license_hash
        { :query => { :license_md5 => @license_md5 } }
      end
    end

  end
end
