# frozen_string_literal: true

module Octokit
  class ManageGHESClient
    # Methods for the Manage GitHub Enterprise Server API
    #
    # @see https://developer.github.com/v3/enterprise-admin/manage-ghes
    module ManageAPI
      # Get information about the maintenance status of the GHES instance
      #
      # @return [Sawyer::Resource] The maintenance mode status
      def get_maintenance_mode
        get '/manage/v1/maintenance'
      end
      alias maintenance_mode get_maintenance_mode

      # Configure the maintenance mode of the GHES instance
      #
      # @param maintenance [Hash] A hash configuration of the maintenance mode status
      # @return [nil]
      def set_maintenance_mode(enabled, options = {})
        options[:enabled] = enabled
        post '/manage/v1/maintenance', options
      end
      alias configure_maintenance_mode set_maintenance_mode
    end
  
    private

    def basic_authenticated?
      !!(@manage_ghes_username && @manage_ghes_password)
    end

    def root_site_admin_assumed?
      !!(@manage_ghes_username)
    end

    def faraday_configuration
      @faraday_configuration ||= Faraday.new(url: @manage_ghes_endpoint) do |c|
        c.headers[:user_agent] = user_agent
        c.request  :json
        c.response :json

        if root_site_admin_assumed?
          c.basic_auth('api_key', @manage_ghes_password)
        elsif basic_authenticated?
          c.basic_auth(@manage_ghes_username, @manage_ghes_password)
        end

        # Disabling SSL is essential for certain self-hosted Enterprise instances
        if connection_options[:ssl] && !connection_options[:ssl][:verify]
          c.ssl[:verify] = false
        end

        c.use Octokit::Response::RaiseError
        c.adapter Faraday.default_adapter
      end
    end

  end
end
