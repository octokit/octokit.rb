require 'helper'

describe Octokit::Client::SourceImport do
  before do
    Octokit.reset!
    @client = oauth_client
  end

  after(:each) do
    begin
      @client.delete_repository(@repo.full_name)
    rescue Octokit::NotFound
    end
  end

  describe "pre vcs parameter deprecation" do
    describe ".start_source_import", :vcr do
      it "raises deprecation warning" do
        @repo = @client.create_repository("an-repo")
        result = @client.start_source_import(@repo.full_name, "svn", "https://rphotogallery.googlecode.com/svn/")

        expect(@client).to have_received(:octokit_warn)
          .with("Octokit#start_source_import vcs parameter is now an option, please update your call before the next major Octokit version update.")
        expect(result).to be_kind_of Sawyer::Resource
        assert_requested :put, github_url("/repos/#{@repo.full_name}/import")
      end
    end
  end

  describe "post vcs parameter deprecation" do
    before(:each) do
      @repo = @client.create_repository("an-repo")
      @client.start_source_import(@repo.full_name, "https://rphotogallery.googlecode.com/svn/", {:vcs => "svn"})
    end

    describe ".start_source_import", :vcr do
      it "starts a source import" do
        assert_requested :put, github_url("/repos/#{@repo.full_name}/import")
      end
    end # .start_source_import

    describe ".source_import_progress", :vcr do
      it "returns the progress of the source import" do
        result = @client.source_import_progress(@repo.full_name)
        expect(result).to be_kind_of Sawyer::Resource
        assert_requested :get, github_url("/repos/#{@repo.full_name}/import")
      end
    end # .source_import_progress

    describe ".update_source_import", :vcr do
      it "restarts the source import" do
        result = @client.update_source_import(@repo.full_name)
        expect(result).to be_kind_of Sawyer::Resource
        assert_requested :patch, github_url("/repos/#{@repo.full_name}/import")
      end
    end # .update_source_import

    describe ".source_import_commit_authors", :vcr do
      it "lists the source imports commit authors" do
        commit_authors = @client.source_import_commit_authors(@repo.full_name)
        expect(commit_authors).to be_kind_of Array
        assert_requested :get, github_url("/repos/#{@repo.full_name}/import/authors")
      end
    end # .source_import_commit_authors

    describe ".map_source_import_commit_author", :vcr do
      it "updates the commit authors identity" do
        # We have to wait for the importer to load the authors before continuing
        while(@client.source_import_commit_authors(@repo.full_name).empty?)
          sleep 1
        end

        commit_author_url = @client.source_import_commit_authors(@repo.full_name).first.url
        commit_author = @client.map_source_import_commit_author(commit_author_url, {
          :email => "hubot@github.com",
          :name => "Hubot the Robot"
        })

        expect(commit_author.email).to eql("hubot@github.com")
        expect(commit_author.name).to eql("Hubot the Robot")
        assert_requested :patch, commit_author_url
      end
    end # .map_source_import_commit_author

    describe ".cancel_source_import", :vcr do
      it "cancels the source import" do
        result = @client.cancel_source_import(@repo.full_name)
        expect(result).to be true
        assert_requested :delete, github_url("/repos/#{@repo.full_name}/import")
      end
    end # .cancel_source_import

    describe ".source_import_large_files", :vcr do
      it "lists the source imports large files" do
        large_files = @client.source_import_large_files(@repo.full_name)
        expect(large_files).to be_kind_of Array
        assert_requested :get, github_url("/repos/#{@repo.full_name}/import/large_files")
      end
    end # .source_import_large_files

    describe ".set_source_import_lfs_preference", :vcr do
      it "sets use_lfs to opt_in for the import" do
        result = @client.set_source_import_lfs_preference(@repo.full_name, "opt_in")
        expect(result).to be_kind_of Sawyer::Resource
        assert_requested :patch, github_url("repos/#{@repo.full_name}/import/lfs")
      end
    end # .set_source_import_lfs_preference
  end
end
