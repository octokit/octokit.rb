require 'helper'

describe Octokit::Client::Organizations do
  before do
    Octokit.reset!
    @client = oauth_client
  end

  describe ".organization", :vcr do
    it "returns an organization" do
      organization = @client.organization("codeforamerica")
      expect(organization.name).to eq "Code For America"
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
      expect(is_hubbernaut).to be_true
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
      expect(is_hubbernaut).to be_true
      assert_requested :get, github_url("/orgs/github/public_members/pengwynn")
    end
  end # .organization_public_member?

  describe ".organization_teams", :vcr do
    it "returns all teams for an organization" do
      teams = @client.organization_teams(test_github_org)
      expect(teams).to be_kind_of Array
      assert_requested :get, github_url("/orgs/#{test_github_org}/teams")
    end
  end # .organization_teams

  describe ".remove_organization_member", :vcr do
    it "removes a member from an organization" do
      VCR.eject_cassette
      VCR.turned_off do
        stub_delete github_url("/orgs/api-playground/members/api-padawan")
        result = @client.remove_organization_member("api-playground", "api-padawan")
        assert_requested :delete, github_url("/orgs/api-playground/members/api-padawan")
      end
    end
  end # .remove_organization_member

  describe ".user_teams", :vcr do
    it "lists all teams for the authenticated user" do
      teams = @client.user_teams
      assert_requested :get, github_url("/user/teams")
      expect(teams).to be_kind_of(Array)
    end
  end

  context "with team", :vcr do
    before(:each) do
      @team_name = "Test Team #{Time.now.to_f}"
      @team = @client.create_team(test_github_org, {:name => @team_name})
      use_vcr_placeholder_for(@team.id, '<ORGANIZATION_TEAM_ID>')
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
        expect(team.id).to eq @team.id
        assert_requested :get, github_url("/teams/#{@team.id}")
      end
    end # .team

    describe ".update_team", :vcr do
      it "updates a team" do
        team = @client.update_team(@team.id, :name => "API Jedi")
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

    describe ".remove_team_member", :vcr do
      it "removes a team member" do
        result = @client.remove_team_member(@team.id, test_github_login)
        assert_requested :delete, github_url("/teams/#{@team.id}/members/#{test_github_login}")
      end
    end # .remove_team_member

    describe ".add_team_member", :vcr do
      it "adds a team member" do
        result = @client.add_team_member(@team.id, test_github_login)
        assert_requested :put, github_url("/teams/#{@team.id}/members/#{test_github_login}")
      end
    end # .add_team_member

    describe ".team_member?", :vcr do
      it "checks if a user is member of a team" do
        is_team_member = @client.team_member?(@team.id, test_github_login)
        assert_requested :get, github_url("/teams/#{@team.id}/members/#{test_github_login}")
      end
    end # .team_member?

    describe ".team_repositories", :vcr do
      it "returns team repositories" do
        repositories = @client.team_repositories(@team.id)
        expect(repositories).to be_kind_of Array
        assert_requested :get, github_url("/teams/#{@team.id}/repos")
      end
    end # .team_repositories

    describe ".publicize_membership", :vcr do
      it "publicizes membership" do
        result = @client.publicize_membership(test_github_org, test_github_login)
        assert_requested :put, github_url("/orgs/#{test_github_org}/public_members/#{test_github_login}")
      end
    end # .publicize_membership

    describe ".unpublicize_membership", :vcr do
      it "unpublicizes membership" do
        result = @client.unpublicize_membership(test_github_org, test_github_login)
        assert_requested :delete, github_url("/orgs/#{test_github_org}/public_members/#{test_github_login}")
      end
    end # .unpublicize_membership

    describe ".delete_team", :vcr do
      it "deletes a team" do
        result = @client.delete_team(@team.id)
        assert_requested :delete, github_url("/teams/#{@team.id}")
      end
    end # .delete_team

    context "with organization repository" do
      before do
        options = {:organization => test_github_org}
        @test_repo = setup_test_repo(options).full_name
      end

      after do
        teardown_test_repo @test_repo
      end

      describe ".add_team_repository", :vcr do
        it "adds a team repository" do
          result = @client.add_team_repository(@team.id, @test_repo)
          assert_requested :put, github_url("/teams/#{@team.id}/repos/#{@test_repo}")
        end
      end # .add_team_repository

      describe ".team_repository?", :vcr do
        it "checks if a repo is managed by a specific team" do
          is_team_repo = @client.team_repository?(@team.id, @test_repo)
          expect(is_team_repo).to be_false
          assert_requested :get, github_url("/teams/#{@team.id}/repos/#{@test_repo}")
        end
      end

      context "with team repository" do
        before do
          @client.add_team_repository(@team.id, @test_repo)
        end

        describe ".remove_team_repository", :vcr do
          it "removes a team repository" do
            result = @client.remove_team_repository(@team.id, @test_repo)
            assert_requested :delete, github_url("/teams/#{@team.id}/repos/#{@test_repo}")
          end
        end #.remove_team_repository
      end # with team repository
    end # with organization repository
  end # with team
end # Octokit::Client::Organizations
