# -*- encoding: utf-8 -*-
require 'helper'

describe Octokit::Client::Downloads do

  before do
    @client = Octokit::Client.new(:login => 'sferik')
  end

  describe ".getting downloads" do

    it "should list available downloads" do
      stub_get("/repos/github/hubot/downloads").
        to_return(:body => fixture("v3/downloads.json"))
      downloads = @client.downloads("github/hubot")
      downloads.first.description.should == "Robawt"
    end

    it "should get a single download" do
      stub_get("/repos/github/hubot/downloads/165347").
        to_return(:body => fixture("v3/download.json"))
      download = @client.download("github/hubot", 165347)
      download.id.should == 165347
      download.name.should == 'hubot-2.1.0.tar.gz'
    end

  end

  describe ".create a download" do
    before(:each) do 
      stub_post("/repos/octocat/Hello-World/downloads").
        with(:body => {:name => "new_file.jpg", :size => 1024, 
                       :description => "Description of your download",
                       :content_type => ".jpg" }).
        to_return(:body => fixture("v3/download_create.json"))
    end
    it "should create a download resource" do
      resource = @client.send(:create_download_resource, "octocat/Hello-World", "new_file.jpg", 1024, {:description => "Description of your download", :content_type => ".jpg"})
      resource.s3_url.should == "https://github.s3.amazonaws.com/"
    end
    
    it "should post to a S3 url" do
      stub_post("https://github.s3.amazonaws.com/").
         with(:body => "{\"key\":\"downloads/ocotocat/Hello-World/new_file.jpg\",\"acl\":\"public-read\",\"success_action_status\":201,\"Filename\":\"new_file.jpg\",\"AWSAccessKeyId\":\"1ABCDEFG...\",\"Policy\":\"ewogICAg...\",\"Signature\":\"mwnFDC...\",\"Content-Type\":\"image/jpeg\",\"file\":\"@new_file.jpg\"}").
        to_return(:status => 201)
      @client.create_download("octocat/Hello-World", "new_file.jpg", 1024, {:description => "Description of your download", :content_type => ".jpg"}).should == true
    end
  end

end
