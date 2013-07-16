require 'helper'

describe Octokit::Client::Downloads do

  before do
    Octokit.reset!
    @client = oauth_client
  end

  describe ".downloads", :vcr do
    it "lists available downloads" do
      downloads = @client.downloads("github/hubot")
      expect(downloads.last.description).to match "Campfire"
      assert_requested :get, github_url("/repos/github/hubot/downloads")
    end
  end # .downloads

  describe ".download", :vcr do
    it "gets a single download" do
      download = @client.download("github/hubot", 165347)
      expect(download.name).to eq "hubot-2.1.0.tar.gz"
      assert_requested :get, github_url("/repos/github/hubot/downloads/165347")
    end
  end # .download

  context "methods that require a download" do

    before(:each) do
      local_path = File.expand_path("spec/fixtures/web_flow_token.json")
      options = { :description => Time.now.to_i.to_s, :content_type => "text/plain" }
      @client.create_download "api-playground/api-sandbox", local_path, options

      @download = @client.downloads("api-playground/api-sandbox").last
    end

    after(:each) do
      @client.delete_download 'api-playground/api-sandbox', @download.id
    end

    describe ".create_download", :vcr do
      it "creates a download resource" do
        assert_requested :post, github_url("/repos/api-playground/api-sandbox/downloads")
      end
      it "posts to an S3 url", :vcr do
        assert_requested :post, "https://github.s3.amazonaws.com/"
      end
    end # .create_download


    describe ".delete_download", :vcr do
      it "deletes a download" do
        @client.delete_download 'api-playground/api-sandbox', @download.id
        assert_requested :delete, github_url("/repos/api-playground/api-sandbox/downloads/#{@download.id}")
      end
    end # .delete_download

  end

end
