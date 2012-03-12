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

end
