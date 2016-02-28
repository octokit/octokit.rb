require 'helper'

describe Octokit::Client::SourceImport do
  before do
    Octokit.reset!
    @client = oauth_client
  end

  before(:each) do
    @repo = @client.create_repository("an-repo")
    @client.start_source_import(@repo.full_name, "svn", "https://rphotogallery.googlecode.com/svn/")
  end

  after(:each) do
    begin
      @client.delete_repository(@repo.full_name)
    rescue Octokit::NotFound
    end
  end

  describe ".start_source_import", :vcr do
    it "starts a source import" do
      assert_requested :put, github_url("/repos/#{@repo.full_name}/import")
    end
  end # .start_source_import

  describe ".source_import_progress", :vcr do
    it "returns the progress of the source import" do
      @client.source_import_progress(@repo.full_name)
      assert_requested :get, github_url("/repos/#{@repo.full_name}/import")
    end
  end # .source_import_progress

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
      @client.cancel_source_import(@repo.full_name)
      assert_requested :delete, github_url("/repos/#{@repo.full_name}/import")
    end
  end # .cancel_source_import
end
