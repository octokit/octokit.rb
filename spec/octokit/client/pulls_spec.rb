# -*- encoding: utf-8 -*-
require 'helper'

describe Octokit::Client::Pulls do

  before do
    stub_get("https://api.github.com/").
      to_return(:body => fixture("v3/root.json"))
    stub_get("/repos/sferik/rails_admin").
      to_return(:body => fixture("v3/repository.json"))
    @client = Octokit::Client.new(:login => 'pengwynn')
  end

  describe ".create_pull_request" do

    it "creates a pull request" do
      stub_post("https://api.github.com/repos/sferik/rails_admin/pulls").
        with(:pull => {:base => "master", :head => "pengwynn:master", :title => "Title", :body => "Body"}).
        to_return(:body => fixture("v3/pull_created.json"))
      pull = @client.create_pull_request("sferik/rails_admin", "master", "pengwynn:master", "Title", "Body")
      expect(pull.number).to eq(15)
      expect(pull.title).to eq("Pull this awesome v3 stuff")
    end

  end

  describe ".update_pull_request" do

    it "updates a pull request" do
      stub_put("https://api.github.com/repos/sferik/rails_admin/pulls/67").
        with(:pull => { :title => "New title", :body => "Updated body", :state => "closed"}).
          to_return(:body => fixture('v3/pull_update.json'))
      pull = @client.update_pull_request('sferik/rails_admin', 67, 'New title', 'Updated body', 'closed')
      expect(pull.title).to eq('New title')
      expect(pull.body).to eq('Updated body')
      expect(pull.state).to eq('closed')
    end

  end

  describe ".create_pull_request_for_issue" do

    it "creates a pull request and attach it to an existing issue" do
      stub_post("https://api.github.com/repos/sferik/rails_admin/pulls").
        with(:pull => {:base => "master", :head => "pengwynn:octokit", :issue => "15"}).
        to_return(:body => fixture("v3/pull_created.json"))
      pull = @client.create_pull_request_for_issue("sferik/rails_admin", "master", "pengwynn:octokit", "15")
      expect(pull.number).to eq(15)
    end

  end

  describe ".pull_requests" do

    it "returns all pull requests" do
      stub_get("https://api.github.com/repos/sferik/rails_admin/pulls?state=open").
        to_return(:body => fixture("v3/pull_requests.json"))
      pulls = @client.pulls("sferik/rails_admin")
      expect(pulls.first.number).to eq(928)
    end

  end

  describe ".pull_request" do

    it "returns a pull request" do
      stub_get("https://api.github.com/repos/sferik/rails_admin/pulls/67").
        to_return(:body => fixture("v3/pull_request.json"))
      pull = @client.pull("sferik/rails_admin", 67)
      expect(pull.number).to eq(67)
    end

  end

  describe ".pull_request_commits" do

    it "returns the commits for a pull request" do
      stub_get("https://api.github.com/repos/sferik/rails_admin/pulls/67").
        to_return(:body => fixture("v3/pull_request.json"))
      stub_get("https://api.github.com/repos/sferik/rails_admin/pulls/67/commits").
        to_return(:body => fixture("v3/pull_request_commits.json"))
      commits = @client.pull_commits("sferik/rails_admin", 67)
      expect(commits.first.sha).to eq("2097821c7c5aa4dc02a2cc54d5ca51968b373f95")
    end

  end

  describe ".pull_request_comments" do

    it "returns the comments for a pull request" do
      stub_get("https://api.github.com/repos/sferik/rails_admin/pulls/67").
        to_return(:body => fixture("v3/pull_request.json"))
      stub_get("https://api.github.com/repos/sferik/rails_admin/pulls/67/comments").
        to_return(:body => fixture("v3/pull_request_comments.json"))
      commits = @client.pull_comments("sferik/rails_admin", 67)
      expect(commits.first.id).to eq(401530)
    end

  end

  describe ".pull_request_comment" do

    it "returns a comment on a pull request" do
      stub_get("https://api.github.com/repos/sferik/rails_admin/pulls/comments/1903950").
        to_return(:body => fixture("v3/pull_request_comment.json"))
      comment = @client.pull_request_comment("sferik/rails_admin", 1903950)
      expect(comment.id).to eq(1903950)
      expect(comment.body).to include("Tests FTW.")
    end

  end

  describe ".create_pull_request_comment" do

    it "creates a new comment on a pull request" do
      comment_content = JSON.parse(fixture("v3/pull_request_comment_create.json").read)
      new_comment = {
        :body => comment_content['body'],
        :commit_id => comment_content['commit_id'],
        :path => comment_content['path'],
        :position => comment_content['position']
      }
      stub_post("https://api.github.com/repos/sferik/rails_admin/pulls/67/comments").
        with(:body => new_comment).
          to_return(:body => fixture("v3/pull_request_comment_create.json"))
      comment = @client.create_pull_request_comment("sferik/rails_admin", 67, new_comment[:body], new_comment[:commit_id], new_comment[:path], new_comment[:position])
      expect(comment.original_commit_id).to eq('6ed6909ceb8f285de6562cca41dd1e4331c00722')
    end

  end

  describe ".create_pull_request_comment_reply" do

    it "creates a new reply to a pull request comment" do
      stub_get("https://api.github.com/repos/sferik/rails_admin/pulls/67").
        to_return(:body => fixture("v3/pull_request.json"))
      new_comment = {
        :body => "done.",
        :in_reply_to => 1903950
      }
      stub_post("https://api.github.com/repos/sferik/rails_admin/pulls/67/comments").
        with(:body => new_comment).
          to_return(:body => fixture("v3/pull_request_comment_reply.json"))
      reply = @client.create_pull_request_comment_reply("sferik/rails_admin", 67, new_comment[:body], new_comment[:in_reply_to])
      expect(reply.id).to eq(1907270)
      expect(reply.body).to eq(new_comment[:body])
    end

  end

  describe ".update_pull_request_comment" do

    it "updates a pull request comment" do
      stub_patch("https://api.github.com/repos/sferik/rails_admin/pulls/comments/1907270").
        with(:body => { :body => ":shipit:"}).
          to_return(:body => fixture("v3/pull_request_comment_update.json"))
      comment = @client.update_pull_request_comment("sferik/rails_admin", 1907270, ":shipit:")
      expect(comment.body).to eq(":shipit:")
    end

  end

  describe ".delete_pull_request_comment" do

    it "deletes a pull request comment" do
      stub_get("https://api.github.com/repos/sferik/rails_admin/pulls/67").
        to_return(:body => fixture("v3/pull_request.json"))
      stub_delete("https://api.github.com/repos/sferik/rails_admin/pulls/comments/1907270").
        to_return(:status => 204)
      result = @client.delete_pull_request_comment("sferik/rails_admin", 1907270)
      expect(result).to be_true
    end

  end

  describe ".merge_pull_request" do

    it "merges the pull request" do
      stub_get("https://api.github.com/repos/sferik/rails_admin/pulls/67").
        to_return(:body => fixture("v3/pull_request.json"))
      stub_put("https://api.github.com/repos/sferik/rails_admin/pulls/67/merge").
        to_return(:body => fixture("v3/pull_request_merged.json"))
      response = @client.merge_pull_request("sferik/rails_admin", 67)
      expect(response.sha).to eq("2097821c7c5aa4dc02a2cc54d5ca51968b373f95")
    end

  end

  describe ".pull_request_files" do

    it "lists files for a pull request" do
      stub_get("https://api.github.com/repos/sferik/rails_admin/pulls/67").
        to_return(:body => fixture("v3/pull_request.json"))
      stub_get("https://api.github.com/repos/sferik/rails_admin/pulls/67/files").
        to_return(:body => fixture("v3/pull_request_files.json"))

      files = @client.pull_request_files("sferik/rails_admin", 67)
      file = files.first
      expect(file.filename).to eq('README.md')
      expect(file.additions).to eq(28)
    end

  end

  describe ".pull_merged?" do

    it "returns whether the pull request has been merged" do
      stub_get("https://api.github.com/repos/sferik/rails_admin/pulls/67").
        to_return(:body => fixture("v3/pull_request.json"))
      stub_get("https://api.github.com/repos/sferik/rails_admin/pulls/67/merge").
        to_return(:status => 204)
      merged = @client.pull_merged?("sferik/rails_admin", 67)
      expect(merged).to be_true
    end
  end

end
