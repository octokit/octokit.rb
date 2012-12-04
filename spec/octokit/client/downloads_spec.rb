# -*- encoding: utf-8 -*-
require 'helper'

describe Octokit::Client::Downloads do

  before do
    @client = Octokit::Client.new(:login => 'sferik')
  end

  describe ".downloads" do

    it "lists available downloads" do
      stub_get("/repos/github/hubot/downloads").
        to_return(json_response("downloads.json"))
      downloads = @client.downloads("github/hubot")
      expect(downloads.first.description).to eq("Robawt")
    end

  end

  describe ".download" do

    it "gets a single download" do
      stub_get("/repos/github/hubot/downloads/165347").
        to_return(json_response("download.json"))
      download = @client.download("github/hubot", 165347)
      expect(download.id).to eq(165347)
      expect(download.name).to eq('hubot-2.1.0.tar.gz')
    end

  end

  describe ".create_download" do
    before(:each) do
      stub_post("/repos/octocat/Hello-World/downloads").
        with(:body => {:name => "download_create.json", :size => 690,
                       :description => "Description of your download",
                       :content_type => "text/plain" }).
        to_return(json_response("download_create.json"))
    end
    it "creates a download resource" do
      resource = @client.send(:create_download_resource, "octocat/Hello-World", "download_create.json", 690, {:description => "Description of your download", :content_type => "text/plain"})
      expect(resource.s3_url).to eq("https://github.s3.amazonaws.com/")
    end

    it "posts to an S3 url" do
      stub_post("https://github.s3.amazonaws.com/").
        to_return(:status => 201)
      file_path = File.expand_path 'spec/fixtures/download_create.json'
      expect(@client.create_download("octocat/Hello-World", file_path, {:description => "Description of your download", :content_type => "text/plain"})).to eq(true)
    end
  end

  describe ".delete_download" do

    it "deletes a download" do
      stub_request(:delete, "https://api.github.com/repos/octocat/Hellow-World/downloads/165347").
        to_return(:status => 204, :body => "", :headers => {})
      expect(@client.delete_download('octocat/Hellow-World', 165347)).to eq(true)
    end
  end

end
