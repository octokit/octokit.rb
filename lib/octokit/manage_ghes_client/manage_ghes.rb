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
        conn = authenticated_client

        @last_response = conn.get('/manage/v1/maintenance')
      end
      alias maintenance_mode get_maintenance_mode

      # Configure the maintenance mode of the GHES instance
      #
      # @param maintenance [Hash] A hash configuration of the maintenance mode status
      # @return [nil]
      def set_maintenance_mode(enabled, options = {})
        conn = authenticated_client

        options[:enabled] = enabled
        @last_response = conn.post('/manage/v1/maintenance', options)
      end
      alias configure_maintenance_mode set_maintenance_mode
    end
  
    private

    def basic_authenticated?
      !!(@manage_ghes_username && @manage_ghes_password)
    end

    # If no username is provided, we assume root site admin should be used
    def root_site_admin_assumed?
      !(@manage_ghes_username)
    end

    def authenticated_client
      @authenticated_client ||= Faraday.new(url: @manage_ghes_endpoint) do |c|
        c.headers[:user_agent] = user_agent
        c.request  :json
        c.response :json
        c.adapter Faraday.default_adapter

        if root_site_admin_assumed?
          username = "api_key"
        elsif basic_authenticated?
          username = @manage_ghes_username
        end
        c.request :authorization, :basic, username, @manage_ghes_password


        # Disabling SSL is essential for certain self-hosted Enterprise instances
        if connection_options[:ssl] && !connection_options[:ssl][:verify]
          c.ssl[:verify] = false
        end

        c.use Octokit::Response::RaiseError
      end
    end

  end
end
