require 'helper'

describe Octokit::Client::Hooks do

  before do
    Octokit.reset!
    @client = oauth_client
  end

  context "with repository" do
    before(:each) do
      @repo = @client.create_repository("a-repo")
    end

    after(:each) do
      begin
        @client.delete_repository(@repo.full_name)
      rescue Octokit::NotFound
      end
    end

    describe ".hooks", :vcr do
      it "returns a repository's hooks" do
        hooks = @client.hooks(@repo.full_name)
        expect(hooks).to be_kind_of Array
        assert_requested :get, github_url("/repos/#{@repo.full_name}/hooks")
      end
    end

    context "with hook" do
      before(:each) do
        @hook = @client.create_hook(@repo.full_name, {:url => "https://railsbp.com"})
      end

      after(:each) do
        @client.delete_hook(@repo.full_name, @hook.id)
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
          @client.edit_hook(@repo.full_name, @hook.id, {:url => "https://railsbp.com"})
          assert_requested :patch, github_url("/repos/#{@repo.full_name}/hooks/#{@hook.id}")
        end
      end # .edit_hook

      describe ".test_push_hook", :vcr do
        it "tests a hook" do
          @client.test_push_hook(@repo.full_name, @hook.id)
          assert_requested :post, github_url("/repos/#{@repo.full_name}/hooks/#{@hook.id}/tests")
        end
      end # .test_hook

      describe ".ping_hook", :vcr do
        it "pings a hook" do
          @client.ping_hook(@repo.full_name, @hook.id)
          assert_requested :post, github_url("/repos/#{@repo.full_name}/hooks/#{@hook.id}/pings")
        end
      end # .ping_hook

      describe ".delete_hook", :vcr do
        it "deletes a hook" do
          @client.delete_hook(@repo.full_name, @hook.id)
          assert_requested :delete, github_url("/repos/#{@repo.full_name}/hooks/#{@hook.id}")
        end
      end # .delete_hook
    end # with hook
  end # with repository

  describe ".org_hooks", :vcr do
    it "returns an organization's hooks" do
      hooks = @client.org_hooks(test_github_org)
      expect(hooks).to be_kind_of Array
      assert_requested :get, github_url("/orgs/#{test_github_org}/hooks")
    end
    it "returns an organization's hooks by ID" do
      request = stub_get("/organizations/1/hooks")
      @client.org_hooks(1)
      assert_requested request
    end
  end

  context "with org hook" do
    before(:each) do
      hooks = @client.org_hooks(test_github_org)
      @client.delete_org_hook(test_github_org, hooks.first.id) if hooks.any?
      @org_hook = @client.create_org_hook(test_github_org, "web", {:url => "http://railsbp.com", :content_type => "json"})
    end

    after(:each) do
      @client.delete_org_hook(test_github_org, @org_hook.id)
    end

    describe ".create_org_hook", :vcr do
      it "creates an org hook" do
        assert_requested :post, github_url("/orgs/#{test_github_org}/hooks")
      end
      it "creates an org hook by ID" do
        request = stub_post("/organizations/1/hooks")
        org_hook = @client.create_org_hook(1, "web", {:url => "http://railsbp.com", :content_type => "json"})
        assert_requested request
      end
    end # .create_org_hook

    describe ".org_hook", :vcr do
      it "returns a single org hook" do
        @client.org_hook(test_github_org, @org_hook.id)
        assert_requested :get, github_url("/orgs/#{test_github_org}/hooks/#{@org_hook.id}")
      end
      it "returns a single org hook by ID" do
        request = stub_get(github_url("/organizations/1/hooks/#{@org_hook.id}"))
        @client.org_hook(1, @org_hook.id)
        assert_requested request
      end
    end # .org_hook

    describe ".edit_org_hook", :vcr do
      it "edits an org hook" do
        @client.edit_org_hook(test_github_org, @org_hook.id, {:url => "https://railsbp.com", :content_type => "application/json"})
        assert_requested :patch, github_url("/orgs/#{test_github_org}/hooks/#{@org_hook.id}")
      end
      it "edits an org hook by ID" do
        request = stub_patch("/organizations/1/hooks/#{@org_hook.id}")
        @client.edit_org_hook(1, @org_hook.id, {:url => "https://railsbp.com", :content_type => "application/json"})
        assert_requested request
      end
    end # .edit_org_hook

    describe ".ping_org_hook", :vcr do
      it "pings an org hook" do
        @client.ping_org_hook(test_github_org, @org_hook.id)
        assert_requested :post, github_url("/orgs/#{test_github_org}/hooks/#{@org_hook.id}/pings")
      end
      it "pings an org hook by ID" do
        request = stub_post("/organizations/1/hooks/#{@org_hook.id}/pings")
        @client.ping_org_hook(1, @org_hook.id)
        assert_requested request
      end
    end # .ping_org_hook

    describe ".delete_org_hook", :vcr do
      it "deletes an org hook" do
        @client.delete_org_hook(test_github_org, @org_hook.id)
        assert_requested :delete, github_url("/orgs/#{test_github_org}/hooks/#{@org_hook.id}")
      end
      it "deletes an org hook by ID" do
        request = stub_delete("/organizations/1/hooks/#{@org_hook.id}")
        @client.delete_org_hook(1, @org_hook.id)
        assert_requested request
      end
    end # .delete_org_hook
  end # with org hook
end
