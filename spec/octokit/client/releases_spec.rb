require 'helper'

describe Octokit::Client::Releases do
  before do
    Octokit.reset!
    @client = oauth_client
  end

  context "with test repository" do
    before do
      @test_repo = setup_test_repo(:auto_init => true).full_name
    end

    after do
      teardown_test_repo @test_repo
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
        release = @client.create_release \
          @test_repo, "test-create-release-tag", :name => "Test Create Release"
        expect(release.tag_name).to eq("test-create-release-tag")
        expect(release.name).to eq("Test Create Release")
        assert_requested :post, github_url("/repos/#{@test_repo}/releases")
      end
    end

    context "with release" do
      before(:each) do
        @release = @client.create_release \
          @test_repo, "test-release-tag", :name => "Test Release"
        @release_url = @release.rels[:self].href
      end

      describe ".release", :vcr do
        it "gets a single release" do
          release = @client.release @release_url
          expect(release.tag_name).to be
          expect(release.name).to be
          assert_requested :get, @release_url
        end
      end

      describe ".update_release", :vcr do
        it "updates a release" do
          release = @client.update_release @release_url, \
            :name => "An updated release"
          expect(release.name).to eq("An updated release")
          assert_requested :patch, @release_url
        end
      end

      describe ".delete_release", :vcr do
        it "deletes a release" do
          result = @client.delete_release @release_url
          expect(result).to be_true
          assert_requested :delete, @release_url
        end
      end

      describe ".release_assets", :vcr do
        it "lists assets for a release" do
          assets = @client.release_assets(@release_url)
          expect(assets).to be_kind_of(Array)
        end
      end

      describe ".upload_release_asset", :vcr => { :preserve_exact_body_bytes => true } do
        it "uploads a release asset by path" do
          local_path = "spec/fixtures/upload.png"
          name = "upload_by_path.png"
          asset = @client.upload_asset(@release_url, local_path, :content_type => "image/png", :name => name)
          expect(asset.name).to eq(name)
        end

        it "uploads a release asset as file object" do
          file = File.new("spec/fixtures/upload.png", "r+b")
          size = File.size(file)
          name = "upload_by_file.png"
          asset = @client.upload_asset(@release_url, file, :content_type => "image/png", :name => name)
          expect(asset.name).to eq(name)
          expect(asset.size).to eq(size)
        end

        it "uploads a release asset with a default name" do
          path = "spec/fixtures/upload.png"
          name = "upload.png"
          asset = @client.upload_asset(@release_url, path, :content_type => "image/png")
          expect(asset.name).to eq(name)
        end

        it "guesses the content type for an asset" do
          path = "spec/fixtures/upload.png"
          name = "upload_guess_content_type.png"
          asset = @client.upload_asset(@release_url, path, :name => name)
          expect(asset.name).to eq(name)
          expect(asset.content_type).to eq("image/png")
        end
      end

      context "with release asset", :vcr do
        before(:each) do
          @asset_url = @client.upload_asset(
            @release_url,
            'spec/fixtures/new_file.txt'
          ).rels[:self].href
        end

        describe ".release_asset" do
          it "gets a single release asset" do
            @client.release_asset @asset_url
            assert_requested :get, @asset_url
          end
        end

        describe ".update_release_asset" do
          it "edits a release asset", :vcr do
            updated = @client.update_release_asset(@asset_url, :label => "Updated")
            expect(updated.label).to eq("Updated")
            assert_requested :patch, @asset_url
          end
        end

        describe ".delete_release_asset" do
          it "deletes a release asset" do
            result = @client.delete_release_asset(@asset_url)
            expect(result).to be_true
            assert_requested :delete, @asset_url
          end
        end
      end # with release asset
    end # with release
  end # with test repository
end # Octokit::Client::Releases
