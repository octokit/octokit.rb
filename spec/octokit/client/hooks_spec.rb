require 'helper'

describe Octokit::Client::Hooks do

  before do
    Octokit.reset!
    @client = oauth_client
  end

  describe ".available_hooks", :vcr do
    it "returns all the hooks supported by GitHub with their parameters" do
      hooks = @client.available_hooks
      expect(hooks.first.name).to eq("activecollab")
    end
  end

  context "with repository" do
    before(:each) do
      @repo = @client.create_repository("an-repo")
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
          @client.edit_hook(@repo.full_name, @hook.id, "railsbp", {:railsbp_url => "https://railsbp.com", :token => "xAAQZtJhYHGagsed1kYR"})
          assert_requested :patch, github_url("/repos/#{@repo.full_name}/hooks/#{@hook.id}")
        end
      end # .edit_hook

      describe ".test_hook", :vcr do
        it "tests a hook" do
          @client.create_hook(@repo.full_name, "railsbp", {:railsbp_url => "http://railsbp.com", :token => "xAAQZtJhYHGagsed1kYR"})
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
  end # with repository

  describe ".org_hooks", :vcr do
    it "returns an organization's hooks" do
      hooks = @client.org_hooks(test_github_org)
      expect(hooks).to be_kind_of Array
      assert_requested :get, github_url("/orgs/#{test_github_org}/hooks")
    end
  end

  context "with org hook" do
    before(:each) do
      @org_hook = @client.create_org_hook(test_github_org, {:url => "http://railsbp.com", :content_type => "json"})
    end

    after(:each) do
      @client.remove_org_hook(test_github_org, @org_hook.id)
    end

    describe ".create_org_hook", :vcr do
      it "creates an org hook" do
        assert_requested :post, github_url("/orgs/#{test_github_org}/hooks")
      end
    end # .create_org_hook

    describe ".org_hook", :vcr do
      it "returns a single org hook" do
        @client.org_hook(test_github_org, @org_hook.id)
        assert_requested :get, github_url("/orgs/#{test_github_org}/hooks/#{@org_hook.id}")
      end
    end # .org_hook

    describe ".edit_org_hook", :vcr do
      it "edits an org hook" do
        @client.edit_org_hook(test_github_org, @org_hook.id, {:url => "https://railsbp.com", :content_type => "application/json"})
        assert_requested :patch, github_url("/orgs/#{test_github_org}/hooks/#{@org_hook.id}")
      end
    end # .edit_org_hook

    describe ".ping_org_hook", :vcr do
      it "pings an org hook" do
        @client.ping_org_hook(test_github_org, @org_hook.id)
        assert_requested :post, github_url("/orgs/#{test_github_org}/hooks/#{@org_hook.id}/pings")
      end
    end # .ping_org_hook

    describe ".remove_org_hook", :vcr do
      it "removes an org hook" do
        @client.remove_org_hook(test_github_org, @org_hook.id)
        assert_requested :delete, github_url("/orgs/#{test_github_org}/hooks/#{@org_hook.id}")
      end
    end # .remove_org_hook
  end # with org hook

  describe ".parse_payload", :vcr do
    it "parses payload string" do
      test_json = fixture('create_payload.json').read
      result = @client.parse_payload test_json
      expect(result[:ref]).to eq("0.0.1")
      expect(result[:repository][:name]).to eq("public-repo")
      expect(result[:repository][:owner][:site_admin]).to eq(false)
    end
  end # .parse_payload
end
