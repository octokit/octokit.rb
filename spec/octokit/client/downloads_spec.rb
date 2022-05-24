require 'helper'

describe Octokit::Client::ReposDownloads do

  before do
    Octokit.reset!
    @client = oauth_client
  end

  describe ".downloads", :vcr do
    it "lists available downloads" do
      downloads = @client.downloads("github/hubot")
      expect(downloads.last.description).to eq("Version 1.0.0 of the Hubot Campfire Bot")
      assert_requested :get, github_url("/repos/github/hubot/downloads")
    end
  end # .downloads

  describe ".download", :vcr do
    it "gets a single download" do
      download = @client.download("github/hubot", 165347)
      expect(download.name).to eq("hubot-2.1.0.tar.gz")
      assert_requested :get, github_url("/repos/github/hubot/downloads/165347")
    end
  end # .download

  describe ".delete_download" do
    it "deletes a download" do
      request = stub_delete(github_url("/repos/api-playground/api-sandbox/downloads/12345"))
      @client.delete_download 'api-playground/api-sandbox', '12345'
      assert_requested request
    end
  end # .delete_download

end
