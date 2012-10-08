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

  describe ".pull_request_commits" do

    it "should return the commits for a pull request" do
      stub_get("https://api.github.com/repos/pengwynn/octokit/pulls/67/commits").
        to_return(:body => fixture("v3/pull_request_commits.json"))
      commits = @client.pull_commits("pengwynn/octokit", 67)
      commits.first["sha"].should == "2097821c7c5aa4dc02a2cc54d5ca51968b373f95"
    end

  end

  describe ".pull_request_comments" do

    it "should return the comments for a pull request" do
      stub_get("https://api.github.com/repos/pengwynn/octokit/pulls/67/comments").
        to_return(:body => fixture("v3/pull_request_comments.json"))
      commits = @client.pull_comments("pengwynn/octokit", 67)
      commits.first["id"].should == 401530
    end

  end

  describe ".merge_pull_request" do

    it "should merge the pull request" do
      stub_put("https://api.github.com/repos/pengwynn/octokit/pulls/67/merge").
        to_return(:body => fixture("v3/pull_request_merged.json"))
      response = @client.merge_pull_request("pengwynn/octokit", 67)
      response["sha"].should == "2097821c7c5aa4dc02a2cc54d5ca51968b373f95"
    end

  end

  describe ".pull_request_files" do

    it "should list files for a pull request" do
      stub_get("https://api.github.com/repos/pengwynn/octokit/pulls/142/files").
        to_return(:body => fixture("v3/pull_request_files.json"))

      files = @client.pull_request_files("pengwynn/octokit", 142)
      file = files.first
      file.filename.should == 'README.md'
      file.additions.should == 28
    end

  end

  describe ".pull_merged?" do

    it "should see if the pull request has been merged" do
      stub_get("https://api.github.com/repos/pengwynn/octokit/pulls/67/merged").
        to_return(:status => 204)
      merged = @client.pull_merged?("pengwynn/octokit", 67)
      merged.should be_true
    end
  end

end
