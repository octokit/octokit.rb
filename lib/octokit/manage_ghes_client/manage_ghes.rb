# frozen_string_literal: true

module Octokit
  class ManageGHESClient
    # Methods for the Manage GitHub Enterprise Server API
    #
    # @see https://developer.github.com/v3/enterprise-admin/manage-ghes
    module ManageAPI
    end
  
    private

    def password_hash
      { query: { api_key: @management_console_password } }
    end

    def basic_authenticated?
      !!(@manage_api_username && @manage_api_password)
    end

    def root_site_admin_assumed?
      !!(@manage_api_username)
    end

    def faraday_configuration
      @faraday_configuration ||= Faraday.new(url: @manage_ghes_endpoint) do |http|
        http.headers[:user_agent] = user_agent
        http.headers[:content_type] = 'application/json'

        if root_site_admin_assumed?
          http.basic_auth('api_key', @manage_api_password)
        elsif basic_authenticated?
          http.basic_auth(@manage_api_username, @manage_api_password)
        end

        # Disabling SSL is essential for certain self-hosted Enterprise instances
        if connection_options[:ssl] && !connection_options[:ssl][:verify]
          http.ssl[:verify] = false
        end

        http.use Octokit::Response::RaiseError
        http.adapter Faraday.default_adapter
      end
    end

  end
end
