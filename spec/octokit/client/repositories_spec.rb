require File.expand_path('../../../spec_helper.rb', __FILE__)

describe Octokit::Client::Repositories do

  before do
    Octokit.reset!
    VCR.insert_cassette 'repositories', :match_requests_on => [:uri, :method, :query, :body]
    @client = basic_auth_client
  end

  after do
    Octokit.reset!
    VCR.eject_cassette
  end

  describe ".repository" do
    it "returns the matching repository" do
      repository = Octokit.repository("sferik/rails_admin")
      repository.name.must_equal "rails_admin"
      assert_requested :get, github_url("/repos/sferik/rails_admin")
    end
  end # .repository

  describe ".update_repository" do
    it "updates the matching repository" do
      description = "It's epic"
      repository = @client.edit_repository("api-playground/api-sandbox", :description => description)
      repository.description.must_equal description
      assert_requested :patch, basic_github_url("/repos/api-playground/api-sandbox")
    end
  end # .update_repository

  describe ".repositories" do
    it "returns a user's repositories" do
      repositories = Octokit.repositories("sferik")
      repositories.must_be_kind_of Array
      assert_requested :get, github_url("/users/sferik/repos")
    end
    it "returns authenticated user's repositories" do
      repositories = @client.repositories
      repositories.must_be_kind_of Array
      assert_requested :get, basic_github_url("/user/repos")
    end
  end # .repositories

  describe ".all_repositories" do
    it "returns all repositories on github" do
      repositories = Octokit.all_repositories
      repositories.must_be_kind_of Array
      assert_requested :get, github_url("/repositories")
    end
  end # .all_repositories

  describe ".star" do
    it "stars a repository" do
      result = @client.star("sferik/rails_admin")
      assert result
      assert_requested :put, basic_github_url("/user/starred/sferik/rails_admin")
    end
  end # .star

  describe ".unstar" do
    it "unstars a repository" do
      result = @client.unstar("sferik/rails_admin")
      assert result
      assert_requested :delete, basic_github_url("/user/starred/sferik/rails_admin")
    end
  end # .unstar

  describe ".watch" do
    it "watches a repository" do
      result = @client.watch("sferik/rails_admin")
      assert result
      assert_requested :put, basic_github_url("/user/watched/sferik/rails_admin")
    end
  end # .watch

  describe ".unwatch" do
    it "unwatches a repository" do
      result = @client.unwatch("sferik/rails_admin")
      assert result
      assert_requested :delete, basic_github_url("/user/watched/sferik/rails_admin")
    end
  end # .unwatch

  describe ".fork" do
    it "forks a repository" do
      repository = @client.fork("sferik/rails_admin")
      assert_requested :post, basic_github_url("/repos/sferik/rails_admin/forks")
    end
  end # .fork

  describe ".create_repository" do
    it "creates a repository" do
      repository = @client.create_repository("an-repo")
      repository.name.must_equal "an-repo"
      assert_requested :post, basic_github_url("/user/repos")
    end
    it "creates a repository for an organization" do
      repository = @client.create_repository("an-org-repo", :organization => "api-playground")
      repository.name.must_equal "an-org-repo"
      assert_requested :post, basic_github_url("/orgs/api-playground/repos")
    end
  end # .create_repository

  describe ".set_private" do
    it "sets a repository private" do
      repository = @client.set_private("#{@client.login}/an-repo")
      assert_requested :patch, basic_github_url("/repos/#{@client.login}/an-repo")
    end
  end # .set_private

  describe ".set_public" do
    it "sets a repository public" do
      repository = @client.set_public("#{@client.login}/an-repo")
      assert_requested :patch, basic_github_url("/repos/#{@client.login}/an-repo")
    end
  end # .set_public

  describe ".deploy_keys" do
    it "returns a repository's deploy keys" do
      public_keys = @client.deploy_keys("#{@client.login}/an-repo")
      public_keys.must_be_kind_of Array
      assert_requested :get, basic_github_url("/repos/#{@client.login}/an-repo/keys")
    end
  end # .deploy_keys

  describe ".add_deploy_key" do
    it "adds a repository deploy keys" do
      public_key = @client.add_deploy_key("#{@client.login}/an-repo", "Padawan", "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDN/h7Hf5TA6G4p19deF8YS9COfuBd133GPs49tO6AU/DKIt7tlitbnUnttT0VbNZM4fplyinPu5vJl60eusn/Ngq2vDfSHP5SfgHfA9H8cnHGPYG7w6F0CujFB3tjBhHa3L6Je50E3NC4+BGGhZMpUoTClEI5yEzx3qosRfpfJu/2MUp/V2aARCAiHUlUoj5eiB15zC25uDsY7SYxkh1JO0ecKSMISc/OCdg0kwi7it4t7S/qm8Wh9pVGuA5FmVk8w0hvL+hHWB9GT02WPqiesMaS9Sj3t0yuRwgwzLDaudQPKKTKYXi+SjwXxTJ/lei2bZTMC4QxYbqfqYQt66pQB wynn.netherland+api-padawan@gmail.com" )
      assert_requested :post, basic_github_url("/repos/#{@client.login}/an-repo/keys")
    end
  end # .add_deploy_key

  describe ".remove_deploy_key" do
    it "removes a repository deploy keys" do
      public_key = @client.add_deploy_key("#{@client.login}/an-repo", "Padawan", "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDN/h7Hf5TA6G4p19deF8YS9COfuBd133GPs49tO6AU/DKIt7tlitbnUnttT0VbNZM4fplyinPu5vJl60eusn/Ngq2vDfSHP5SfgHfA9H8cnHGPYG7w6F0CujFB3tjBhHa3L6Je50E3NC4+BGGhZMpUoTClEI5yEzx3qosRfpfJu/2MUp/V2aARCAiHUlUoj5eiB15zC25uDsY7SYxkh1JO0ecKSMISc/OCdg0kwi7it4t7S/qm8Wh9pVGuA5FmVk8w0hvL+hHWB9GT02WPqiesMaS9Sj3t0yuRwgwzLDaudQPKKTKYXi+SjwXxTJ/lei2bZTMC4QxYbqfqYQt66pQB wynn.netherland+api-padawan@gmail.com" )
      result = @client.remove_deploy_key("#{@client.login}/an-repo", public_key.id)
      assert_requested :delete, basic_github_url("/repos/#{@client.login}/an-repo/keys/#{public_key.id}")
    end
  end # .remove_deploy_key

  describe ".collaborators" do
    it "returns a repository's collaborators" do
      collaborators = Octokit.collaborators("sferik/rails_admin")
      collaborators.must_be_kind_of Array
      assert_requested :get, github_url("/repos/sferik/rails_admin/collaborators")
    end
  end # .collaborators

  describe ".add_collaborator" do
    it "adds a repository collaborators" do
      result = @client.add_collaborator("#{@client.login}/an-repo", "pengwynn")
      assert_requested :put, basic_github_url("/repos/#{@client.login}/an-repo/collaborators/pengwynn")
    end
  end # .add_collaborator

  describe ".remove_collaborator" do
    it "removes a repository collaborators" do
      result = @client.remove_collaborator("#{@client.login}/an-repo", "pengwynn")
      assert_requested :delete, basic_github_url("/repos/#{@client.login}/an-repo/collaborators/pengwynn")
    end
  end # .remove_collaborator

  describe ".repository_teams" do
    it "returns all repository teams" do
      teams = @client.repository_teams("#{@client.login}/an-repo")
      assert_requested :get, basic_github_url("/repos/#{@client.login}/an-repo/teams")
      teams.must_be_kind_of Array
    end
  end # .repository_teams

  describe ".contributors" do
    it "returns repository contributors" do
      contributors = @client.contributors("#{@client.login}/rails_admin", true)
      contributors.must_be_kind_of Array
      assert_requested :get, basic_github_url("/repos/#{@client.login}/rails_admin/contributors?anon=1")
    end
    it "returns repository contributors excluding anonymous" do
      contributors = @client.contributors("#{@client.login}/rails_admin")
      contributors.must_be_kind_of Array
      assert_requested :get, basic_github_url("/repos/#{@client.login}/rails_admin/contributors")
    end
  end # .contributors

  describe ".stargazers" do
    it "returns all repository stargazers" do
      stargazers = Octokit.stargazers("sferik/rails_admin")
      stargazers.must_be_kind_of Array
      assert_requested :get, github_url("/repos/sferik/rails_admin/stargazers")
    end
  end # .stargazers

  describe ".watchers" do
    it "returns all repository watchers" do
      watchers = Octokit.watchers("sferik/rails_admin")
      watchers.must_be_kind_of Array
      assert_requested :get, github_url("/repos/sferik/rails_admin/watchers")
    end
  end # .watchers

  describe ".network" do
    it "returns a repository's network" do
      network = Octokit.network("sferik/rails_admin")
      network.must_be_kind_of Array
      assert_requested :get, github_url("/repos/sferik/rails_admin/forks")
    end
  end # .network

  describe ".languages" do
    it "returns a repository's languages" do
      languages = Octokit.languages("sferik/rails_admin")
      assert languages[:Ruby]
      assert_requested :get, github_url("/repos/sferik/rails_admin/languages")
    end
  end # .languages

  describe ".tags" do
    it "returns a repository's tags" do
      tags = Octokit.tags("pengwynn/octokit")
      tags.must_be_kind_of Array
      assert_requested :get, github_url("/repos/pengwynn/octokit/tags")
    end
  end # .tags

  describe ".branches" do
    it "returns a repository's branches" do
      branches = Octokit.branches("pengwynn/octokit")
      branches.must_be_kind_of Array
      assert_requested :get, github_url("/repos/pengwynn/octokit/branches")
    end
    it "returns a single branch" do
      branch = Octokit.branch("pengwynn/octokit", "master")
      assert branch.commit.sha
      assert_requested :get, github_url("/repos/pengwynn/octokit/branches/master")
    end
  end # .branches

  describe ".hooks" do
    it "returns a repository's hooks" do
      hooks = @client.hooks("#{@client.login}/rails_admin")
      hooks.must_be_kind_of Array
      assert_requested :get, basic_github_url("/repos/#{@client.login}/rails_admin/hooks")
    end
  end

  describe ".create_hook" do
    it "creates a hook" do
      hook = @client.create_hook("#{@client.login}/rails_admin", "railsbp", {:railsbp_url => "http://railsbp.com", :token => "xAAQZtJhYHGagsed1kYR"})
      assert_requested :post, basic_github_url("/repos/#{@client.login}/rails_admin/hooks")
    end
  end # .create_hook


  describe ".hook" do
    it "returns a repository's single hook" do
      hook = @client.create_hook("#{@client.login}/rails_admin", "railsbp", {:railsbp_url => "http://railsbp.com", :token => "xAAQZtJhYHGagsed1kYR"})
      hook = @client.hook("#{@client.login}/rails_admin", hook.id)
      assert_requested :get, basic_github_url("/repos/#{@client.login}/rails_admin/hooks/#{hook.id}")
    end
  end # .hook

  describe ".edit_hook" do
    it "edits a hook" do
      hook = @client.create_hook("#{@client.login}/rails_admin", "railsbp", {:railsbp_url => "http://railsbp.com", :token => "xAAQZtJhYHGagsed1kYR"})
      hook = @client.edit_hook("#{@client.login}/rails_admin", hook.id, "railsbp", {:railsbp_url => "https://railsbp.com", :token => "xAAQZtJhYHGagsed1kYR"})
      assert_requested :patch, basic_github_url("/repos/#{@client.login}/rails_admin/hooks/#{hook.id}")
    end
  end # .edit_hook

  describe ".test_hook" do
    it "tests a hook" do
      hook = @client.create_hook("#{@client.login}/rails_admin", "railsbp", {:railsbp_url => "http://railsbp.com", :token => "xAAQZtJhYHGagsed1kYR"})
      @client.test_hook("#{@client.login}/rails_admin", hook.id)
      assert_requested :post, basic_github_url("/repos/#{@client.login}/rails_admin/hooks/#{hook.id}/tests")
    end
  end # .test_hook

  describe ".remove_hook" do
    it "removes a hook" do
      hook = @client.create_hook("#{@client.login}/rails_admin", "railsbp", {:railsbp_url => "http://railsbp.com", :token => "xAAQZtJhYHGagsed1kYR"})
      @client.remove_hook("#{@client.login}/rails_admin", hook.id)
      assert_requested :delete, basic_github_url("/repos/#{@client.login}/rails_admin/hooks/#{hook.id}")
    end
  end # .remove_hook

  describe ".assignees" do
    it "lists all the available assignees (owner + collaborators)" do
      assignees = Octokit.repo_assignees("pengwynn/octokit")
      assignees.must_be_kind_of Array
      assert_requested :get, github_url("/repos/pengwynn/octokit/assignees")
    end
  end # .assignees

  describe ".check_assignee" do
    it "checks to see if a particular user is an assignee for a repository" do
      is_assignee = Octokit.check_assignee("pengwynn/octokit", 'andrew')
      assert_requested :get, github_url("/repos/pengwynn/octokit/assignees/andrew")
    end
  end # .check_assignee

  describe ".subscribers" do
    it "lists all the users watching the repository" do
      subscribers = Octokit.subscribers("pengwynn/octokit")
      subscribers.must_be_kind_of Array
      assert_requested :get, github_url("/repos/pengwynn/octokit/subscribers")
    end
  end # .subscribers

  describe ".subscription" do
    it "returns a repository subscription" do
      subscription = @client.subscription("pengwynn/octokit")
      assert_requested :get, basic_github_url("/repos/pengwynn/octokit/subscription")
    end
  end # .subscription

  describe ".update_subscription" do
    it "updates a repository subscription" do
      subscription = @client.update_subscription("pengwynn/octokit", :subscribed => false)
      assert_requested :put, basic_github_url("/repos/pengwynn/octokit/subscription")
    end
  end # .update_subscription

  describe ".delete_subscription" do
    it "returns true when repo subscription deleted" do
      result = @client.delete_subscription("pengwynn/octokit")
      assert_requested :delete, basic_github_url("/repos/pengwynn/octokit/subscription")
    end
  end # .delete_subscription

  describe ".delete_repository" do
    it "deletes a repository" do
      repo = @client.create_repository("imma-delete-this")
      result = @client.delete_repository("#{@client.login}/imma-delete-this")
      assert_requested :delete, basic_github_url("/repos/#{@client.login}/imma-delete-this")
    end
  end # .delete_repository
end
