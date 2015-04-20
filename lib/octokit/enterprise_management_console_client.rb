require 'octokit/client'
require 'octokit/enterprise_management_console_client/management_console'

module Octokit

  # EnterpriseManagementConsoleClient is only meant to be used by GitHub Enterprise Admins
  # and provides access to the management console API endpoints.
  #
  # @see Octokit::Client Use Octokit::Client for regular API use for GitHub
  #   and GitHub Enterprise.
  # @see https://developer.github.com/v3/enterprise/management_console/
  class EnterpriseManagementConsoleClient < Octokit::Client

    include Octokit::EnterpriseManagementConsoleClient::ManagementConsole

  end
end
