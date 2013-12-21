require 'octokit/client'
require 'octokit/enterprise_admin_client/admin_stats'
require 'octokit/enterprise_admin_client/search_indexing'

module Octokit

  # EnterpriseAdminClient is only meant to be used by GitHub Enterprise Admins
  # and provides access the Admin only API endpoints including Admin Stats,
  # Management Console and the Search Indexing API.
  #
  # @see Octokit::Client Use Octokit::Client for regular API use for GitHub
  #   and GitHub Enterprise.
  # @see https://enterprise.github.com/help/categories/5/articles
  class EnterpriseAdminClient < Octokit::Client

    include Octokit::EnterpriseAdminClient::AdminStats
    include Octokit::EnterpriseAdminClient::SearchIndexing

  end

end
