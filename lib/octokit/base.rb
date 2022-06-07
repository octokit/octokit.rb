# Ruby toolkit for the GitHub API
#
# NOTE: The `Octokit` module is defined here, rather than in `lib/octokit.rb`, to allow
# the gem to include a lazy-loaded version where dependencies are required as needed,
# as well as a default where everything is required together.
module Octokit
  # These autoload statements won't do anything if the module has already been loaded, as
  # will happen if the gem is required in the normal, automatic way. They will only come
  # into affect if the user requires `octokit/lazy`.
  autoload(:Client, File.join(__dir__, 'client'))
  autoload(:EnterpriseAdminClient, File.join(__dir__, 'enterprise_admin_client'))
  autoload(:EnterpriseManagementConsoleClient, File.join(__dir__, 'enterprise_management_console_client'))

  class << self
    include Octokit::Configurable
    
    # API client based on configured options {Configurable}
    #
    # @return [Octokit::Client] API wrapper
    def client
      return @client if defined?(@client) && @client.same_options?(options)
      @client = Octokit::Client.new(options)
    end
    
    # EnterpriseAdminClient client based on configured options {Configurable}
    #
    # @return [Octokit::EnterpriseAdminClient] API wrapper
    def enterprise_admin_client
      return @enterprise_admin_client if defined?(@enterprise_admin_client) && @enterprise_admin_client.same_options?(options)
      @enterprise_admin_client = Octokit::EnterpriseAdminClient.new(options)
    end
    
    # EnterpriseManagementConsoleClient client based on configured options {Configurable}
    #
    # @return [Octokit::EnterpriseManagementConsoleClient] API wrapper
    def enterprise_management_console_client
      return @enterprise_management_console_client if defined?(@enterprise_management_console_client) && @enterprise_management_console_client.same_options?(options)
      @enterprise_management_console_client = Octokit::EnterpriseManagementConsoleClient.new(options)
    end
    
    private
    
    def respond_to_missing?(method_name, include_private=false)
      client.respond_to?(method_name, include_private) ||
      enterprise_admin_client.respond_to?(method_name, include_private) ||
      enterprise_management_console_client.respond_to?(method_name, include_private)
    end
    
    def method_missing(method_name, *args, &block)
      if client.respond_to?(method_name)
        return client.send(method_name, *args, &block)
      elsif enterprise_admin_client.respond_to?(method_name)
        return enterprise_admin_client.send(method_name, *args, &block)
      elsif enterprise_management_console_client.respond_to?(method_name)
        return enterprise_management_console_client.send(method_name, *args, &block)
      end
      
      super
    end
    
  end
end

Octokit.setup
