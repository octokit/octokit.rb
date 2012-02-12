# -*- encoding: utf-8 -*-
require 'helper'

describe Octokit::Client::Commits do

  before do
    @client = Octokit::Client.new(:login => 'sferik')
  end

  describe ".commits" do

    it "should return all commits" do
      stub_get("/repos/sferik/rails_admin/commits?per_page=35&sha=master").
        to_return(:body => fixture("v3/commits.json"))
      commits = @client.commits("sferik/rails_admin")
      commits.first.author.login.should == "caboteria"
    end

  end

  describe ".commit" do

    it "should return a commit" do
      stub_get("/repos/sferik/rails_admin/commits/3cdfabd973bc3caac209cba903cfdb3bf6636bcd").
        to_return(:body => fixture("v3/commit.json"))
      commit = @client.commit("sferik/rails_admin", "3cdfabd973bc3caac209cba903cfdb3bf6636bcd")
      commit.author.login.should == "caboteria"
    end

  end

  describe ".list_commit_comments" do

    it "should return a list of all commit comments" do
      stub_get("/repos/sferik/rails_admin/comments").
        to_return(:body => fixture("v3/list_commit_comments.json"))
      commit_comments = @client.list_commit_comments("sferik/rails_admin")
      commit_comments.first.user.login.should == "sferik"
    end

  end

  describe ".commit_comments" do

    it "should return a list of comments for a specific commit" do
      stub_get("/repos/sferik/rails_admin/commits/629e9fd9d4df25528e84d31afdc8ebeb0f56fbb3/comments").
        to_return(:body => fixture("v3/commit_comments.json"))
      commit_comments = @client.commit_comments("sferik/rails_admin", "629e9fd9d4df25528e84d31afdc8ebeb0f56fbb3")
      commit_comments.first.user.login.should == "bbenezech"
    end

  end

  describe ".commit_comment" do

    it "should return a single commit comment" do
      stub_get("/repos/sferik/rails_admin/comments/861907").
        to_return(:body => fixture("v3/commit_comment.json"))
      commit = @client.commit_comment("sferik/rails_admin", "861907")
      commit.user.login.should == "bbenezech"
    end

  end

end
