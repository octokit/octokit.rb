# -*- encoding: utf-8 -*-
require 'helper'

describe Octokit::Client::Organizations do

  before do
    @client = Octokit::Client.new(:login => 'sferik')
  end

  describe ".organization" do

    it "should return an organization" do
      stub_get("https://api.github.com/orgs/codeforamerica").
        to_return(:body => fixture("v3/organization.json"))
      organization = @client.organization("codeforamerica")
      organization.name.should == "Code For America"
    end

  end

  describe ".update_organization" do

    it "should update an organization" do
      stub_patch("https://api.github.com/orgs/codeforamerica").
        with(:name => "Code For America").
        to_return(:body => fixture("v3/organization.json"))
      organization = @client.update_organization("codeforamerica", {:name => "Code For America"})
      organization.name.should == "Code For America"
    end

  end

  describe ".organizations" do

    context "with a user passed" do

      it "should return all organizations for a user" do
        stub_get("https://api.github.com/users/sferik/orgs").
          to_return(:body => fixture("v3/organizations.json"))
        organizations = @client.organizations("sferik")
        organizations.first.login.should == "Hubcap"
      end

    end

    context "without user passed" do

      it "should return all organizations for a user" do
        stub_get("https://api.github.com/user/orgs").
          to_return(:body => fixture("v3/organizations.json"))
        organizations = @client.organizations
        organizations.first.login.should == "Hubcap"
      end

    end

  end

  describe ".organization_repositories" do

    context "with an org passed" do

      it "should return all public repositories for an organization" do
        stub_get("https://api.github.com/orgs/codeforamerica/repos").
          to_return(:body => fixture("v3/organization-repositories.json"))
        repositories = @client.organization_repositories("codeforamerica")
        repositories.first.name.should == "cfahelloworld"
      end

    end

    context "without an org passed" do

      it "should return all organization repositories for a user" do
        stub_get("https://github.com/api/v2/json/organizations/repositories").
          to_return(:body => fixture("v2/repositories.json"))
        repositories = @client.organization_repositories
        repositories.repositories.first.name.should == "One40Proof"
      end

    end

  end

  describe ".organization_members" do

    it "should return all public members of an organization" do
      stub_get("https://api.github.com/orgs/codeforamerica/members").
        to_return(:body => fixture("v3/organization_members.json"))
      users = @client.organization_members("codeforamerica")
      users.first.login.should == "akit"
    end

  end

  describe ".organization_teams" do

    it "should return all teams for an organization" do
      stub_get("https://api.github.com/orgs/codeforamerica/teams").
        to_return(:body => fixture("v3/teams.json"))
      teams = @client.organization_teams("codeforamerica")
      teams.first.name.should == "Fellows"
    end

  end

  describe ".create_team" do

    it "should create a team" do
      stub_post("https://api.github.com/orgs/codeforamerica/teams").
        with(:name => "Fellows").
        to_return(:body => fixture("v3/team.json"))
      team = @client.create_team("codeforamerica", {:name => "Fellows"})
      team.name.should == "Fellows"
    end

  end

  describe ".team" do

    it "should return a team" do
      stub_get("https://api.github.com/teams/32598").
        to_return(:body => fixture("v3/team.json"))
      team = @client.team(32598)
      team.name.should == "Fellows"
    end

  end

  describe ".update_team" do

    it "should update a team" do
      stub_patch("https://api.github.com/teams/32598").
        with(:name => "Fellows").
        to_return(:body => fixture("v3/team.json"))
      team = @client.update_team(32598, :name => "Fellows")
      team.name.should == "Fellows"
    end

  end

  describe ".delete_team" do

    it "should delete a team" do
      stub_delete("https://api.github.com/teams/32598").
        to_return(:status => 204)
      result = @client.delete_team(32598)
      result.status.should == 204
    end

  end


  describe ".team_members" do

    it "should return team members" do
      stub_get("https://api.github.com/teams/33239/members").
        to_return(:body => fixture("v3/organization_team_members.json"))
      users = @client.team_members(33239)
      users.first.login.should == "ctshryock"
    end

  end

  describe ".add_team_member" do

    it "should add a team member" do
      stub_put("https://api.github.com/teams/32598/members/sferik").
        with(:name => "sferik").
        to_return(:status => 204)
      result = @client.add_team_member(32598, "sferik")
      result.should be_true
    end

  end

  describe ".remove_team_member" do

    it "should remove a team member" do
      stub_delete("https://api.github.com/teams/32598/members/sferik").
        to_return(:status => 204)
      result = @client.remove_team_member(32598, "sferik")
      result.should be_true
    end

  end

  describe ".team_repositories" do

    it "should return team repositories" do
      stub_get("https://api.github.com/teams/33239/repos").
        to_return(:body => fixture("v3/organization_team_repos.json"))
      repositories = @client.team_repositories(33239)
      repositories.first.name.should == "GitTalk"
      repositories.first.owner.id.should == 570695
    end

  end

  describe ".add_team_repository" do

    it "should add a team repository" do
      stub_put("https://api.github.com/teams/32598/repos/reddavis/One40Proof").
        with(:name => "reddavis/One40Proof").
        to_return(:status => 204)
      result = @client.add_team_repository(32598, "reddavis/One40Proof")
      result.should be_true
    end

  end

  describe ".remove_team_repository" do

    it "should remove a team repository" do
      stub_delete("https://api.github.com/teams/32598/repos/reddavis/One40Proof").
        to_return(:status => 204)
      result = @client.remove_team_repository(32598, "reddavis/One40Proof")
      result.should be_true
    end

  end

  describe ".publicize_membership" do

    it "should pulicize membership" do
      stub_put("https://api.github.com/orgs/codeforamerica/public_members/sferik").
        with(:name => "sferik").
        to_return(:status => 204)
      result = @client.publicize_membership("codeforamerica", "sferik")
      result.should be_true
    end

  end

  describe ".unpublicize_membership" do

    it "should unpulicize membership" do
      stub_delete("https://api.github.com/orgs/codeforamerica/public_members/sferik").
        with(:name => "sferik").
        to_return(:status => 204)
      result = @client.unpublicize_membership("codeforamerica", "sferik")
      result.should be_true
    end

  end

end
