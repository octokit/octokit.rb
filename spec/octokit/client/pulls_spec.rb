# -*- encoding: utf-8 -*-
require 'helper'

describe Octokit::Client::Pulls do

  before do
    @client = Octokit::Client.new(:login => 'sferik')
  end

  describe ".create_pull_request" do

    it "should create a pull request" do
      stub_post("https://github.com/api/v2/json/pulls/sferik/rails_admin").
        with(:pull => {:base => "master", :head => "pengwynn:master", :title => "Title", :body => "Body"}).
        to_return(:body => fixture("v2/pulls.json"))
      issues = @client.create_pull_request("sferik/rails_admin", "master", "pengwynn:master", "Title", "Body")
      issues.first.number.should == 251
    end

  end

  describe ".create_pull_request_for_issue" do

    it "should create a pull request and attach it to an existing issue" do
      stub_post("https://github.com/api/v2/json/pulls/pengwynn/octokit").
        with(:pull => {:base => "master", :head => "pengwynn:master", :issue => "34"}).
        to_return(:body => fixture("v2/pulls.json"))
      issues = @client.create_pull_request_for_issue("pengwynn/octokit", "master", "pengwynn:master", "34")
      issues.first.number.should == 251
    end

  end

  describe ".pull_requests" do

    it "should return all pull requests" do
      stub_get("https://api.github.com/repos/sferik/rails_admin/pulls?state=open").
        to_return(:body => fixture("v3/pull_requests.json"))
      pulls = @client.pulls("sferik/rails_admin")
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
