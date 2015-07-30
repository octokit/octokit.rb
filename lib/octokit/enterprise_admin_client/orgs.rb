module Octokit
  class EnterpriseAdminClient

    # Methods for the Enterprise Orgs API
    #
    # @see https://developer.github.com/v3/enterprise/orgs/
    module Orgs

      # Create a new organization on the instance.
      #
      # options [Hash] A set of options.
      # @option options [String] :login The organization's username.
      # @option options [String] :admin The login of the user who will manage this organization.
      # @option options [String] :profile_name The organization's display name.
      # @return [nil]
      # @see https://developer.github.com/v3/enterprise/orgs/#create-an-organization
      # @example
      #   @admin_client.create_organization({:login => 'GitHub', :admin => 'monalisaoctocat'})
      def create_organization(options)
        post "admin/organizations", options
      end

    end
  end
end
