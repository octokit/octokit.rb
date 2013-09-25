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

  describe ".delete_release", :vcr do
    it "deletes a release" do
      created = @client.create_release \
        "api-playground/api-sandbox", "test-delete-release-tag", :name => "Test Delete Release"
      url = created.rels[:self].href
      result = @client.delete_release url
      expect(result).to be_true
      expect { @client.release(url) }.to raise_error(Octokit::NotFound)
    end
  end

  context "handling release assets" do

    before do
      @release_url = "https://api.github.com/repos/api-playground/api-sandbox/releases/43567"
    end

    describe ".release_assets", :vcr do
      it "lists assets for a release" do
        assets = @client.release_assets(@release_url)
        expect(assets).to be_kind_of(Array)
      end
    end

    describe ".upload_release_asset", :vcr do
      it "uploads a release asset by path" do
        local_path = "spec/fixtures/upload.png"
        name = "upload_by_path.png"
        asset = @client.upload_asset(@release_url, local_path, :content_type => "image/png", :name => name)
        expect(asset.name).to eq(name)
      end
      it "uploads a release asset as file object" do
        file = File.new("spec/fixtures/upload.png", "r+b")
        name = "upload_by_file.png"
        asset = @client.upload_asset(@release_url, file, :content_type => "image/png", :name => name)
        expect(asset.name).to eq(name)
        expect(asset.size).to eq(file.size)
      end
      it "uploads a release asset with a default name" do
        path = "spec/fixtures/upload.png"
        name = "upload.png"
        asset = @client.upload_asset(@release_url, path, :content_type => "image/png")
        expect(asset.name).to eq(name)
      end
      it "guesses the content type for an asset"
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
end
