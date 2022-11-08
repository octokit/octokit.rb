# frozen_string_literal: true

require 'helper'

describe Octokit::EnterpriseAdminClient::AdminStats do
  before do
    Octokit.reset!
    @admin_client = enterprise_admin_client
  end

  describe '.admin_stats', :vcr do
    it 'returns all available enterprise stats' do
      admin_stats = @admin_client.admin_stats

      expect(admin_stats.issues.total_issues).to be_kind_of Integer
      expect(admin_stats.hooks.total_hooks).to be_kind_of Integer
      expect(admin_stats.milestones.closed_milestones).to be_kind_of Integer
      expect(admin_stats.orgs.total_team_members).to be_kind_of Integer
      expect(admin_stats.comments.total_gist_comments).to be_kind_of Integer
      expect(admin_stats.pages.total_pages).to be_kind_of Integer
      expect(admin_stats.users.total_users).to be_kind_of Integer
      expect(admin_stats.gists.private_gists).to be_kind_of Integer
      expect(admin_stats.pulls.mergeable_pulls).to be_kind_of Integer
      expect(admin_stats.repos.fork_repos).to be_kind_of Integer

      assert_requested :get, github_enterprise_url('enterprise/stats/all')
    end
  end # .admin_stats

  describe '.admin_repository_stats', :vcr do
    it 'returns only repository-related stats' do
      admin_repository_stats = @admin_client.admin_repository_stats

      expect(admin_repository_stats.fork_repos).to be_kind_of Integer
      expect(admin_repository_stats.root_repos).to be_kind_of Integer
      expect(admin_repository_stats.total_repos).to be_kind_of Integer
      expect(admin_repository_stats.total_pushes).to be_kind_of Integer
      expect(admin_repository_stats.org_repos).to be_kind_of Integer
      expect(admin_repository_stats.total_wikis).to be_kind_of Integer

      assert_requested :get, github_enterprise_url('enterprise/stats/repos')
    end
  end # .admin_repository_stats

  describe '.admin_hooks_stats', :vcr do
    it 'returns only hooks-related stats' do
      admin_hooks_stats = @admin_client.admin_hooks_stats

      expect(admin_hooks_stats.total_hooks).to be_kind_of Integer
      expect(admin_hooks_stats.active_hooks).to be_kind_of Integer
      expect(admin_hooks_stats.inactive_hooks).to be_kind_of Integer

      assert_requested :get, github_enterprise_url('enterprise/stats/hooks')
    end
  end # .admin_hooks_stats

  describe '.admin_pages_stats', :vcr do
    it 'returns only pages-related stats' do
      admin_pages_stats = @admin_client.admin_pages_stats

      expect(admin_pages_stats.total_pages).to be_kind_of Integer

      assert_requested :get, github_enterprise_url('enterprise/stats/pages')
    end
  end # .admin_pages_stats

  describe '.admin_organization_stats', :vcr do
    it 'returns only organization-related stats' do
      admin_organization_stats = @admin_client.admin_organization_stats

      expect(admin_organization_stats.total_team_members).to be_kind_of Integer
      expect(admin_organization_stats.disabled_orgs).to be_kind_of Integer
      expect(admin_organization_stats.total_orgs).to be_kind_of Integer
      expect(admin_organization_stats.total_teams).to be_kind_of Integer

      assert_requested :get, github_enterprise_url('enterprise/stats/orgs')
    end
  end # .admin_organization_stats

  describe '.admin_users_stats', :vcr do
    it 'returns only user-related stats' do
      admin_users_stats = @admin_client.admin_users_stats

      expect(admin_users_stats.suspended_users).to be_kind_of Integer
      expect(admin_users_stats.admin_users).to be_kind_of Integer
      expect(admin_users_stats.total_users).to be_kind_of Integer

      assert_requested :get, github_enterprise_url('enterprise/stats/users')
    end
  end # .admin_users_stats

  describe '.admin_pull_requests_stats', :vcr do
    it 'returns only pull request-related stats' do
      admin_pull_requests_stats = @admin_client.admin_pull_requests_stats

      expect(admin_pull_requests_stats.mergeable_pulls).to be_kind_of Integer
      expect(admin_pull_requests_stats.merged_pulls).to be_kind_of Integer
      expect(admin_pull_requests_stats.unmergeable_pulls).to be_kind_of Integer
      expect(admin_pull_requests_stats.total_pulls).to be_kind_of Integer

      assert_requested :get, github_enterprise_url('enterprise/stats/pulls')
    end
  end # .admin_pull_requests_stats

  describe '.admin_issues_stats', :vcr do
    it 'returns only issue-related stats' do
      admin_issues_stats = @admin_client.admin_issues_stats

      expect(admin_issues_stats.total_issues).to be_kind_of Integer
      expect(admin_issues_stats.closed_issues).to be_kind_of Integer
      expect(admin_issues_stats.open_issues).to be_kind_of Integer

      assert_requested :get, github_enterprise_url('enterprise/stats/issues')
    end
  end # .admin_issues_stats

  describe '.admin_milestones_stats', :vcr do
    it 'returns only milestone-related stats' do
      admin_milestones_stats = @admin_client.admin_milestones_stats

      expect(admin_milestones_stats.closed_milestones).to be_kind_of Integer
      expect(admin_milestones_stats.open_milestones).to be_kind_of Integer
      expect(admin_milestones_stats.total_milestones).to be_kind_of Integer

      assert_requested :get, github_enterprise_url('enterprise/stats/milestones')
    end
  end # .admin_milestones_stats

  describe '.admin_gists_stats', :vcr do
    it 'returns only gist-related stats' do
      admin_gists_stats = @admin_client.admin_gists_stats

      expect(admin_gists_stats.private_gists).to be_kind_of Integer
      expect(admin_gists_stats.public_gists).to be_kind_of Integer
      expect(admin_gists_stats.total_gists).to be_kind_of Integer

      assert_requested :get, github_enterprise_url('enterprise/stats/gists')
    end
  end # .admin_gists_stats

  describe '.admin_comments_stats', :vcr do
    it 'returns only comment-related stats' do
      admin_comments_stats = @admin_client.admin_comments_stats

      expect(admin_comments_stats.total_gist_comments).to be_kind_of Integer
      expect(admin_comments_stats.total_commit_comments).to be_kind_of Integer
      expect(admin_comments_stats.total_pull_request_comments).to be_kind_of Integer
      expect(admin_comments_stats.total_issue_comments).to be_kind_of Integer

      assert_requested :get, github_enterprise_url('enterprise/stats/comments')
    end
  end # .admin_comments_stats
end
