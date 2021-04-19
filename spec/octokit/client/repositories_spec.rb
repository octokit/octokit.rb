require 'helper'

describe Octokit::Client::Repositories do
  before do
    Octokit.reset!
    @client = oauth_client
  end

  describe ".repository", :vcr do
    it "returns the matching repository" do
      repository = @client.repository("sferik/rails_admin")
      expect(repository.name).to eq("rails_admin")
      assert_requested :get, github_url("/repos/sferik/rails_admin")
    end

    it "returns the repository, including topics" do
      repository = @client.repository("github/linguist", :accept => Octokit::Preview::PREVIEW_TYPES.fetch(:topics))
      expect(repository.topics).to be_kind_of Array
      expect(repository.topics).to include("syntax-highlighting")
    end
  end # .repository

  describe ".set_private" do
    it "sets a repository private" do
      # Stub this because Padawan is on a free plan
      request = stub_patch(github_url("/repos/#{@test_repo}")).
        with(:body => {:private => true, :name => test_github_repository}.to_json)
      @client.set_private @test_repo
      assert_requested request
    end
  end # .set_private

  describe ".set_public" do
    it "sets a repository public" do
      # Stub this because Padawan is on a free plan
      request = stub_patch(github_url("/repos/#{@test_repo}")).
        with(:body => {:private => false, :name => test_github_repository}.to_json)
      @client.set_public @test_repo
      assert_requested request
    end
  end # .set_public

  describe ".create_repository", :vcr do
    it "creates a repository for an organization" do
      repository = @client.create_repository("an-org-repo", :organization => test_github_org)
      expect(repository.name).to eq("an-org-repo")
      assert_requested :post, github_url("/orgs/#{test_github_org}/repos")

      # cleanup
      begin
        @client.delete_repository("#{test_github_org}/an-org-repo")
      rescue Octokit::NotFound
      end
    end

    it "creates a repository for an organization by ID" do
      request = stub_post(github_url("/organizations/1/repos"))
      repository = @client.create_repository("an-org-repo", :organization => 1)
      assert_requested request
    end
  end

  describe ".edit_repository", :vcr do
    before(:each) do
      @repo = @client.create_repository(test_github_repository)
    end

    after(:each) do
      @client.delete_repository(@repo.full_name)
    end

    context "is_template is passed in params", :vcr do
      it "uses the template repositories preview flag and succeeds" do
        @client.edit_repository(@repo.full_name, is_template: true)
        expect(@client.repository(@repo.full_name).is_template).to be true
      end
    end
  end

  describe ".add_deploy_key" do
    it "adds a repository deploy keys" do
      request = stub_post(github_url("/repos/#{@test_repo}/keys"))
      @client.add_deploy_key(@test_repo, "Padawan", "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDN/h7Hf5TA6G4p19deF8YS9COfuBd133GPs49tO6AU/DKIt7tlitbnUnttT0VbNZM4fplyinPu5vJl60eusn/Ngq2vDfSHP5SfgHfA9H8cnHGPYG7w6F0CujFB3tjBhHa3L6Je50E3NC4+BGGhZMpUoTClEI5yEzx3qosRfpfJu/2MUp/V2aARCAiHUlUoj5eiB15zC25uDsY7SYxkh1JO0ecKSMISc/OCdg0kwi7it4t7S/qm8Wh9pVGuA5FmVk8w0hvL+hHWB9GT02WPqiesMaS9Sj3t0yuRwgwzLDaudQPKKTKYXi+SjwXxTJ/lei2bZTMC4QxYbqfqYQt66pQB wynn.netherland+api-padawan@gmail.com" )
      assert_requested request
    end
  end # .add_deploy_key

  describe ".deploy_key" do
    it "returns a specific deploy key for a repo" do
      key_id = 8675309
      request = stub_get github_url "/repos/#{@test_repo}/keys/#{key_id}"
      @client.deploy_key @test_repo, key_id
      assert_requested request
    end
  end # .deploy_key

  describe ".edit_deploy_key" do
    it "modifies a deploy key" do
      key_id = 8675309
      request = stub_patch(github_url "/repos/#{@test_repo}/keys/#{key_id}").to_return(:status => 405)
      expect { @client.edit_deploy_key(@test_repo, key_id, :title => 'Staging') }.
        to raise_error(Octokit::MethodNotAllowed)
      assert_requested request
    end
  end # .edit_deploy_key

  describe ".remove_deploy_key" do
    it "removes a repository deploy keys" do
      request = stub_delete(github_url("/repos/#{@test_repo}/keys/1234"))
      @client.remove_deploy_key(@test_repo, 1234)
      assert_requested request
    end
  end # .remove_deploy_key

  context "with repository" do
    before(:each) do
      @repo = @client.create_repository(test_github_repository, auto_init: true)
    end

    after(:each) do
      begin
        @client.delete_repository(@repo.full_name)
      rescue Octokit::NotFound
      end
    end

    describe ".create_repository_from_template", :vcr do
      before do
        @client.edit_repository(@repo.full_name, is_template: true)
      end

      it "generates a repository from the template" do
        @client.create_repository_from_template(@repo.id, "Cloned repo")
        assert_requested :post, github_url("/repositories/#{@repo.id}/generate")
      end
    end

    describe ".create_repository", :vcr do
      it "creates a repository" do
        expect(@repo.name).to eq("an-repo")
        assert_requested :post, github_url("/user/repos")
      end
    end # .create_repository

    describe ".update_repository", :vcr do
      it "updates the matching repository" do
        description = "It's epic"
        repository = @client.edit_repository(@repo.full_name, :description => description)
        expect(repository.description).to eq(description)
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
          @client.remove_collaborator(@repo.full_name, "pengwynn")
        rescue Octokit::NotFound
        end
        @client.add_collaborator(@repo.full_name, "pengwynn")
        assert_requested :put, github_url("/repos/#{@repo.full_name}/collaborators/pengwynn")
      end
    end # .add_collaborator

    describe ".remove_collaborator", :vcr do
      it "removes a repository collaborators" do
        begin
          @client.add_collaborator(@repo.full_name, "pengwynn")
        rescue Octokit::UnprocessableEntity
        end

        @client.remove_collaborator(@repo.full_name, "pengwynn")
        assert_requested :delete, github_url("/repos/#{@repo.full_name}/collaborators/pengwynn")
      end
    end # .remove_collaborator

    describe ".collaborator?", :vcr do
      it "checks if a user is a repository collaborator" do
        begin
          @client.add_collaborator(@repo.full_name, "pengwynn")
        rescue Octokit::UnprocessableEntity
        end

        @client.collaborator?(@repo.full_name, "pengwynn")
        assert_requested :get, github_url("/repos/#{@repo.full_name}/collaborators/pengwynn")
      end
    end # .collaborator?

    describe ".repository_teams", :vcr do
      it "returns all repository teams" do
        teams = @client.repository_teams(@repo.full_name)
        assert_requested :get, github_url("/repos/#{@repo.full_name}/teams")
        expect(teams).to be_kind_of Array
      end
    end # .repository_teams

    describe ".delete_repository", :vcr do
      it "deletes a repository" do
        @client.delete_repository("#{@repo.full_name}")
        assert_requested :delete, github_url("/repos/#{@repo.full_name}")
      end
    end # .delete_repository

    describe ".dispatch_event", :vcr do
      it "creates a dispatch event" do
        event_dispatched = @client.dispatch_event(@repo.full_name, 'test dispatch event')
        expect(event_dispatched).to be_truthy
        assert_requested :post, github_url("/repos/#{@repo.full_name}/dispatches")
      end
    end # .dispatch_event

    describe ".branch_protection", :vcr do
      it "returns nil for an unprotected branch" do
        branch_protection = @client.branch_protection(@repo.full_name, "master", accept: preview_header)
        expect(branch_protection).to be_nil
        assert_requested :get, github_url("/repos/#{@repo.full_name}/branches/master/protection")
      end

      context "with protected branch" do
        before(:each) do
          protect_params = {
            accept: preview_header,
            enforce_admins: true,
            required_pull_request_reviews: nil,
            required_status_checks: { strict: true, contexts: []}
          }

          @client.protect_branch(@repo.full_name, "master", protect_params)
        end

        it "returns branch protection summary" do
          branch_protection = @client.branch_protection(@repo.full_name, "master", accept: preview_header)
          expect(branch_protection).not_to be_nil
          assert_requested :get, github_url("/repos/#{@repo.full_name}/branches/master/protection")
        end
      end
    end # .branch_protection

    describe ".topics", :vcr do
      it "returns repository topics" do
        topics = Octokit.topics(@repo.full_name, :accept => Octokit::Preview::PREVIEW_TYPES.fetch(:topics))
        expect(topics.names).to include("octokit")
        assert_requested :get, github_url("/repos/#{@repo.full_name}/topics")
      end
    end # .topics

    describe ".replace_all_topics", :vcr do
      it "replaces all topics for a repository" do
        new_topics = ["octocat", "github", "github-api"]
        options = {
          :accept => Octokit::Preview::PREVIEW_TYPES.fetch(:topics)
        }
        topics = @client.replace_all_topics(@repo.full_name, new_topics, options)
        expect(topics.names.sort).to eq(new_topics.sort)
        assert_requested :put, github_url("/repos/#{@repo.full_name}/topics")
      end
    end # .replace_all_topics
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
      expect(result).to be true
      assert_requested :put, github_url("/user/starred/sferik/rails_admin")
    end
  end # .star

  describe ".unstar", :vcr do
    it "unstars a repository" do
      result = @client.unstar("sferik/rails_admin")
      expect(result).to be true
      assert_requested :delete, github_url("/user/starred/sferik/rails_admin")
    end
  end # .unstar

  describe ".watch", :vcr do
    it "watches a repository" do
      result = @client.watch("sferik/rails_admin")
      expect(result).to be true
      assert_requested :put, github_url("/user/watched/sferik/rails_admin")
    end
  end # .watch

  describe ".unwatch", :vcr do
    it "unwatches a repository" do
      result = @client.unwatch("sferik/rails_admin")
      expect(result).to be true
      assert_requested :delete, github_url("/user/watched/sferik/rails_admin")
    end
  end # .unwatch

  describe ".fork", :vcr do
    it "forks a repository" do
      repository = @client.fork("sferik/rails_admin")
      assert_requested :post, github_url("/repos/sferik/rails_admin/forks")

      # cleanup
      @client.delete_repository(repository.full_name)
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
      expect(languages[:Ruby]).not_to be_nil
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
      expect(branch.commit.sha).not_to be_nil
      assert_requested :get, github_url("/repos/octokit/octokit.rb/branches/master")
    end
  end # .branches

  context 'with repository' do
    before(:each) do
      @repo = @client.create_repository("an-repo", auto_init: true)
    end

    after(:each) do
      begin
        @client.delete_repository(@repo.full_name)
      rescue Octokit::NotFound
      end
    end

    describe ".permission_level", :vcr do
      it "returns the permission level a user has on a repository" do
        @client.permission_level(@repo.full_name, "lizzhale")
        assert_requested :get, github_url("/repos/#{@repo.full_name}/collaborators/lizzhale/permission")
      end
    end # .permission_level

    describe ".protect_branch", :vcr do
      it "protects a single branch" do
        branch = @client.protect_branch(@repo.full_name, "master",
                                        { accept: preview_header,
                                          required_status_checks: {
                                            strict: true,
                                            contexts: []
                                          },
                                          enforce_admins: true,
                                          required_pull_request_reviews: nil,
                                        }
                                       )
        expect(branch.url).not_to be_nil
        assert_requested :put, github_url("/repos/#{@repo.full_name}/branches/master/protection")
      end

      it "protects a single branch with required_status_checks" do
        rules = {
          required_status_checks: {
            strict: true,
            contexts: []
          },
          enforce_admins: true,
          required_pull_request_reviews: nil,
          restrictions: nil
        }
        branch = @client.protect_branch(@repo.full_name, "master", rules.merge(accept: preview_header))

        expect(branch.required_status_checks.strict).to be true
        expect(branch.restrictions).to be_nil
        assert_requested :put, github_url("/repos/#{@repo.full_name}/branches/master/protection")
      end
      it "protects a single branch with required_approving_review_count" do
        rules = {
          required_status_checks: {
            strict: true,
            contexts: []
          },
          enforce_admins: true,
          required_pull_request_reviews: {
            required_approving_review_count: 2
          },
        }
        branch = @client.protect_branch(@repo.full_name, "master", rules.merge(accept: preview_header))

        expect(branch.required_pull_request_reviews.required_approving_review_count).to eq 2
        assert_requested :put, github_url("/repos/#{@repo.full_name}/branches/master/protection")
      end

    end # .protect_branch

    context "with protected branch" do
      before(:each) do
        protection = {
          required_status_checks: {
            strict: true,
            contexts: []
          },
          enforce_admins: true,
          required_pull_request_reviews: nil,
          restrictions: nil
        }

        @client.protect_branch(@repo.full_name, "master", protection.merge(accept: preview_header))
      end

      describe ".unprotect_branch", :vcr do
        it "unprotects a single branch" do
          branch = @client.unprotect_branch(@repo.full_name, "master", accept: preview_header)
          expect(branch).to eq true
          assert_requested :delete, github_url("/repos/#{@repo.full_name}/branches/master/protection")
        end
      end # .unprotect_branch

    end # with protected_branch

    describe ".rename_branch", :vcr do
      it "renames a single branch" do
        branch = @client.rename_branch(@repo.full_name, "master", "main")
        expect(branch.name).to eq "main"
        assert_requested :post, github_url("/repos/#{@repo.full_name}/branches/master/rename")
      end
    end # .rename_branch
  end # with repository

  describe ".assignees", :vcr do
    it "lists all the available assignees (owner + collaborators)" do
      assignees = Octokit.repo_assignees("octokit/octokit.rb")
      expect(assignees).to be_kind_of Array
      assert_requested :get, github_url("/repos/octokit/octokit.rb/assignees")
    end
  end # .assignees

  describe ".check_assignee", :vcr do
    it "checks to see if a particular user is an assignee for a repository" do
      Octokit.check_assignee("octokit/octokit.rb", 'andrew')
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
      @client.update_subscription("octokit/octokit.rb", :subscribed => false)
      assert_requested :put, github_url("/repos/octokit/octokit.rb/subscription")
    end
  end # .update_subscription

  describe ".subscription", :vcr do
    it "returns a repository subscription" do
      @client.subscription("octokit/octokit.rb")
      assert_requested :get, github_url("/repos/octokit/octokit.rb/subscription")
    end
  end # .subscription

  describe ".delete_subscription", :vcr do
    it "returns true when repo subscription deleted" do
      @client.delete_subscription("octokit/octokit.rb")
      assert_requested :delete, github_url("/repos/octokit/octokit.rb/subscription")
    end
  end # .delete_subscription

  describe ".repository?", :vcr do
    it "returns true if the repository exists" do
      result = @client.repository?("sferik/rails_admin")
      expect(result).to be true
      assert_requested :get, github_url("/repos/sferik/rails_admin")
    end
    it "returns false if the repository doesn't exist" do
      result = @client.repository?("pengwynn/octokit")
      expect(result).to be false
      assert_requested :get, github_url("/repos/pengwynn/octokit")
    end
    it "returns false if the repository has an invalid format" do
      result = @client.repository?("invalid format")
      expect(result).to be false
    end
    it "returns false if the repository has more than one slash" do
      result = @client.repository?("more_than/one/slash")
      expect(result).to be false
    end
  end # .repository?

  describe ".transfer_repository", :vcr do
    before do
      @repository = @client.create_repository("a-repo", auto_init: true)
    end

    after do
      # cleanup
      begin
        @client.delete_repository("#{test_github_org}/#{@repository.name}")
      rescue Octokit::NotFound
      end
    end

    it "repository transfer from myself to my organization" do
      accept_header = Octokit::Preview::PREVIEW_TYPES[:transfer_repository]
      @client.transfer_repository(@repository.full_name, test_github_org, { accept: accept_header })
      assert_requested :post, github_url("/repos/#{@repository.full_name}/transfer")

      result = @client.repository?("#{test_github_org}/#{@repository.name}")
      expect(result).to be true
    end
  end # .transfer_repository

  describe ".vulnerability_alerts_enabled?", :vcr do
    let(:accept_preview_header) { Octokit::Preview::PREVIEW_TYPES[:vulnerability_alerts] }

    it "returns true when vulnerability alerts are enabled" do
      @client.enable_vulnerability_alerts(@test_repo, accept: accept_preview_header)

      result = @client.vulnerability_alerts_enabled?(@test_repo, accept: accept_preview_header)
      assert_requested :get, github_url("/repos/#{@test_repo}/vulnerability-alerts")
      expect(result).to be true
    end

    it "returns false with vulnerability alerts disabled" do
      @client.disable_vulnerability_alerts(@test_repo, accept: accept_preview_header)

      result = @client.vulnerability_alerts_enabled?(@test_repo, accept: accept_preview_header)
      assert_requested :get, github_url("/repos/#{@test_repo}/vulnerability-alerts")
      expect(result).to be false
    end
  end # .vulnerability_alerts_enabled?

  describe ".enable_vulnerability_alerts", :vcr do
    let(:accept_preview_header) { Octokit::Preview::PREVIEW_TYPES[:vulnerability_alerts] }

    it "enables vulnerability alerts for the repository" do
      result = @client.enable_vulnerability_alerts(@test_repo, accept: accept_preview_header)
      assert_requested :put, github_url("/repos/#{@test_repo}/vulnerability-alerts")
      expect(result).to be true
    end
  end # .enable_vulnerability_alerts

  describe ".disable_vulnerability_alerts", :vcr do
    let(:accept_preview_header) { Octokit::Preview::PREVIEW_TYPES[:vulnerability_alerts] }

    it "disables vulnerability alerts for the repository" do
      result = @client.disable_vulnerability_alerts(@test_repo, accept: accept_preview_header)
      assert_requested :delete, github_url("/repos/#{@test_repo}/vulnerability-alerts")
      expect(result).to be true
    end
  end # .disable_vulnerability_alerts

  private

  def preview_header
    Octokit::Preview::PREVIEW_TYPES[:branch_protection]
  end
end
