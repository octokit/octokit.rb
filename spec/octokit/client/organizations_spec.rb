# -*- encoding: utf-8 -*-
require 'helper'

describe Octokit::Client::Organizations do

  before do
    @client = Octokit::Client.new(:login => 'sferik')
  end

  describe ".organization" do

    it "returns an organization" do
      stub_get("https://api.github.com/orgs/codeforamerica").
        to_return(:body => fixture("v3/organization.json"))
      organization = @client.organization("codeforamerica")
      expect(organization.name).to eq("Code For America")
    end

  end

  describe ".update_organization" do

    it "updates an organization" do
      stub_patch("https://api.github.com/orgs/codeforamerica").
        with(:name => "Code For America").
        to_return(:body => fixture("v3/organization.json"))
      organization = @client.update_organization("codeforamerica", {:name => "Code For America"})
      expect(organization.name).to eq("Code For America")
    end

  end

  describe ".organizations" do

    context "with a user passed" do

      it "returns all organizations for a user" do
        stub_get("https://api.github.com/users/sferik/orgs").
          to_return(:body => fixture("v3/organizations.json"))
        organizations = @client.organizations("sferik")
        expect(organizations.first.login).to eq("Hubcap")
      end

    end

    context "without user passed" do

      it "returns all organizations for a user" do
        stub_get("https://api.github.com/user/orgs").
          to_return(:body => fixture("v3/organizations.json"))
        organizations = @client.organizations
        expect(organizations.first.login).to eq("Hubcap")
      end

    end

  end

  describe ".organization_repositories" do

    it "returns all public repositories for an organization" do
      stub_get("https://api.github.com/orgs/codeforamerica/repos").
        to_return(:body => fixture("v3/organization-repositories.json"))
      repositories = @client.organization_repositories("codeforamerica")
      expect(repositories.first.name).to eq("cfahelloworld")
    end

  end

  describe ".organization_members" do

    context "without an authenticated client" do

      it "regresses to .organization_public_members" do
        stub_get("https://api.github.com/orgs/codeforamerica/members").
          to_return(:status => 302)
        stub_get("https://api.github.com/orgs/codeforamerica/public_members").
          to_return(:body => fixture('v3/organization_members.json'))
        users = @client.organization_members("codeforamerica")
        expect(users.first.login).to eq("akit")
      end

    end

    context "with an authenticated client" do

      it "returns public and private members of an organization" do
        stub_get("https://api.github.com/orgs/codeforamerica/members").
          to_return(:status => 200, :body => fixture('v3/organization_members.json'))
        users = @client.organization_members("codeforamerica")
        expect(users.first.login).to eq("akit")
      end

    end

  end

  describe ".organization_member?" do

    context "with authenticated user" do

      it "checks if a user is an organization member" do
        stub_get("https://api.github.com/orgs/github/members/pengwynn").
          to_return(:status => 204)
        is_org_member = @client.organization_member?('github', 'pengwynn')
        expect(is_org_member).to be_true
      end

      it "checks if a user is an organization member" do
        stub_get("https://api.github.com/orgs/github/members/joeyw").
          to_return(:status => 404)
        is_org_member = @client.organization_member?('github', 'joeyw')
        expect(is_org_member).to be_false
      end

    end

    context "without authenticated client" do

      it "checks if user is an organization member" do
        stub_get("https://api.github.com/orgs/github/members/pengwynn").
          to_return(:status => 302)
        stub_get("https://api.github.com/orgs/github/public_members/pengwynn").
          to_return(:status => 204)
        is_org_member = @client.organization_member?('github', 'pengwynn')
        expect(is_org_member).to be_true
      end

    end

  end

  describe ".organization_public_member?" do

    context "user is a public member" do

      it "checks if user is an organization public member" do
        stub_get("https://api.github.com/orgs/github/public_members/pengwynn").
          to_return(:status => 204)
        is_org_member = @client.organization_public_member?('github', 'pengwynn')
        expect(is_org_member).to be_true
      end

    end

    context "user is not a public member" do

      it "checks if the user is an organization public member" do
        stub_get("https://api.github.com/orgs/github/public_members/joeyw").
          to_return(:status => 404)
        is_org_member = @client.organization_public_member?('github', 'joeyw')
        expect(is_org_member).to be_false
      end

    end

  end

  describe ".organization_public_members" do

    it "returns all public members" do
      stub_get("https://api.github.com/orgs/codeforamerica/public_members").
        to_return(:body => fixture('v3/organization_members.json'))
      users = @client.organization_public_members("codeforamerica")
      expect(users.first.login).to eq("akit")
    end

  end

  describe ".organization_teams" do

    it "returns all teams for an organization" do
      stub_get("https://api.github.com/orgs/codeforamerica/teams").
        to_return(:body => fixture("v3/teams.json"))
      teams = @client.organization_teams("codeforamerica")
      expect(teams.first.name).to eq("Fellows")
    end

  end

  describe ".create_team" do

    it "creates a team" do
      stub_post("https://api.github.com/orgs/codeforamerica/teams").
        with(:name => "Fellows").
        to_return(:body => fixture("v3/team.json"))
      team = @client.create_team("codeforamerica", {:name => "Fellows"})
      expect(team.name).to eq("Fellows")
    end

  end

  describe ".team" do

    it "returns a team" do
      stub_get("https://api.github.com/teams/32598").
        to_return(:body => fixture("v3/team.json"))
      team = @client.team(32598)
      expect(team.name).to eq("Fellows")
    end

  end

  describe ".update_team" do

    it "updates a team" do
      stub_patch("https://api.github.com/teams/32598").
        with(:name => "Fellows").
        to_return(:body => fixture("v3/team.json"))
      team = @client.update_team(32598, :name => "Fellows")
      expect(team.name).to eq("Fellows")
    end

  end

  describe ".delete_team" do

    it "deletes a team" do
      stub_delete("https://api.github.com/teams/32598").
        to_return(:status => 204)
      result = @client.delete_team(32598)
      expect(result.status).to eq(204)
    end

  end


  describe ".team_members" do

    it "returns team members" do
      stub_get("https://api.github.com/teams/33239/members").
        to_return(:body => fixture("v3/organization_team_members.json"))
      users = @client.team_members(33239)
      expect(users.first.login).to eq("ctshryock")
    end

  end

  describe ".add_team_member" do

    it "adds a team member" do
      stub_put("https://api.github.com/teams/32598/members/sferik").
        with(:name => "sferik").
        to_return(:status => 204)
      result = @client.add_team_member(32598, "sferik")
      expect(result).to be_true
    end

  end

  describe ".remove_team_member" do

    it "removes a team member" do
      stub_delete("https://api.github.com/teams/32598/members/sferik").
        to_return(:status => 204)
      result = @client.remove_team_member(32598, "sferik")
      expect(result).to be_true
    end

  end

  describe ".remove_organization_member" do
    it "removes a member from an organization" do
      stub_delete("https://api.github.com/orgs/codeforamerica/members/glow-mdsol").
          to_return(:status => 204)
      result = @client.remove_organization_member("codeforamerica", "glow-mdsol")
      expect(result).to be_true
    end

  end
  describe ".team_repositories" do

    it "returns team repositories" do
      stub_get("https://api.github.com/teams/33239/repos").
        to_return(:body => fixture("v3/organization_team_repos.json"))
      repositories = @client.team_repositories(33239)
      expect(repositories.first.name).to eq("GitTalk")
      expect(repositories.first.owner.id).to eq(570695)
    end

  end

  describe ".add_team_repository" do

    it "adds a team repository" do
      stub_put("https://api.github.com/teams/32598/repos/reddavis/One40Proof").
        with(:name => "reddavis/One40Proof").
        to_return(:status => 204)
      result = @client.add_team_repository(32598, "reddavis/One40Proof")
      expect(result).to be_true
    end

  end

  describe ".remove_team_repository" do

    it "removes a team repository" do
      stub_delete("https://api.github.com/teams/32598/repos/reddavis/One40Proof").
        to_return(:status => 204)
      result = @client.remove_team_repository(32598, "reddavis/One40Proof")
      expect(result).to be_true
    end

  end

  describe ".publicize_membership" do

    it "pulicizes membership" do
      stub_put("https://api.github.com/orgs/codeforamerica/public_members/sferik").
        with(:name => "sferik").
        to_return(:status => 204)
      result = @client.publicize_membership("codeforamerica", "sferik")
      expect(result).to be_true
    end

  end

  describe ".unpublicize_membership" do

    it "unpulicizes membership" do
      stub_delete("https://api.github.com/orgs/codeforamerica/public_members/sferik").
        with(:name => "sferik").
        to_return(:status => 204)
      result = @client.unpublicize_membership("codeforamerica", "sferik")
      expect(result).to be_true
    end

  end

end
