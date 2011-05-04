# -*- encoding: utf-8 -*-
require 'helper'

describe Octokit::Client::Milestones do

  before do
    @client = Octokit::Client.new(:login => 'sferik')
  end

  describe ".list_milestones" do

    it "should list milestones belonging to repository" do
      stub_request(:get, "https://api.github.com/repos/pengwynn/octokit/milestones").
        to_return(:status => 200, :body => fixture('v3/milestones.json'))
      milestones = @client.list_milestones("pengwynn/octokit")
      milestones.first.description.should == "Add support for API v3"
    end

  end

  describe ".create_milestone" do

    it "should create a new milestone belonging to a repository" do
      stub_request(:post, "https://api.github.com/repos/pengwynn/octokit/milestones").
        to_return(:status => 201, :body => fixture('v3/milestone.json'))
      milestone = @client.create_milestone("pengwynn/octokit", :title => 'demo')
      milestone.title.should == "demo"
    end

  end

end
