# -*- encoding: utf-8 -*-
require 'helper'

describe Octokit::Client::Milestones do

  before do
    @client = Octokit::Client.new(:login => 'sferik')
  end

  describe ".list_milestones" do

    it "should list milestones belonging to an issue" do
      stub_request(:get, "https://api.github.com/repos/pengwynn/octokit/milestones").
        to_return(:status => 200, :body => fixture('milestones.json'))
      milestones = @client.list_milestones("pengwynn/octokit")
      milestones.first.description.should == "Add support for API v3"
    end

  end
end
