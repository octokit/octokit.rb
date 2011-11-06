# -*- encoding: utf-8 -*-
require 'helper'

describe Octokit::Client::Issues do

  before do
    @client = Octokit::Client.new(:login => 'sferik')
  end

  describe ".search_issues" do

    it "should return matching issues" do
      stub_get("https://github.com/api/v2/json/issues/search/sferik/rails_admin/open/activerecord").
      to_return(:body => fixture("v2/issues.json"))
      issues = @client.search_issues("sferik/rails_admin", "activerecord")
      issues.first.number.should == 105
    end

  end

  describe ".list_issues" do

    it "should return issues" do
      stub_get("/repos/sferik/rails_admin/issues").
        to_return(:body => fixture("v3/issues.json"))
      issues = @client.issues("sferik/rails_admin")
      issues.first.number.should == 388
    end

  end

  describe ".create_issue" do

    it "should create an issue" do
      stub_post("/repos/ctshryock/octokit/issues").
        to_return(:body => fixture("v3/issue.json"))
      issue = @client.create_issue("ctshryock/octokit", "Migrate issues to v3", "Move all Issues calls to v3 of the API")
      issue.number.should == 12 
    end

  end

  describe ".issue" do

    it "should return an issue" do
      stub_get("https://github.com/api/v2/json/issues/show/sferik/rails_admin/105").
        to_return(:body => fixture("v2/issue.json"))
      issue = @client.issue("sferik/rails_admin", 105)
      issue.number.should == 105
    end

  end

  describe ".close_issue" do

    it "should close an issue" do
      stub_post("https://github.com/api/v2/json/issues/close/sferik/rails_admin/105").
        to_return(:body => fixture("v2/issue.json"))
      issue = @client.close_issue("sferik/rails_admin", 105)
      issue.number.should == 105
    end

  end

  describe ".reopen_issue" do

    it "should reopen an issue" do
      stub_post("https://github.com/api/v2/json/issues/reopen/sferik/rails_admin/105").
        to_return(:body => fixture("v2/issue.json"))
      issue = @client.reopen_issue("sferik/rails_admin", 105)
      issue.number.should == 105
    end

  end

  describe ".update_issue" do

    it "should update an issue" do
      stub_post("https://github.com/api/v2/json/issues/edit/sferik/rails_admin/105").
        to_return(:body => fixture("v2/issue.json"))
      issue = @client.update_issue("sferik/rails_admin", 105, "Use OrmAdapter instead of talking directly to ActiveRecord", "Hi,\n\nI just tried to play with this in an app with no ActiveRecord.  I was disappointed.  It seems the only reason the engine relies on AR is to provide History functionality.  I would argue that having the History in a database, and therefore tying the app to AR & SQL, isn't worth it.  How about we change it to just dump to a CSV and remove the AR dep?\n\n$0.02")
      issue.number.should == 105
    end

  end

  describe ".issue_comments" do

    it "should return comments for an issue" do
      stub_get("/repos/pengwynn/octokit/issues/25/comments").
        to_return(:status => 200, :body => fixture('v3/comments.json'))
      comments = @client.issue_comments("pengwynn/octokit", 25)
      comments.first.user.login.should == "ctshryock"
    end

  end

  describe ".issue_comment" do

    it "should return a single comment for an issue" do
      stub_get("/repos/pengwynn/octokit/issues/comments/25").
        to_return(:status => 200, :body => fixture('v3/comment.json'))
      comments = @client.issue_comment("pengwynn/octokit", 25)
      comments.user.login.should == "ctshryock"
      comments.url.should == "https://api.github.com/repos/pengwynn/octokit/issues/comments/1194690"
    end

  end

  describe ".add_comment" do

    it "should add a comment" do
      stub_post("/repos/pengwynn/octokit/issues/25/comments").
        with(:body => {"body" => "A test comment"}).
        to_return(:status => 201, :body => fixture('v3/comment.json'))
      comment = @client.add_comment("pengwynn/octokit", 25, "A test comment")
      comment.user.login.should == "ctshryock"
    end

  end

  describe ".update_comment" do

    it "should update an existing comment" do
      stub_post("/repos/pengwynn/octokit/issues/comments/1194549").
        with(:body => {"body" => "A test comment update"}).
        to_return(:status => 200, :body => fixture('v3/comment.json'))
      comment = @client.update_comment("pengwynn/octokit", 1194549, "A test comment update")
      comment.user.login.should == "ctshryock"
    end

  end

  describe ".delete_comment" do

    it "should delete an existing comment" do
      stub_delete("/repos/pengwynn/octokit/issues/comments/1194549").
        to_return(:status => 204)
      comment = @client.delete_comment("pengwynn/octokit", 1194549)
      comment.status.should == 204
    end

  end
end
