require 'octokit/client'
require 'octokit/enterprise_admin_client'
require 'octokit/enterprise_management_console_client'
require 'octokit/default'

# Ruby toolkit for the GitHub API
module Octokit

  class << self
    include Octokit::Configurable

    # API client based on configured options {Configurable}
    #
    # @return [Octokit::Client] API wrapper
    def client
      @client = Octokit::Client.new(options) unless client_exists?(@client, options)
      @client
    end

    # API client based on configured options {Configurable}
    #
    # @return [Octokit::Client] API wrapper
    def enterprise_admin_client
      @enterprise_admin_client = Octokit::EnterpriseAdminClient.new(options) unless client_exists?(@enterprise_admin_client, options)
      @enterprise_admin_client
    end

    # API client based on configured options {Configurable}
    #
    # @return [Octokit::Client] API wrapper
    def enterprise_management_console_client
      @enterprise_management_console_client = Octokit::EnterpriseManagementConsoleClient.new(options) unless client_exists?(@enterprise_management_console_client, options)
      @enterprise_management_console_client
    end

    # @private
    def respond_to_missing?(method_name, include_private=false); client.respond_to?(method_name, include_private); end if RUBY_VERSION >= "1.9"
    # @private
    def respond_to?(method_name, include_private=false); client.respond_to?(method_name, include_private) || super; end if RUBY_VERSION < "1.9"

  private

    def method_missing(method_name, *args, &block)
      return super unless client.respond_to?(method_name)
      client.send(method_name, *args, &block)
    end

    def client_exists?(c, options)
      c && defined?(c) && c.same_options?(options)
    end

  end
end

Octokit.setup
