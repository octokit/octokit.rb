# frozen_string_literal: true

module Octokit
  class ManageGHESClient
    # Methods for the Manage GitHub Enterprise Server API
    #
    # @see https://developer.github.com/v3/enterprise-admin/manage-ghes
    module ManageAPI
    end
  
    private

    def basic_authenticated?
      !!(@manage_api_username && @manage_api_password)
    end

    def root_site_admin_assumed?
      !!(@manage_api_username)
    end

    def faraday_configuration
      @faraday_configuration ||= Faraday.new(url: @manage_ghes_endpoint) do |c|
        c.headers[:user_agent] = user_agent
        c.request  :json
        c.response :json

        if root_site_admin_assumed?
          c.basic_auth('api_key', @manage_api_password)
        elsif basic_authenticated?
          c.basic_auth(@manage_api_username, @manage_api_password)
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
