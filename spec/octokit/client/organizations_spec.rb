require File.expand_path('../../../spec_helper.rb', __FILE__)

describe Octokit::Client::Organizations do

  before do
    Octokit.reset!
    VCR.insert_cassette 'organizations'
    @client = basic_auth_client
  end

  after do
    Octokit.reset!
    VCR.eject_cassette
  end

  describe ".organization" do
    it "returns an organization" do
      organization = Octokit.organization("codeforamerica")
      organization.name.must_equal "Code For America"
      assert_requested :get, github_url("/orgs/codeforamerica")
    end
  end # .organization

  describe ".update_organization" do
    it "updates an organization" do
      organization = @client.update_organization("api-playground", {:name => "API Playground"})
      organization.login.must_equal "api-playground"
      assert_requested :patch, basic_github_url("/orgs/api-playground")
    end
  end # .update_organization

  describe ".organizations" do
    it "returns all organizations for a user" do
      organizations = Octokit.organizations("sferik")
      organizations.must_be_kind_of Array
      assert_requested :get, github_url("/users/sferik/orgs")
    end
    it "returns all organizations for the authenticated user" do
      organizations = @client.organizations
      organizations.must_be_kind_of Array
      assert_requested :get, basic_github_url("/user/orgs")
    end
  end # .organizations

  describe ".organization_repositories" do
    it "returns all public repositories for an organization" do
      repositories = Octokit.organization_repositories("codeforamerica")
      repositories.must_be_kind_of Array
      assert_requested :get, github_url("/orgs/codeforamerica/repos")
    end
  end # .organization_repositories

  describe ".organization_members" do
    it "returns all public members of an organization" do
      users = Octokit.organization_members("codeforamerica")
      users.must_be_kind_of Array
      assert_requested :get, github_url("/orgs/codeforamerica/members")
    end
  end # .organization_members

  describe ".organization_member?" do
    it "checks organization membership" do
      is_hubbernaut = Octokit.organization_member?('github', 'pengwynn')
      assert_requested :get, github_url("/orgs/github/members/pengwynn")
      assert is_hubbernaut
    end
  end # .organization_member?

  describe ".organization_public_member?" do
    it "checks publicized org membership" do
      is_hubbernaut = Octokit.organization_public_member?('github', 'pengwynn')
      assert is_hubbernaut
      assert_requested :get, github_url("/orgs/github/public_members/pengwynn")
    end
  end # .organization_public_member?

  describe ".remove_organization_member" do
    it "removes a member from an organization" do
      result = @client.remove_organization_member("api-playground", "api-padawan")
      assert_requested :delete, basic_github_url("/orgs/api-playground/members/api-padawan")
    end
  end # .remove_organization_member

  describe ".organization_teams" do
    it "returns all teams for an organization" do
      teams = @client.organization_teams("api-playground")
      teams.must_be_kind_of Array
      assert_requested :get, basic_github_url("/orgs/api-playground/teams")
    end
  end # .organization_teams

  describe ".create_team" do
    it "creates a team" do
      team = @client.create_team("api-playground", {:name => "Jedi"})
      team.name.must_equal "Jedi"
      assert_requested :post, basic_github_url("/orgs/api-playground/teams")
    end
  end # .create_team

  describe ".team" do
    it "returns a team" do
      team = @client.team(396670)
      team.name.must_equal "Jedi"
      assert_requested :get, basic_github_url("/teams/396670")
    end
  end # .team

  describe ".update_team" do
    it "updates a team" do
      team = @client.update_team(396670, :name => "API Jedi")
      assert_requested :patch, basic_github_url("/teams/396670")
    end
  end # .update_team


  describe ".team_members" do
    it "returns team members" do
      users = @client.team_members(396670)
      users.must_be_kind_of Array
      assert_requested :get, basic_github_url("/teams/396670/members")
    end
  end # .team_members

  describe ".add_team_member" do
    it "adds a team member" do
      result = @client.add_team_member(396670, "api-padawan")
      assert_requested :put, basic_github_url("/teams/396670/members/api-padawan")
    end
  end # .add_team_member

  describe ".remove_team_member" do
    it "removes a team member" do
      result = @client.remove_team_member(396670, "api-padawan")
      assert_requested :delete, basic_github_url("/teams/396670/members/api-padawan")
    end
  end # .remove_team_member

  describe ".team_member?" do
    it "checks if a user is member of a team" do
      is_team_member = @client.team_member?(396670, 'api-padawan')
      assert_requested :get, basic_github_url("/teams/396670/members/api-padawan")
    end
  end # .team_member?

  describe ".team_repositories" do
    it "returns team repositories" do
      repositories = @client.team_repositories(396670)
      repositories.must_be_kind_of Array
      assert_requested :get, basic_github_url("/teams/396670/repos")
    end
  end # .team_repositories

  describe ".add_team_repository" do
    it "adds a team repository" do
      result = @client.add_team_repository(396670, "api-playground/api-sandbox")
      assert_requested :put, basic_github_url("/teams/396670/repos/api-playground/api-sandbox")
    end
  end # .add_team_repository

  describe ".remove_team_repository" do
    it "removes a team repository" do
      result = @client.remove_team_repository(396670, "api-playground/api-sandbox")
      assert_requested :delete, basic_github_url("/teams/396670/repos/api-playground/api-sandbox")
    end
  end #.remove_team_repository

  describe ".publicize_membership" do
    it "publicizes membership" do
      result = @client.publicize_membership("api-playground", "api-padawan")
      assert_requested :put, basic_github_url("/orgs/api-playground/public_members/api-padawan")
    end
  end # .publicize_membership

  describe ".unpublicize_membership" do
    it "unpublicizes membership" do
      result = @client.unpublicize_membership("api-playground", "api-padawan")
      assert_requested :delete, basic_github_url("/orgs/api-playground/public_members/api-padawan")
    end
  end # .unpublicize_membership

  describe ".delete_team" do
    it "deletes a team" do
      result = @client.delete_team(396670)
      assert_requested :delete, basic_github_url("/teams/396670")
    end
  end # .delete_team

end
