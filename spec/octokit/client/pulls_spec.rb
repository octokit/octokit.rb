# -*- encoding: utf-8 -*-
require 'helper'

describe Octokit::Client::Pulls do

  before do
    @client = Octokit::Client.new(:login => 'pengwynn')
  end

  describe ".create_pull_request" do

    it "should create a pull request" do
      stub_post("https://api.github.com/repos/pengwynn/octokit/pulls").
        with(:pull => {:base => "master", :head => "pengwynn:master", :title => "Title", :body => "Body"}).
        to_return(:body => fixture("v3/pull_created.json"))
      pull = @client.create_pull_request("pengwynn/octokit", "master", "pengwynn:master", "Title", "Body")
      pull.number.should == 15
      pull.title.should == "Pull this awesome v3 stuff"
    end

  end

  describe ".create_pull_request_for_issue" do

    it "should create a pull request and attach it to an existing issue" do
      stub_post("https://api.github.com/repos/pengwynn/octokit/pulls").
        with(:pull => {:base => "master", :head => "pengwynn:octokit", :issue => "15"}).
        to_return(:body => fixture("v3/pull_created.json"))
      pull = @client.create_pull_request_for_issue("pengwynn/octokit", "master", "pengwynn:octokit", "15")
      pull.number.should == 15 
    end

  end

  describe ".pull_requests" do

    it "should return all pull requests" do
      stub_get("https://api.github.com/repos/pengwynn/octokit/pulls?state=open").
        to_return(:body => fixture("v3/pull_requests.json"))
      pulls = @client.pulls("pengwynn/octokit")
      pulls.first.number.should == 928
    end

  end

  describe ".pull_request" do

    it "should return a pull request" do
      stub_get("https://api.github.com/repos/pengwynn/octokit/pulls/67").
        to_return(:body => fixture("v3/pull_request.json"))
      pull = @client.pull("pengwynn/octokit", 67)
      pull.number.should == 67 
    end

  end

end
