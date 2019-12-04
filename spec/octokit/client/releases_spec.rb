require 'helper'

describe Octokit::Client::Releases do

  before do
    Octokit.reset!
    @client = oauth_client
  end

  describe ".releases" do
    it "lists releases for a repo", :vcr do
      releases = @client.releases @test_repo
      expect(releases).to be_kind_of Array
      assert_requested :get, github_url("/repos/#{@test_repo}/releases")
    end
  end

  describe ".create_release", :vcr do
    it "creates a release" do
      created = @client.create_release @test_repo, "test-create-release-tag"
      expect(created.tag_name).to eq("test-create-release-tag")
      assert_requested :post, github_url("/repos/#{@test_repo}/releases")
      @client.delete_release @test_repo, created.id
    end
  end

  describe ".release", :vcr do
    it "gets a single release" do
      created = @client.create_release @test_repo, "test-get-release-tag"
      release = @client.release @test_repo, created.id
      expect(release.tag_name).to eq("test-get-release-tag")
      @client.delete_release @test_repo, created.id
    end
  end

  describe ".update_release", :vcr do
    it "updates a release" do
      created = @client.create_release(@test_repo, "test-update-release-tag")
      release = @client.update_release(@test_repo, created.id, :name => "An updated release")
      expect(release.name).to eq("An updated release")
      assert_requested :patch, created.rels[:self].href
      @client.delete_release @test_repo, created.id
    end
  end

  describe ".delete_release", :vcr do
    it "deletes a release" do
      created = @client.create_release @test_repo, "test-delete-release-tag"
      url = created.rels[:self].href
      result = @client.delete_release @test_repo, created.id
      expect(result).to be true
      expect { @client.release(@test_repo, created.id) }.to raise_error(Octokit::NotFound)
    end
  end

  context "handling release assets" do

    before(:each) do
      @release_repo = "api-playground/api-sandbox"
      @asset_id = "21313"
    end

    after(:each) do
      @client.delete_release @test_repo, @release_id
    end

    describe ".release_assets", :vcr do
      it "lists assets for a release" do
        created = @client.create_release @test_repo, "test-handling-release-assets"
        releases = @client.releases @test_repo
        assets = @client.release_assets(@test_repo, releases.first.id)
        expect(assets).to be_kind_of(Array)
      end
    end # .release_assets

    describe ".release_asset" do
      it "gets a single release asset", :vcr do
        asset_url = "https://api.github.com/repos/#{@release_repo}/releases/assets/#{@asset_id}"
        request = stub_get(asset_url)
        @client.release_asset(@release_repo, @asset_id)
        assert_requested request
      end
    end # .release_asset

    describe ".update_release_asset" do
      it "edits a release asset", :vcr do
        asset_url = "https://api.github.com/repos/#{@release_repo}/releases/assets/#{@asset_id}"
        request = stub_get(asset_url)
        updated = @client.update_release_asset(@release_repo, @asset_id, :label => "Updated")
        expect(updated.label).to eq("Updated")
        assert_requested request
      end
    end # .update_release_asset

    describe ".delete_release_asset" do
      it "deletes a release asset", :vcr do
        asset_url = "https://api.github.com/repos/#{@release_repo}/releases/assets/#{@asset_id}"
        request = stub_delete(asset_url).to_return(:status => 204)
        expect(@client.delete_release_asset(@release_repo, @asset_id)).to be true
        assert_requested request
      end
    end # .delete_release_asset
  end # handling_release_assets

  describe '.release_by_tag', :vcr do
    it "returns the release for a tag" do
      release = @client.release_by_tag("octokit/octokit.rb", "v3.7.0")
      expect(release.tag_name).to eq("v3.7.0")
      assert_requested :get, github_url("/repos/octokit/octokit.rb/releases/tags/v3.7.0")
    end
  end # .release_by_tag

  describe '.latest_release', :vcr do
    it "returns the latest release" do
      result = Octokit.latest_release("octokit/octokit.rb")
      assert_requested :get, github_url("/repos/octokit/octokit.rb/releases/latest")
    end
  end # .latest_release
end
