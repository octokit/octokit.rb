require 'helper'

describe Octokit::Client::Downloads do

  before do
    Octokit.reset!
    VCR.insert_cassette 'downloads'
    @client = basic_auth_client
  end

  after do
    VCR.eject_cassette
  end

  describe ".create_download" do
    it "creates a download resource" do
      resource = @client.send(:create_download_resource, "pengwynn/api-sandbox", File.expand_path("spec/fixtures/web_flow_token.json"), 95, {:description => "Stormtrooper", :content_type => "text/plain"})
      expect(resource.rels[:s3].href).to match /amazonaws/
      assert_requested :post, basic_github_url("/repos/pengwynn/api-sandbox/downloads")
    end

    it "posts to an S3 url" do
      file_path = File.expand_path 'spec/fixtures/web_flow_token.json'
      @client.create_download("pengwynn/api-sandbox", file_path, {:description => "Description of your download", :content_type => "text/plain"})
      assert_requested :post, "https://github.s3.amazonaws.com/"
      assert_requested :post, basic_github_url("/repos/pengwynn/api-sandbox/downloads")
    end
  end # .create_download

  describe ".downloads" do
    it "lists available downloads" do
      downloads = Octokit.downloads("github/hubot")
      expect(downloads.last.description).to match "Campfire"
      assert_requested :get, github_url("/repos/github/hubot/downloads")
    end
  end # .downloads

  describe ".download" do
    it "gets a single download" do
      download = Octokit.download("github/hubot", 165347)
      expect(download.name).to eq "hubot-2.1.0.tar.gz"
      assert_requested :get, github_url("/repos/github/hubot/downloads/165347")
    end
  end # .download


  describe ".delete_download" do
    it "deletes a download" do
      @client.delete_download 'pengwynn/api-sandbox', 397996
      assert_requested :delete, basic_github_url("/repos/pengwynn/api-sandbox/downloads/397996")
    end
  end # .delete_download

end
