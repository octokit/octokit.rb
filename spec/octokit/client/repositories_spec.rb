require 'helper'

describe Octokit::Client::Repositories do
  before do
    Octokit.reset!
    @client = oauth_client
  end

  describe ".repository", :vcr do
    it "returns the matching repository" do
      repository = @client.repository("sferik/rails_admin")
      expect(repository.name).to eq "rails_admin"
      assert_requested :get, github_url("/repos/sferik/rails_admin")
    end
  end # .repository

  describe ".set_private" do
    it "sets a repository private" do
      VCR.turned_off do
        repo_name = "api-playground/api-sandbox"
        # Stub this because Padawan is on a free plan
        request = stub_patch(github_url("/repos/#{repo_name}")).
          with(:body => {:private => true, :name => "api-sandbox"}.to_json)
        repository = @client.set_private repo_name
        assert_requested request
      end
    end
  end # .set_private

  describe ".set_public" do
    it "sets a repository public" do
      VCR.turned_off do
        repo_name = "api-playground/api-sandbox"
        # Stub this because Padawan is on a free plan
        request = stub_patch(github_url("/repos/#{repo_name}")).
          with(:body => {:private => false, :name => "api-sandbox"}.to_json)
        repository = @client.set_public repo_name
        assert_requested request
      end
    end
  end # .set_public

  describe ".create_repository", :vcr do
    before do
      @repo = basic_auth_client.create_repository(test_repo, :organization => test_github_org)
    end

    after do
      teardown_test_repo @repo.full_name
    end

    it "creates a repository for an organization", :vcr do
      expect(@repo.name).to be
      assert_requested :post, basic_github_url("/orgs/#{test_github_org}/repos")
    end
  end

  describe ".add_deploy_key" do
    it "adds a repository deploy keys" do
      VCR.turned_off do
        repo_name = "api-playground/api-sandbox"
        request = stub_post(github_url("/repos/#{repo_name}/keys"))
        public_key = @client.add_deploy_key(repo_name, "Padawan", "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDN/h7Hf5TA6G4p19deF8YS9COfuBd133GPs49tO6AU/DKIt7tlitbnUnttT0VbNZM4fplyinPu5vJl60eusn/Ngq2vDfSHP5SfgHfA9H8cnHGPYG7w6F0CujFB3tjBhHa3L6Je50E3NC4+BGGhZMpUoTClEI5yEzx3qosRfpfJu/2MUp/V2aARCAiHUlUoj5eiB15zC25uDsY7SYxkh1JO0ecKSMISc/OCdg0kwi7it4t7S/qm8Wh9pVGuA5FmVk8w0hvL+hHWB9GT02WPqiesMaS9Sj3t0yuRwgwzLDaudQPKKTKYXi+SjwXxTJ/lei2bZTMC4QxYbqfqYQt66pQB wynn.netherland+api-padawan@gmail.com" )
        assert_requested request
      end
    end
  end # .add_deploy_key

  describe ".deploy_key" do
    it "returns a specific deploy key for a repo" do
      VCR.turned_off do
        repo = "api-playground/api-sandbox"
        key_id = 8675309
        request = stub_get github_url "/repos/#{repo}/keys/#{key_id}"
        deploy_key = @client.deploy_key repo, key_id
        assert_requested request
      end
    end
  end # .deploy_key

  describe ".edit_deploy_key" do
    it "modifies a deploy key" do
      VCR.turned_off do
        repo = "api-playground/api-sandbox"
        key_id = 8675309
        request = stub_patch github_url "/repos/#{repo}/keys/#{key_id}"
        updated_deploy_key = @client.edit_deploy_key(repo, key_id, :title => 'Staging')
        assert_requested request
      end
    end
  end # .edit_deploy_key

  describe ".remove_deploy_key" do
    it "removes a repository deploy keys" do
      VCR.turned_off do
        repo_name = "api-playground/api-sandbox"
        request = stub_delete(github_url("/repos/#{repo_name}/keys/1234"))
        @client.remove_deploy_key(repo_name, 1234)
        assert_requested request
      end
    end
  end # .remove_deploy_key

  context "with repository" do
    before(:each) do
      @repo = setup_test_repo(:auto_init => true)
    end

    after(:each) do
      teardown_test_repo @repo.full_name
    end

    describe ".create_repository", :vcr do
      it "creates a repository" do
        expect(@repo.name).to be
        assert_requested :post, basic_github_url("/user/repos")
      end
    end # .create_repository

    describe ".update_repository", :vcr do
      it "updates the matching repository" do
        description = "It's epic"
        repository = @client.edit_repository(@repo.full_name, :description => description)
        expect(repository.description).to eq description
        assert_requested :patch, github_url("/repos/#{@repo.full_name}")
      end
    end # .update_repository

    describe ".deploy_keys", :vcr do
      it "returns a repository's deploy keys" do
        public_keys = @client.deploy_keys @repo.full_name
        expect(public_keys).to be_kind_of Array
        assert_requested :get, github_url("/repos/#{@repo.full_name}/keys")
      end
    end # .deploy_keys

    describe ".add_collaborator", :vcr do
      it "adds a repository collaborators" do
        begin
          @client.remove_collaborator(@repo.full_name, "api-padawan")
        rescue Octokit::NotFound
        end
        result = @client.add_collaborator(@repo.full_name, "api-padawan")
        assert_requested :put, github_url("/repos/#{@repo.full_name}/collaborators/api-padawan")
      end
    end # .add_collaborator

    describe ".remove_collaborator", :vcr do
      it "removes a repository collaborators" do
        begin
          @client.add_collaborator(@repo.full_name, "api-padawan")
        rescue Octokit::UnprocessableEntity
        end

        result = @client.remove_collaborator(@repo.full_name, "api-padawan")
        assert_requested :delete, github_url("/repos/#{@repo.full_name}/collaborators/api-padawan")
      end
    end # .remove_collaborator

    describe ".collaborator?", :vcr do
      it "checks if a user is a repository collaborator" do
        begin
          @client.add_collaborator(@repo.full_name, "api-padawan")
        rescue Octokit::UnprocessableEntity
        end

        result = @client.collaborator?(@repo.full_name, "api-padawan")
        assert_requested :get, github_url("/repos/#{@repo.full_name}/collaborators/api-padawan")
      end
    end # .collaborator?

    describe ".repository_teams", :vcr do
      it "returns all repository teams" do
        teams = @client.repository_teams(@repo.full_name)
        assert_requested :get, github_url("/repos/#{@repo.full_name}/teams")
        expect(teams).to be_kind_of Array
      end
    end # .repository_teams

    describe ".hooks", :vcr do
      it "returns a repository's hooks" do
        hooks = @client.hooks(@repo.full_name)
        expect(hooks).to be_kind_of Array
        assert_requested :get, github_url("/repos/#{@repo.full_name}/hooks")
      end
    end

    context "with hook" do
      before(:each) do
        @hook = @client.create_hook(@repo.full_name, "railsbp", {:railsbp_url => "http://railsbp.com", :token => "xAAQZtJhYHGagsed1kYR"})
      end

      after(:each) do
        @client.remove_hook(@repo.full_name, @hook.id)
      end

      describe ".create_hook", :vcr do
        it "creates a hook" do
          assert_requested :post, github_url("/repos/#{@repo.full_name}/hooks")
        end
      end # .create_hook

      describe ".hook", :vcr do
        it "returns a repository's single hook" do
          @client.hook(@repo.full_name, @hook.id)
          assert_requested :get, github_url("/repos/#{@repo.full_name}/hooks/#{@hook.id}")
        end
      end # .hook

      describe ".edit_hook", :vcr do
        it "edits a hook" do
          hook = @client.edit_hook(@repo.full_name, @hook.id, "railsbp", {:railsbp_url => "https://railsbp.com", :token => "xAAQZtJhYHGagsed1kYR"})
          assert_requested :patch, github_url("/repos/#{@repo.full_name}/hooks/#{@hook.id}")
        end
      end # .edit_hook

      describe ".test_hook", :vcr do
        it "tests a hook" do
          hook = @client.create_hook(@repo.full_name, "railsbp", {:railsbp_url => "http://railsbp.com", :token => "xAAQZtJhYHGagsed1kYR"})
          @client.test_hook(@repo.full_name, @hook.id)
          assert_requested :post, github_url("/repos/#{@repo.full_name}/hooks/#{@hook.id}/tests")
        end
      end # .test_hook

      describe ".remove_hook", :vcr do
        it "removes a hook" do
          @client.remove_hook(@repo.full_name, @hook.id)
          assert_requested :delete, github_url("/repos/#{@repo.full_name}/hooks/#{@hook.id}")
        end
      end # .remove_hook
    end # with hook

    describe ".delete_repository", :vcr do
      it "deletes a repository" do
        result = basic_auth_client.delete_repository(@repo.full_name)
        assert_requested :delete, basic_github_url("/repos/#{@repo.full_name}")
      end
    end # .delete_repository
  end # with repository

  describe ".repositories", :vcr do
    it "returns a user's repositories" do
      repositories = Octokit.repositories("sferik")
      expect(repositories).to be_kind_of Array
      assert_requested :get, github_url("/users/sferik/repos")
    end
    it "returns authenticated user's repositories" do
      repositories = @client.repositories
      expect(repositories).to be_kind_of Array
      assert_requested :get, github_url("/user/repos")
    end
  end # .repositories

  describe ".all_repositories", :vcr do
    it "returns all repositories on github" do
      repositories = Octokit.all_repositories
      expect(repositories).to be_kind_of Array
      assert_requested :get, github_url("/repositories")
    end
  end # .all_repositories

  describe ".star", :vcr do
    it "stars a repository" do
      result = @client.star("sferik/rails_admin")
      expect(result).to be_true
      assert_requested :put, github_url("/user/starred/sferik/rails_admin")
    end
  end # .star

  describe ".unstar", :vcr do
    it "unstars a repository" do
      result = @client.unstar("sferik/rails_admin")
      expect(result).to be_true
      assert_requested :delete, github_url("/user/starred/sferik/rails_admin")
    end
  end # .unstar

  describe ".watch", :vcr do
    it "watches a repository" do
      result = @client.watch("sferik/rails_admin")
      expect(result).to be_true
      assert_requested :put, github_url("/user/watched/sferik/rails_admin")
    end
  end # .watch

  describe ".unwatch", :vcr do
    it "unwatches a repository" do
      result = @client.unwatch("sferik/rails_admin")
      expect(result).to be_true
      assert_requested :delete, github_url("/user/watched/sferik/rails_admin")
    end
  end # .unwatch

  describe ".fork", :vcr do
    it "forks a repository" do
      repository = @client.fork("sferik/rails_admin")
      assert_requested :post, github_url("/repos/sferik/rails_admin/forks")

      # cleanup
      basic_auth_client.delete_repository(repository.full_name)
    end
  end # .fork

  describe ".collaborators", :vcr do
    it "returns a repository's collaborators" do
      collaborators = Octokit.collaborators("sferik/rails_admin")
      expect(collaborators).to be_kind_of Array
      assert_requested :get, github_url("/repos/sferik/rails_admin/collaborators")
    end
  end # .collaborators

  describe ".contributors", :vcr do
    it "returns repository contributors" do
      contributors = Octokit.contributors("sferik/rails_admin", true)
      expect(contributors).to be_kind_of Array
      assert_requested :get, github_url("/repos/sferik/rails_admin/contributors?anon=1")
    end
    it "returns repository contributors excluding anonymous" do
      contributors = Octokit.contributors("sferik/rails_admin")
      expect(contributors).to be_kind_of Array
      assert_requested :get, github_url("/repos/sferik/rails_admin/contributors")
    end
  end # .contributors

  describe ".stargazers", :vcr do
    it "returns all repository stargazers" do
      stargazers = Octokit.stargazers("sferik/rails_admin")
      expect(stargazers).to be_kind_of Array
      assert_requested :get, github_url("/repos/sferik/rails_admin/stargazers")
    end
  end # .stargazers

  describe ".watchers", :vcr do
    it "returns all repository watchers" do
      watchers = Octokit.watchers("sferik/rails_admin")
      expect(watchers).to be_kind_of Array
      assert_requested :get, github_url("/repos/sferik/rails_admin/watchers")
    end
  end # .watchers

  describe ".network", :vcr do
    it "returns a repository's network" do
      network = Octokit.network("sferik/rails_admin")
      expect(network).to be_kind_of Array
      assert_requested :get, github_url("/repos/sferik/rails_admin/forks")
    end
  end # .network

  describe ".languages", :vcr do
    it "returns a repository's languages" do
      languages = Octokit.languages("sferik/rails_admin")
      expect(languages[:Ruby]).to_not be_nil
      assert_requested :get, github_url("/repos/sferik/rails_admin/languages")
    end
  end # .languages

  describe ".tags", :vcr do
    it "returns a repository's tags" do
      tags = Octokit.tags("octokit/octokit.rb")
      expect(tags).to be_kind_of Array
      assert_requested :get, github_url("/repos/octokit/octokit.rb/tags")
    end
  end # .tags

  describe ".branches", :vcr do
    it "returns a repository's branches" do
      branches = Octokit.branches("octokit/octokit.rb")
      expect(branches).to be_kind_of Array
      assert_requested :get, github_url("/repos/octokit/octokit.rb/branches")
    end
    it "returns a single branch" do
      branch = Octokit.branch("octokit/octokit.rb", "master")
      expect(branch.commit.sha).to_not be_nil
      assert_requested :get, github_url("/repos/octokit/octokit.rb/branches/master")
    end
  end # .branches

  describe ".assignees", :vcr do
    it "lists all the available assignees (owner + collaborators)" do
      assignees = Octokit.repo_assignees("octokit/octokit.rb")
      expect(assignees).to be_kind_of Array
      assert_requested :get, github_url("/repos/octokit/octokit.rb/assignees")
    end
  end # .assignees

  describe ".check_assignee", :vcr do
    it "checks to see if a particular user is an assignee for a repository" do
      is_assignee = Octokit.check_assignee("octokit/octokit.rb", 'andrew')
      assert_requested :get, github_url("/repos/octokit/octokit.rb/assignees/andrew")
    end
  end # .check_assignee

  describe ".subscribers", :vcr do
    it "lists all the users watching the repository" do
      subscribers = Octokit.subscribers("octokit/octokit.rb")
      expect(subscribers).to be_kind_of Array
      assert_requested :get, github_url("/repos/octokit/octokit.rb/subscribers")
    end
  end # .subscribers

  describe ".update_subscription", :vcr do
    it "updates a repository subscription" do
      subscription = @client.update_subscription("octokit/octokit.rb", :subscribed => false)
      assert_requested :put, github_url("/repos/octokit/octokit.rb/subscription")
    end
  end # .update_subscription

  describe ".subscription", :vcr do
    context "with a subscription" do
      before do
        @client.update_subscription("octokit/octokit.rb", :subscribed => true)
      end

      it "returns a repository subscription" do
        subscription = @client.subscription("octokit/octokit.rb")
        assert_requested :get, github_url("/repos/octokit/octokit.rb/subscription")
      end
    end

    context "without a subscription" do
      before do
        begin
          @client.delete_subscription("octokit/octokit.rb")
        rescue Octokit::NotFound
        end
      end

      it "raises Octokit::NotFound" do
        expect {
          @client.subscription("octokit/octokit.rb")
        }.to raise_error(Octokit::NotFound)
      end
    end
  end # .subscription

  describe ".delete_subscription", :vcr do
    it "returns true when repo subscription deleted" do
      result = @client.delete_subscription("octokit/octokit.rb")
      assert_requested :delete, github_url("/repos/octokit/octokit.rb/subscription")
    end
  end # .delete_subscription

  describe ".repository?", :vcr do
    it "returns true if the repository exists" do
      result = @client.repository?("sferik/rails_admin")
      expect(result).to be_true
      assert_requested :get, github_url("/repos/sferik/rails_admin")
    end
    it "returns false if the repository doesn't exist" do
      result = @client.repository?("pengwynn/octokit")
      expect(result).to be_false
      assert_requested :get, github_url("/repos/pengwynn/octokit")
    end
  end # .repository?
end # Octokit::Client::Repositories
