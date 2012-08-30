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

  describe ".create_commit" do

    it "should create a commit" do
      stub_post("/repos/octocat/Hello-World/git/commits").
        with(:body => { :message => "My commit message", :tree => "827efc6d56897b048c772eb4087f854f46256132", :parents => ["7d1b31e74ee336d15cbd21741bc88a537ed063a0"] },
             :headers => { "Content-Type" => "application/json" }).
        to_return(:body => fixture("v3/commit_create.json"))
      commit = @client.create_commit("octocat/Hello-World", "My commit message", "827efc6d56897b048c772eb4087f854f46256132", "7d1b31e74ee336d15cbd21741bc88a537ed063a0")
      commit.sha.should == "7638417db6d59f3c431d3e1f261cc637155684cd"
      commit.message.should == "My commit message"
      commit.parents.size.should == 1
      commit.parents.first.sha.should == "7d1b31e74ee336d15cbd21741bc88a537ed063a0"
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

  describe ".compare" do

    it "should return a comparison" do
      stub_get("/repos/gvaughn/octokit/compare/0e0d7ae299514da692eb1cab741562c253d44188...b7b37f75a80b8e84061cd45b246232ad958158f5").
        to_return(:body => fixture("v3/compare.json"))
      comparison = @client.compare("gvaughn/octokit", '0e0d7ae299514da692eb1cab741562c253d44188', 'b7b37f75a80b8e84061cd45b246232ad958158f5')
      comparison.base_commit.sha.should == '0e0d7ae299514da692eb1cab741562c253d44188'
      comparison.merge_base_commit.sha.should == 'b7b37f75a80b8e84061cd45b246232ad958158f5'
    end
  end

  describe ".merge" do

    before do
      stub_post("/repos/pengwynn/api-sandbox/merges").
        to_return(:body => fixture("v3/merge.json"))
    end

    it "should merge a branch into another" do
      merge = @client.merge("pengwynn/api-sandbox", "master", "new-branch", :commit_message => "Testing the merge API")
      merge.sha.should == '4298c8499e0a7a160975adefdecdf9d8a5437095'
      merge.commit.message.should == 'Testing the merge API'
    end

  end
end
