# -*- encoding: utf-8 -*-
require 'helper'

describe Octokit::Client::Downloads do

  before do
    @client = Octokit::Client.new(:login => 'sferik')
  end

  describe ".downloads" do

    it "should list available downloads" do
      stub_get("/repos/github/hubot/downloads").
        to_return(:body => fixture("v3/downloads.json"))
      downloads = @client.downloads("github/hubot")
      downloads.first.description.should == "Robawt"
    end

  end

  describe ".download" do

    it "should get a single download" do
      stub_get("/repos/github/hubot/downloads/165347").
        to_return(:body => fixture("v3/download.json"))
      download = @client.download("github/hubot", 165347)
      download.id.should == 165347
      download.name.should == 'hubot-2.1.0.tar.gz'
    end

  end

  describe ".create_download" do
    before(:each) do
      stub_post("/repos/octocat/Hello-World/downloads").
        with(:body => {:name => "download_create.json", :size => 690,
                       :description => "Description of your download",
                       :content_type => "text/plain" }).
        to_return(:body => fixture("v3/download_create.json"))
    end
    it "should create a download resource" do
      resource = @client.send(:create_download_resource, "octocat/Hello-World", "download_create.json", 690, {:description => "Description of your download", :content_type => "text/plain"})
      resource.s3_url.should == "https://github.s3.amazonaws.com/"
    end

    it "should post to a S3 url" do
      stub_post("https://github.s3.amazonaws.com/").
        to_return(:status => 201)
      file_path = File.expand_path 'spec/fixtures/v3/download_create.json'
      @client.create_download("octocat/Hello-World", file_path, {:description => "Description of your download", :content_type => "text/plain"}).should == true
    end
  end

  describe ".delete_download" do

    it "should delete a download" do
      stub_request(:delete, "https://api.github.com/repos/octocat/Hellow-World/downloads/165347").
        with(:headers => {'Accept'=>'*/*'}).
        to_return(:status => 204, :body => "", :headers => {})
      @client.delete_download('octocat/Hellow-World', 165347).status.should == 204
    end
  end

end
