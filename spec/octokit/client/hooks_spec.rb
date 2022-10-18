require 'helper'

describe Octokit::Client::ReposHooks do

  before do
    Octokit.reset!
    @client = oauth_client
  end

  describe ".webhooks", :vcr do
    it "returns a repository's hooks" do
      hooks = @client.webhooks(@test_repo)
      expect(hooks).to be_kind_of Array
      assert_requested :get, github_url("/repos/#{@test_repo}/hooks")
    end
  end

  context "with webhook" do
    before(:each) do
      @webhook = @client.create_webhook(@test_repo, {:url => "https://railsbp.com"})
    end

    after(:each) do
      @client.delete_webhook(@test_repo, @webhook.id)
    end

    describe ".create_webhook", :vcr do
      it "creates a webhook" do
        assert_requested :post, github_url("/repos/#{@test_repo}/hooks")
      end
      it "returns with no config url passed" do
        expect { @client.create_webhook(@test_repo)}.to raise_error Octokit::MissingKey
      end
    end # .create_webhook

    describe ".webhook", :vcr do
      it "returns a repository's single webhook" do
        @client.webhook(@test_repo, @webhook.id)
        assert_requested :get, github_url("/repos/#{@test_repo}/hooks/#{@webhook.id}")
      end
    end # .webhook

    describe ".update_webhook", :vcr do
      it "updates a webhook" do
        @client.update_webhook(@test_repo, @webhook.id, {:url => "https://railsbp.com"})
        assert_requested :patch, github_url("/repos/#{@test_repo}/hooks/#{@webhook.id}")
      end
    end # .update_webhook

    describe ".test_push_webhook", :vcr do
      it "tests a webhook" do
        @client.test_push_webhook(@test_repo, @webhook.id)
        assert_requested :post, github_url("/repos/#{@test_repo}/hooks/#{@webhook.id}/tests")
      end
    end # .test_webhook

    describe ".ping_webhook", :vcr do
      it "pings a webhook" do
        @client.ping_webhook(@test_repo, @webhook.id)
        assert_requested :post, github_url("/repos/#{@test_repo}/hooks/#{@webhook.id}/pings")
      end
    end # .ping_webhook

    describe ".delete_webhook", :vcr do
      it "deletes a webhook" do
        @client.delete_webhook(@test_repo, @webhook.id)
        assert_requested :delete, github_url("/repos/#{@test_repo}/hooks/#{@webhook.id}")
      end
    end # .delete_webhook
  end # with webhook

  describe ".org_webhooks", :vcr do
    it "returns an organization's webhooks" do
      webhooks = @client.org_webhooks(test_github_org)
      expect(webhooks).to be_kind_of Array
      assert_requested :get, github_url("/orgs/#{test_github_org}/hooks")
    end
    it "returns an organization's webhooks by ID" do
      request = stub_get("/organizations/1/hooks")
      @client.org_webhooks(1)
      assert_requested request
    end
  end # .org_webhooks

  context "with org webhook" do
    before(:each) do
      @org_webhook = @client.create_org_webhook(test_github_org, "web", {:url => "http://railsbp.com", :content_type => "json"})
    end

    after(:each) do
      @client.delete_org_webhook(test_github_org, @org_webhook.id)
    end

    describe ".create_org_webhook", :vcr do
      it "creates an org webhook" do
        assert_requested :post, github_url("/orgs/#{test_github_org}/hooks")
      end
      it "creates an org webhook by ID" do
        request = stub_post("/organizations/1/hooks")
        org_webhook = @client.create_org_webhook(1, "web", {:url => "http://railsbp.com", :content_type => "json"})
        assert_requested request
      end
      it "returns with no config url passed" do
        expect { @client.create_org_webhook(1, "web")}.to raise_error Octokit::MissingKey
      end
    end # .create_org_webhook

    describe ".org_webhook", :vcr do
      it "returns a single org webhook" do
        @client.org_webhook(test_github_org, @org_webhook.id)
        assert_requested :get, github_url("/orgs/#{test_github_org}/hooks/#{@org_webhook.id}")
      end
      it "returns a single org webhook by ID" do
        request = stub_get(github_url("/organizations/1/hooks/#{@org_webhook.id}"))
        @client.org_webhook(1, @org_webhook.id)
        assert_requested request
      end
    end # .org_webhook

    describe ".update_org_webhook", :vcr do
      it "update an org webhook" do
        @client.update_org_webhook(test_github_org, @org_webhook.id, {:url => "https://railsbp.com", :content_type => "application/json"})
        assert_requested :patch, github_url("/orgs/#{test_github_org}/hooks/#{@org_webhook.id}")
      end
      it "updates an org webhook by ID" do
        request = stub_patch("/organizations/1/hooks/#{@org_webhook.id}")
        @client.update_org_webhook(1, @org_webhook.id, {:url => "https://railsbp.com", :content_type => "application/json"})
        assert_requested request
      end
    end # .update_org_webhook

    describe ".ping_org_webhook", :vcr do
      it "pings an org webhook" do
        @client.ping_org_webhook(test_github_org, @org_webhook.id)
        assert_requested :post, github_url("/orgs/#{test_github_org}/hooks/#{@org_webhook.id}/pings")
      end
      it "pings an org webhook by ID" do
        request = stub_post("/organizations/1/hooks/#{@org_webhook.id}/pings")
        @client.ping_org_webhook(1, @org_webhook.id)
        assert_requested request
      end
    end # .ping_org_webhook

    describe ".delete_org_webhook", :vcr do
      it "deletes an org webhook" do
        @client.delete_org_webhook(test_github_org, @org_webhook.id)
        assert_requested :delete, github_url("/orgs/#{test_github_org}/hooks/#{@org_webhook.id}")
      end
      it "deletes an org webhook by ID" do
        request = stub_delete("/organizations/1/hooks/#{@org_webhook.id}")
        @client.delete_org_webhook(1, @org_webhook.id)
        assert_requested request
      end
    end # .delete_org_webhook
  end # with org webhook
end
