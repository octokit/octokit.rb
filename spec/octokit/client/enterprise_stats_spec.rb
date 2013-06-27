# -*- encoding: utf-8 -*-
require 'helper'

describe Octokit::Client::EnterpriseStats do
  before do
    @client = Octokit::Client.new(:login => 'sferik')
  end

  describe ".enterprise_stats" do
    it "returns all available stats" do
      stub_get("/enterprise/stats/all").to_return(json_response('enterprise_stats.json'))
      enterprise_stats = @client.enterprise_stats

      expect(enterprise_stats.issues.total_issues).to eq(610)
      expect(enterprise_stats.hooks.total_hooks).to eq(0)
      expect(enterprise_stats.milestones.closed_milestones).to eq(7)
      expect(enterprise_stats.orgs.total_team_members).to eq(232)
      expect(enterprise_stats.comments.total_gist_comments).to eq(0)
      expect(enterprise_stats.pages.total_pages).to eq(3)
      expect(enterprise_stats.users.disabled_user).to eq(0)
      expect(enterprise_stats.gists.private_gists).to eq(0)
      expect(enterprise_stats.pulls.mergeable_pulls).to eq(38)
      expect(enterprise_stats.repos.fork_repos).to eq(7)
    end
  end

  describe ".enterprise_repository_stats" do
    it "returns repository-related stats" do
      stub_get("/enterprise/stats/repos").to_return(json_response('enterprise_repository_stats.json'))
      enterprise_repository_stats = @client.enterprise_repository_stats

      expect(enterprise_repository_stats.repos.fork_repos).to eq(7)
      expect(enterprise_repository_stats.repos.root_repos).to eq(153)
      expect(enterprise_repository_stats.repos.total_repos).to eq(153)
      expect(enterprise_repository_stats.repos.total_pushes).to eq(0)
      expect(enterprise_repository_stats.repos.org_repos).to eq(17)
      expect(enterprise_repository_stats.repos.total_wikis).to eq(0)
    end
  end

  describe ".enterprise_hooks_stats" do
    it "returns hooks-related stats" do
      stub_get("/enterprise/stats/hooks").to_return(json_response('enterprise_hooks_stats.json'))
      enterprise_hooks_stats = @client.enterprise_hooks_stats

      expect(enterprise_hooks_stats.hooks.total_hooks).to eq(0)
      expect(enterprise_hooks_stats.hooks.active_hooks).to eq(0)
      expect(enterprise_hooks_stats.hooks.inactive_hooks).to eq(0)
    end
  end

  describe ".enterprise_pages_stats" do
    it "returns pages-related stats" do
      stub_get("/enterprise/stats/pages").to_return(json_response('enterprise_pages_stats.json'))
      enterprise_pages_stats = @client.enterprise_pages_stats

      expect(enterprise_pages_stats.pages.total_pages).to eq(3)
    end
  end

  describe ".enterprise_organization_stats" do
    it "returns organization-related stats" do
      stub_get("/enterprise/stats/orgs").to_return(json_response('enterprise_organization_stats.json'))
      enterprise_organization_stats = @client.enterprise_organization_stats

      expect(enterprise_organization_stats.orgs.total_team_members).to eq(232)
      expect(enterprise_organization_stats.orgs.disabled_orgs).to eq(0)
      expect(enterprise_organization_stats.orgs.total_orgs).to eq(17)
      expect(enterprise_organization_stats.orgs.total_teams).to eq(32)
    end
  end

  describe ".enterprise_users_stats" do
    it "returns user-related stats" do
      stub_get("/enterprise/stats/users").to_return(json_response('enterprise_users_stats.json'))
      enterprise_users_stats = @client.enterprise_users_stats

      expect(enterprise_users_stats.users.disabled_user).to eq(0)
      expect(enterprise_users_stats.users.admin_users).to eq(48)
      expect(enterprise_users_stats.users.total_users).to eq(507)
    end
  end

  describe ".enterprise_pull_requests_stats" do
    it "returns pull request-related stats" do
      stub_get("/enterprise/stats/pulls").to_return(json_response('enterprise_pull_requests_stats.json'))
      enterprise_pull_requests_stats = @client.enterprise_pull_requests_stats

      expect(enterprise_pull_requests_stats.pulls.mergeable_pulls).to eq(38)
      expect(enterprise_pull_requests_stats.pulls.merged_pulls).to eq(178)
      expect(enterprise_pull_requests_stats.pulls.unmergeable_pulls).to eq(11)
      expect(enterprise_pull_requests_stats.pulls.total_pulls).to eq(250)
    end
  end

  describe ".enterprise_issues_stats" do
    it "returns issue-related stats" do
      stub_get("/enterprise/stats/issues").to_return(json_response('enterprise_issues_stats.json'))
      enterprise_issues_stats = @client.enterprise_issues_stats

      expect(enterprise_issues_stats.issues.total_issues).to eq(610)
      expect(enterprise_issues_stats.issues.closed_issues).to eq(505)
      expect(enterprise_issues_stats.issues.open_issues).to eq(105)
    end
  end

  describe ".enterprise_milestones_stats" do
    it "returns milestone-related stats" do
      stub_get("/enterprise/stats/milestones").to_return(json_response('enterprise_milestones_stats.json'))
      enterprise_milestones_stats = @client.enterprise_milestones_stats

      expect(enterprise_milestones_stats.milestones.closed_milestones).to eq(7)
      expect(enterprise_milestones_stats.milestones.open_milestones).to eq(4)
      expect(enterprise_milestones_stats.milestones.total_milestones).to eq(11)
    end
  end

  describe ".enterprise_gists_stats" do
    it "returns gist-related stats" do
      stub_get("/enterprise/stats/gists").to_return(json_response('enterprise_gists_stats.json'))
      enterprise_gists_stats = @client.enterprise_gists_stats

      expect(enterprise_gists_stats.gists.private_gists).to eq(0)
      expect(enterprise_gists_stats.gists.public_gists).to eq(0)
      expect(enterprise_gists_stats.gists.total_gists).to eq(0)
    end
  end

  describe ".enterprise_comments_stats" do
    it "returns comment-related stats" do
      stub_get("/enterprise/stats/comments").to_return(json_response('enterprise_comments_stats.json'))
      enterprise_comments_stats = @client.enterprise_comments_stats

      expect(enterprise_comments_stats.comments.total_gist_comments).to eq(0)
      expect(enterprise_comments_stats.comments.total_commit_comments).to eq(80)
      expect(enterprise_comments_stats.comments.total_pull_request_comments).to eq(47)
      expect(enterprise_comments_stats.comments.total_issue_comments).to eq(1166)
    end
  end
end
