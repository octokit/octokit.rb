require 'helper'

describe Octokit::Client::Refs do

  before do
    Octokit.reset!
    VCR.insert_cassette 'refs', :match_requests_on => [:uri, :method, :query, :body]
    @client = basic_auth_client
  end

  after do
    Octokit.reset!
    VCR.eject_cassette
  end

  describe ".refs" do
    it "returns all refs" do
      refs = Octokit.refs("sferik/rails_admin")
      expect(refs).to be_kind_of Array
      assert_requested :get, github_url("/repos/sferik/rails_admin/git/refs")
    end
    it "returns all tag refs" do
      refs = Octokit.refs("sferik/rails_admin", "tags")
      expect(refs).to be_kind_of Array
      assert_requested :get, github_url("/repos/sferik/rails_admin/git/refs/tags")
    end
  end # .refs

  describe ".ref" do
    it "returns a tags ref" do
      ref = Octokit.ref("sferik/rails_admin", "tags/v0.0.3")
      expect(ref.object.type).to eq "tag"
      assert_requested :get, github_url("/repos/sferik/rails_admin/git/refs/tags/v0.0.3")
    end
  end # .ref

  describe ".create_ref" do
    it "creates a ref" do
      ref = @client.create_ref("api-playground/api-sandbox","heads/master", "827efc6d56897b048c772eb4087f854f46256132")
      assert_requested :post, basic_github_url("/repos/api-playground/api-sandbox/git/refs")
    end
  end # .create_ref

  describe ".update_ref" do
    it "updates a ref" do
      refs = @client.update_ref("api-playground/api-sandbox","heads/sc/featureA", "aa218f56b14c9653891f9e74264a383fa43fefbd", true)
      assert_requested :patch, basic_github_url("/repos/api-playground/api-sandbox/git/refs/heads/sc/featureA")
    end
  end # .update_ref

  describe ".delete_ref" do
    it "deletes an existing ref" do
      result = @client.delete_ref("api-playground/api-sandbox", "heads/sc/featureA")
      assert_requested :delete, basic_github_url("/repos/api-playground/api-sandbox/git/refs/heads/sc/featureA")
    end
  end # .delete_ref

end

