require 'helper'

describe Octokit::Client::Releases do

  before do
    Octokit.reset!
    @client = oauth_client
  end

  describe ".releases" do
    it "lists releases for a repo", :vcr do
      releases = @client.releases "api-playground/api-sandbox"
      expect(releases).to be_kind_of Array
      assert_requested :get, github_url("/repos/api-playground/api-sandbox/releases")
    end
  end

  describe ".create_release", :vcr do
    it "creates a release" do
      release = @client.create_release \
        "api-playground/api-sandbox", "test-create-release-tag", :name => "Test Create Release"
      expect(release.tag_name).to eq("test-create-release-tag")
      expect(release.name).to eq("Test Create Release")
      assert_requested :post, github_url("/repos/api-playground/api-sandbox/releases")
    end
  end

  describe ".release", :vcr do
    it "gets a single release" do
      created = @client.create_release \
        "api-playground/api-sandbox", "test-get-release-tag", :name => "Test Get Release"
      release = @client.release created.rels[:self].href
      expect(release.tag_name).to eq("test-get-release-tag")
      expect(release.name).to eq("Test Get Release")
    end
  end

  describe ".update_release", :vcr do
    it "updates a release" do
      created = @client.create_release \
        "api-playground/api-sandbox", "test-update-release-tag", :name => "Test Update Release"
      release = @client.update_release \
        created.rels[:self].href, :name => "An updated release"
      expect(release.name).to eq("An updated release")
      assert_requested :patch, created.rels[:self].href
    end
  end

  describe ".delete_release" do
    it "deletes a release" do
      created = @client.create_release \
        "api-playground/api-sandbox", "test-delete-release-tag", :name => "Test Delete Release"
      url = created.rels[:self].href
      result = @client.delete_release url
      expect(result).to be_true
      expect { @client.release(url) }.to raise_error(Octokit::NotFound)
    end
  end

  describe ".assets" do
    it "lists assets for a release" do
      release = @client.release "https://api.github.com/repos/api-playground/api-sandbox/releases/43567"
    end
  end

  describe ".upload_release_asset" do
    it "uploads a release asset"
  end

  describe ".release_asset" do
    it "gets a single release asset"
  end

  describe ".update_release_asset" do
    it "edits a release asset"
  end

  describe ".delete_release_asset" do
    it "deletes a release asset"
  end
end
