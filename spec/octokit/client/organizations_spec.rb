require 'helper'

describe Octokit::Client::Organizations do

  before do
    Octokit.reset!
    @client = oauth_client
  end

  describe ".organization", :vcr do
    it "returns an organization" do
      organization = @client.organization("codeforamerica")
      expect(organization.name).to eq("Code for America")
      assert_requested :get, github_url("/orgs/codeforamerica")
    end
  end # .organization

  describe ".update_organization", :vcr do
    it "updates an organization" do
      organization = @client.update_organization(test_github_org, {:name => "API Playground"})
      expect(organization.login).to eq test_github_org
      assert_requested :patch, github_url("/orgs/#{test_github_org}")
    end
  end # .update_organization

  describe ".organizations", :vcr do
    it "returns all organizations for a user" do
      organizations = @client.organizations("sferik")
      expect(organizations).to be_kind_of Array
      assert_requested :get, github_url("/users/sferik/orgs")
    end
    it "returns all organizations for the authenticated user" do
      organizations = @client.organizations
      expect(organizations).to be_kind_of Array
      assert_requested :get, github_url("/user/orgs")
    end
  end # .organizations

  describe ".all_organizations", :vcr do
    it "paginates organizations on GitHub" do
      orgs = Octokit.all_organizations
      expect(orgs).to be_kind_of Array
      assert_requested :get, github_url("organizations")
    end
  end # .all_organizations

  describe ".organization_repositories", :vcr do
    it "returns all public repositories for an organization" do
      repositories = @client.organization_repositories("codeforamerica")
      expect(repositories).to be_kind_of Array
      assert_requested :get, github_url("/orgs/codeforamerica/repos")
    end
  end # .organization_repositories

  describe ".organization_members", :vcr do
    it "returns all public members of an organization" do
      users = @client.organization_members("codeforamerica")
      expect(users).to be_kind_of Array
      assert_requested :get, github_url("/orgs/codeforamerica/members")
    end
  end # .organization_members

  describe ".organization_member?", :vcr do
    it "checks organization membership" do
      is_hubbernaut = @client.organization_member?('github', 'pengwynn')
      assert_requested :get, github_url("/orgs/github/members/pengwynn")
      expect(is_hubbernaut).to be true
    end
  end # .organization_member?

  describe ".organization_public_members", :vcr do
    it "lists public members" do
      users = @client.organization_public_members("codeforamerica")
      expect(users).to be_kind_of Array
      assert_requested :get, github_url("/orgs/codeforamerica/public_members")
    end
  end

  describe ".organization_public_member?", :vcr do
    it "checks publicized org membership" do
      is_hubbernaut = @client.organization_public_member?('github', 'pengwynn')
      expect(is_hubbernaut).to be true
      assert_requested :get, github_url("/orgs/github/public_members/pengwynn")
    end
  end # .organization_public_member?

  describe ".organization_invitations", :vcr do
    it "lists pending organization invitations" do
      @client.organization_invitations(test_github_org, :accept => 'application/vnd.github.korra-preview+json')
      assert_requested :get, github_url("/orgs/#{test_github_org}/invitations")
    end
  end # .organization_invitations

  describe ".outside_collaborators", :vcr do
    it "lists outside collaborators for an organization" do
      @client.outside_collaborators(test_github_org, :accept => 'application/vnd.github.korra-preview+json')
      assert_requested :get, github_url("/orgs/#{test_github_org}/outside_collaborators")
    end
  end #  .outside_collaborators

  describe ".remove_outside_collaborator", :vcr do
    it "removes the outside collaborator from an organization" do
      stub_delete github_url("/orgs/#{test_github_org}/outside_collaborators/lizzhale")
      @client.remove_outside_collaborator(test_github_org, 'lizzhale', :accept => 'application/vnd.github.korra-preview+json')
      assert_requested :delete, github_url("/orgs/#{test_github_org}/outside_collaborators/lizzhale")
    end
  end # .remove_outside_collaborator

  describe ".convert_to_outside_collaborator", :vcr do
    it "converts an organization member to an outside collaborator" do
      stub_put github_url("orgs/#{test_github_org}/outside_collaborators/lizzhale")
      @client.convert_to_outside_collaborator(test_github_org, 'lizzhale', :accept => 'application/vnd.github.korra-preview+json')
      assert_requested :put, github_url("orgs/#{test_github_org}/outside_collaborators/lizzhale")
    end
  end # .convert_to_outside_collaborator

  describe ".organization_teams", :vcr do
    it "returns all teams for an organization" do
      teams = @client.organization_teams(test_github_org)
      expect(teams).to be_kind_of Array
      assert_requested :get, github_url("/orgs/#{test_github_org}/teams")
    end
  end # .organization_teams

  context "with team", :order => :defined do
    before(:each) do
      @team_name = "Test Team #{Time.now.to_i}"
      @team = @client.create_team(test_github_org, {:name => @team_name})
      use_vcr_placeholder_for(@team.id, "<GITHUB_TEST_ORG_TEAM_ID>")
    end

    after(:each) do
      @client.delete_team(@team.id)
    end

    describe ".create_team", :vcr do
      it "creates a team" do
        assert_requested :post, github_url("/orgs/#{test_github_org}/teams")
      end
    end # .create_team

    describe ".team", :vcr do
      it "returns a team" do
        team = @client.team(@team.id)
        expect(team.id).to eq(@team.id)
        assert_requested :get, github_url("/teams/#{@team.id}")
      end
    end # .team

    describe ".update_team", :vcr do
      it "updates a team" do
        @client.update_team(@team.id, :name => "API Jedi")
        assert_requested :patch, github_url("/teams/#{@team.id}")
      end
    end # .update_team

    describe ".team_members", :vcr do
      it "returns team members" do
        users = @client.team_members(@team.id)
        expect(users).to be_kind_of Array
        assert_requested :get, github_url("/teams/#{@team.id}/members")
      end
    end # .team_members

    describe ".add_team_member", :vcr do
      it "adds a team member" do
        @client.add_team_member(@team.id, "api-padawan")
        assert_requested :put, github_url("/teams/#{@team.id}/members/api-padawan")
      end
    end # .add_team_member

    describe ".remove_team_member", :vcr do
      it "removes a team member" do
        @client.remove_team_member(@team.id, "api-padawan")
        assert_requested :delete, github_url("/teams/#{@team.id}/members/api-padawan")
      end
    end # .remove_team_member

    describe ".team_member?", :vcr do
      it "checks if a user is member of a team" do
        @client.team_member?(@team.id, 'api-padawan')
        assert_requested :get, github_url("/teams/#{@team.id}/members/api-padawan")
      end
    end # .team_member?

    describe ".team_invitations", :vcr do
      it "lists pending team invitations" do
        @client.team_invitations(@team.id, :accept => 'application/vnd.github.korra-preview+json')
        assert_requested :get, github_url("/teams/#{@team.id}/invitations")
      end
    end # .team_invitations

    describe ".team_repositories", :vcr do
      it "returns team repositories" do
        repositories = @client.team_repositories(@team.id)
        expect(repositories).to be_kind_of Array
        assert_requested :get, github_url("/teams/#{@team.id}/repos")
      end
    end # .team_repositories

    describe ".add_team_repository", :vcr do
      it "adds a team repository" do
        @client.add_team_repository(@team.id, @test_org_repo)
        assert_requested :put, github_url("/teams/#{@team.id}/repos/#{@test_org_repo}")
      end
    end # .add_team_repository

    describe ".team_repository?", :vcr do
      it "checks if a repo is managed by a specific team" do
        is_team_repo = @client.team_repository?(@team.id, "#{test_github_org}/notateamrepository")
        expect(is_team_repo).to be false
        assert_requested :get, github_url("/teams/#{@team.id}/repos/#{test_github_org}/notateamrepository")
      end
    end

    describe ".remove_team_repository", :vcr do
      it "removes a team repository" do
        @client.remove_team_repository @team.id, @test_org_repo
        assert_requested :delete, github_url("/teams/#{@team.id}/repos/#{@test_org_repo}")
      end
    end #.remove_team_repository

    describe ".publicize_membership", :vcr do
      it "publicizes membership" do
        @client.publicize_membership test_github_org, test_github_login
        assert_requested :put, github_url("/orgs/#{test_github_org}/public_members/#{test_github_login}")
      end
    end # .publicize_membership

    describe ".unpublicize_membership", :vcr do
      it "unpublicizes membership" do
        @client.unpublicize_membership test_github_org, test_github_login
        assert_requested :delete, github_url("/orgs/#{test_github_org}/public_members/#{test_github_login}")
      end
    end # .unpublicize_membership

    describe ".delete_team", :vcr do
      it "deletes a team" do
        @client.delete_team(@team.id)
        assert_requested :delete, github_url("/teams/#{@team.id}")
      end
    end # .delete_team
  end # with team

  describe ".remove_organization_member" do
    it "removes a member from an organization" do
      stub_delete github_url("/orgs/api-playground/members/api-padawan")
      @client.remove_organization_member("api-playground", "api-padawan")
      assert_requested :delete, github_url("/orgs/api-playground/members/api-padawan")
    end
  end # .remove_organization_member

  describe ".user_teams", :vcr do
    it "lists all teams for the authenticated user" do
      teams = @client.user_teams
      assert_requested :get, github_url("/user/teams")
      expect(teams).to be_kind_of(Array)
    end
  end # .user_teams

  describe ".team_membership", :vcr do
    it "gets a user's team membership" do
      membership = @client.team_membership(946194, "pengwynn")
      assert_requested :get, github_url("teams/946194/memberships/pengwynn")
      expect(membership.status).to eq("active")
    end
  end # .team_membership

  describe ".add_team_membership", :vcr do
    it "invites a user to a team" do
      membership = @client.add_team_membership(946194, test_github_login)
      assert_requested :put, github_url("teams/946194/memberships/#{test_github_login}")
      expect(membership.status).to eq("active")
    end
  end # .add_team_membership

  describe ".remove_team_membership", :vcr do
    it "removes a user's membership for a team" do
      result = @client.remove_team_membership(946194, test_github_login)
      assert_requested :delete, github_url("teams/946194/memberships/#{test_github_login}")
      expect(result).to be true
    end
  end # .remove_team_membership

  describe ".organization_memberships", :vcr do
    it "returns all organization memberships for the user" do
      memberships = @client.organization_memberships
      expect(memberships).to be_kind_of Array
      assert_requested :get, github_url("/user/memberships/orgs")
    end
  end # .organization_memberships

  describe ".remove_organization_membership", :vcr do
    it "removes an organization membership for a given user" do
      stub_delete github_url("orgs/#{test_github_org}/memberships/#{test_github_login}")
      @client.remove_organization_membership(
        test_github_org,
        :user => test_github_login,
        :accept => "application/vnd.github.moondragon+json"
      )
      assert_requested :delete, github_url("/orgs/#{test_github_org}/memberships/#{test_github_login}")
    end
  end

  describe ".organization_membership", :vcr do
    it "returns an organization membership" do
      stub_get github_url("/user/memberships/orgs/#{test_github_org}")
      membership = @client.organization_membership(test_github_org)
      assert_requested :get, github_url("/user/memberships/orgs/#{test_github_org}")
    end

    it "returns an organization membership for a given user" do
      stub_get github_url("orgs/#{test_github_org}/memberships/#{test_github_login}")
      @client.organization_membership(
        test_github_org,
        :user => test_github_login,
        :accept => "application/vnd.github.moondragon+json"
      )
      assert_requested :get, github_url("/orgs/#{test_github_org}/memberships/#{test_github_login}")
    end

    it "returns an organization membership for a given user by the orgs id" do
      org_id = 42
      stub_get github_url("organizations/#{org_id}/memberships/#{test_github_login}")
      @client.organization_membership(
        org_id,
        :user => test_github_login,
        :accept => "application/vnd.github.moondragon+json"
      )
      assert_requested :get, github_url("/organizations/#{org_id}/memberships/#{test_github_login}")
    end
  end # .organization_membership

  describe ".update_organization_membership", :vcr do
    it "updates an organization membership" do
      stub_patch github_url("/user/memberships/orgs/#{test_github_org}")
      membership = @client.update_organization_membership(test_github_org, {:state => 'active'})
      assert_requested :patch, github_url("/user/memberships/orgs/#{test_github_org}")
    end

    it "adds or updates an organization membership for a given user" do
      stub_put github_url("/orgs/#{test_github_org}/memberships/#{test_github_login}")
      @client.update_organization_membership(
        test_github_org,
        :user => test_github_login,
        :role => "admin",
        :accept => "application/vnd.github.moondragon+json"
      )
      assert_requested :put, github_url("/orgs/#{test_github_org}/memberships/#{test_github_login}")
    end
  end # .update_organization_membership

  describe ".migrations", :vcr do
    it "starts a migration for an organization" do
      result = @client.start_migration(test_github_org, ["github-api/api-playground"])
      expect(result).to be_kind_of Sawyer::Resource
      assert_requested :post, github_url("/orgs/#{test_github_org}/migrations")
    end

    it "lists migrations for an organization" do
      result = @client.migrations(test_github_org)
      expect(result).to be_kind_of Array
      assert_requested :get, github_url("/orgs/#{test_github_org}/migrations")
    end

    it "gets the status of a migration" do
      result = @client.migration_status(test_github_org, 97)
      expect(result).to be_kind_of Sawyer::Resource
      assert_requested :get, github_url("/orgs/#{test_github_org}/migrations/97")
    end

    it "downloads a migration archive" do
      result = @client.migration_archive_url(test_github_org, 97)
      expect(result).to be_kind_of String
      assert_requested :get, github_url("/orgs/#{test_github_org}/migrations/97/archive")
    end

    it "unlocks a migrated repository" do
      @client.unlock_repository(test_github_org, 97, 'api-playground')
      expect(@client.last_response.status).to eq(204)
      assert_requested :delete, github_url("/orgs/#{test_github_org}/migrations/97/repos/api-playground/lock")
    end
  end # .migrations
end
