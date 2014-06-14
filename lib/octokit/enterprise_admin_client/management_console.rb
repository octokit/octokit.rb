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

      # Start (or turn off) the Enterprise maintenance mode
      #
      # @param maintenance [Hash] A hash configuration of the maintenance settings
      # @return [nil]
      def set_maintenance_status(maintenance)
        queries = license_hash
        queries[:query][:maintenance] = "#{maintenance.to_json}"
        post "/setup/api/maintenance", queries
      end
      alias :edit_maintenance_status :set_maintenance_status

      # Fetch the authorized SSH keys on the Enterprise install
      #
      # @return [Sawyer::Resource] An array of authorized SSH keys
      def authorized_keys
        get "/setup/api/settings/authorized-keys", license_hash
      end
      alias :get_authorized_keys :authorized_keys

      # Add an authorized SSH keys on the Enterprise install
      #
      # @param key Either the file path to a key, a File handler to the key, or the contents of the key itself
      # @return [Sawyer::Resource] An array of authorized SSH keys
      def add_authorized_key(key)
        queries = license_hash
        case key
        when String
          if File.exist?(key)
            key = File.open(key, "r")
            content = key.read.strip
            key.close
          else
            content = key
          end
        when File
          content = key.read.strip
          key.close
        end

        queries[:query][:authorized_key] = content
        post "/setup/api/settings/authorized-keys", queries
      end

      # Removes an authorized SSH keys from the Enterprise install
      #
      # @param key Either the file path to a key, a File handler to the key, or the contents of the key itself
      # @return [Sawyer::Resource] An array of authorized SSH keys
      def remove_authorized_key(key)
        queries = license_hash
        case key
        when String
          if File.exist?(key)
            key = File.open(key, "r")
            content = key.read.strip
            key.close
          else
            content = key
          end
        when File
          content = key.read.strip
          key.close
        end

        queries[:query][:authorized_key] = content
        delete "/setup/api/settings/authorized-keys", queries
      end
      alias :delete_authorized_key :remove_authorized_key

private

      def license_hash
        { :query => { :license_md5 => @license_md5 } }
      end
    end

  end
end
