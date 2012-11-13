# -*- encoding: utf-8 -*-
require 'helper'

describe Octokit::Client::Issues do

  before do
    stub_get("https://api.github.com/").
      to_return(:body => fixture("v3/root.json"))
    stub_get("/repos/sferik/rails_admin").
      to_return(:body => fixture("v3/repository.json"))
    @client = Octokit::Client.new(:login => 'sferik')
  end

  describe ".search_issues" do

    it "returns matching issues" do
      stub_get("https://api.github.com/legacy/issues/search/sferik/rails_admin/open/activerecord").
      to_return(:body => fixture("legacy/issues.json"))
      issues = @client.search_issues("sferik/rails_admin", "activerecord")
      expect(issues.first.number).to eq(105)
    end

  end

  describe ".list_issues" do

    it "returns issues for a repository" do
      stub_get("/repos/sferik/rails_admin/issues").
        to_return(:body => fixture("v3/issues.json"))
      issues = @client.issues("sferik/rails_admin")
      expect(issues.first.number).to eq(388)
    end

    it "returns issues for the authenticated user" do
      stub_get("/issues").
        to_return(:body => fixture("v3/issues.json"))
      issues = @client.issues
      expect(issues.first.number).to eq(388)
    end

  end

  describe ".create_issue" do

    it "creates an issue" do
      stub_post("/repos/sferik/rails_admin/issues").
        with(:body => {"title" => "Migrate issues to v3", "body" => "Move all Issues calls to v3 of the API"},
             :headers => {'Content-Type'=>'application/json'}).
        to_return(:body => fixture("v3/issue.json"))
      issue = @client.create_issue("sferik/rails_admin", "Migrate issues to v3", "Move all Issues calls to v3 of the API")
      expect(issue.number).to eq(12)
    end

  end

  describe ".issue" do

    it "returns an issue" do
      stub_get("/repos/sferik/rails_admin/issues/12").
        to_return(:body => fixture("v3/issue.json"))
      issue = @client.issue("sferik/rails_admin", 12)
      expect(issue.number).to eq(12)
    end

  end

  describe ".close_issue" do

    it "closes an issue" do
      stub_post("/repos/sferik/rails_admin/issues/12").
        with(:body => {"state" => "closed"},
             :headers => {'Content-Type'=>'application/json'}).
        to_return(:body => fixture("v3/issue_closed.json"))
      issue = @client.close_issue("sferik/rails_admin", 12)
      expect(issue.number).to eq(12)
      expect(issue.state).to eq("closed")
    end

  end

  describe ".reopen_issue" do

    it "reopens an issue" do
      stub_post("/repos/sferik/rails_admin/issues/12").
        with(:body => {"state" => "open"},
             :headers => {'Content-Type'=>'application/json'}).
        to_return(:body => fixture("v3/issue.json"))
      issue = @client.reopen_issue("sferik/rails_admin", 12)
      expect(issue.number).to eq(12)
      expect(issue.state).to eq("open")
    end

  end

  describe ".update_issue" do

    it "updates an issue" do
      stub_patch("/repos/sferik/rails_admin/issues/12").
        with(:body => {"title" => "Use all the v3 api!", "body" => ""},
             :headers => {'Content-Type'=>'application/json'}).
        to_return(:body => fixture("v3/issue.json"))
      issue = @client.update_issue("sferik/rails_admin", 12, "Use all the v3 api!", "")
      expect(issue.number).to eq(12)
    end

  end

  describe ".issue_comments" do

    it "returns comments for an issue" do
      stub_get("/repos/sferik/rails_admin/issues/12").
        to_return(:body => fixture("v3/issue.json"))
      stub_get("/repos/sferik/rails_admin/issues/12/comments").
        to_return(:status => 200, :body => fixture('v3/comments.json'))
      comments = @client.issue_comments("sferik/rails_admin", 12)
      expect(comments.first.user.login).to eq("ctshryock")
    end

  end

  describe ".issue_comment" do

    it "returns a single comment for an issue" do
      stub_get("/repos/sferik/rails_admin/issues/comments/25").
        to_return(:status => 200, :body => fixture('v3/comment.json'))
      comments = @client.issue_comment("sferik/rails_admin", 25)
      expect(comments.user.login).to eq("ctshryock")
      expect(comments.url).to eq("https://api.github.com/repos/sferik/rails_admin/issues/comments/1194690")
    end

  end

  describe ".add_comment" do

    it "adds a comment" do
      stub_get("/repos/sferik/rails_admin/issues/12").
        to_return(:body => fixture("v3/issue.json"))
      stub_post("/repos/sferik/rails_admin/issues/12/comments").
        with(:body => {"body" => "A test comment"}).
        to_return(:status => 201, :body => fixture('v3/comment.json'))
      comment = @client.add_comment("sferik/rails_admin", 12, "A test comment")
      expect(comment.user.login).to eq("ctshryock")
    end

  end

  describe ".update_comment" do

    it "updates an existing comment" do
      stub_patch("/repos/sferik/rails_admin/issues/comments/1194549").
        with(:body => {"body" => "A test comment update"}).
        to_return(:status => 200, :body => fixture('v3/comment.json'))
      comment = @client.update_comment("sferik/rails_admin", 1194549, "A test comment update")
      expect(comment.user.login).to eq("ctshryock")
    end

  end

  describe ".delete_comment" do

    it "deletes an existing comment" do
      stub_delete("/repos/sferik/rails_admin/issues/comments/1194549").
        to_return(:status => 204)
      result = @client.delete_comment("sferik/rails_admin", 1194549)
      expect(result).to be_true
    end

  end
end
