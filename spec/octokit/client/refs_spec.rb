require 'helper'

describe Octokit::Client::Refs do
  before do
    Octokit.reset!
    @client = oauth_client
  end

  describe ".refs", :vcr do
    it "returns all refs" do
      refs = @client.refs("sferik/rails_admin")
      expect(refs).to be_kind_of Array
      assert_requested :get, github_url("/repos/sferik/rails_admin/git/refs")
    end
    it "returns all tag refs" do
      refs = @client.refs("sferik/rails_admin", "tags")
      expect(refs).to be_kind_of Array
      assert_requested :get, github_url("/repos/sferik/rails_admin/git/refs/tags")
    end
  end # .refs

  describe ".ref", :vcr do
    it "returns a tags ref" do
      ref = @client.ref("sferik/rails_admin", "tags/v0.0.3")
      expect(ref.object.type).to eq("tag")
      assert_requested :get, github_url("/repos/sferik/rails_admin/git/refs/tags/v0.0.3")
    end
  end # .ref

  context "with ref", :vcr do
    before(:each) do
      commits = @client.commits(@test_repo)
      @first_sha = commits.first.sha
      @last_sha = commits.last.sha
      @ref = @client.create_ref(@test_repo,"heads/testing/test-ref", @first_sha)
    end

    after(:each) do
      begin
        @client.delete_ref(@test_repo, "heads/testing/test-ref")
      rescue Octokit::UnprocessableEntity
      end
    end

    describe ".create_ref" do
      it "creates a ref" do
        assert_requested :post, github_url("/repos/#{@test_repo}/git/refs")
      end
    end # .create_ref

    describe ".update_branch" do
      it "updates a branch" do
        @client.update_branch(@test_repo, "testing/test-ref", @last_sha, true)
        assert_requested :patch, github_url("/repos/#{@test_repo}/git/refs/heads/testing/test-ref")
      end
    end # .update_branch

    describe ".update_ref" do
      it "updates a ref" do
        @client.update_ref(@test_repo, "heads/testing/test-ref", @last_sha, true)
        assert_requested :patch, github_url("/repos/#{@test_repo}/git/refs/heads/testing/test-ref")
      end
    end # .update_ref

    describe ".delete_branch" do
      it "deletes an existing branch" do
        @client.delete_branch(@test_repo, "testing/test-ref")
        assert_requested :delete, github_url("/repos/#{@test_repo}/git/refs/heads/testing/test-ref")
      end
    end # .delete_branch

    describe ".delete_ref" do
      it "deletes an existing ref" do
        @client.delete_ref(@test_repo, "heads/testing/test-ref")
        assert_requested :delete, github_url("/repos/#{@test_repo}/git/refs/heads/testing/test-ref")
      end
    end # .delete_ref
  end # with ref
end

