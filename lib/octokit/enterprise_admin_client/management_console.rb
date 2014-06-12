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
      # @return [Sawyer::Resource] The settings
      def settings
        get "/setup/api/settings", license_hash
      end
      alias :get_settings :settings

      # Get information about the Enterprise maintenance status
      #
      # @return [Sawyer::Resource] The maintenance status
      def maintenance_status
        get "/setup/api/maintenance", license_hash
      end
      alias :get_maintenance_status :maintenance_status

private

      def license_hash
        { :query => { :license_md5 => @license_md5 } }
      end
    end

  end
end
