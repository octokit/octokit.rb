# -*- encoding: utf-8 -*-
require 'helper'

describe Octokit::Client::Pulls do

  before do
    @client = Octokit::Client.new(:login => 'pengwynn')
  end

  describe ".create_pull_request" do

    it "creates a pull request" do
      stub_post("https://api.github.com/repos/pengwynn/octokit/pulls").
        with(:pull => {:base => "master", :head => "pengwynn:master", :title => "Title", :body => "Body"}).
        to_return(json_response("pull_created.json"))
      pull = @client.create_pull_request("pengwynn/octokit", "master", "pengwynn:master", "Title", "Body")
      expect(pull.number).to eq(15)
      expect(pull.title).to eq("Pull this awesome v3 stuff")
    end

  end

  describe ".update_pull_request" do

    it "updates a pull request" do
      stub_post("https://api.github.com/repos/pengwynn/octokit/pulls/67").
        with(:pull => { :title => "New title", :body => "Updated body", :state => "closed"}).
          to_return(json_response('pull_update.json'))
      pull = @client.update_pull_request('pengwynn/octokit', 67, 'New title', 'Updated body', 'closed')
      expect(pull.title).to eq('New title')
      expect(pull.body).to eq('Updated body')
      expect(pull.state).to eq('closed')
    end

  end

  describe ".create_pull_request_for_issue" do

    it "creates a pull request and attach it to an existing issue" do
      stub_post("https://api.github.com/repos/pengwynn/octokit/pulls").
        with(:pull => {:base => "master", :head => "pengwynn:octokit", :issue => "15"}).
        to_return(json_response("pull_created.json"))
      pull = @client.create_pull_request_for_issue("pengwynn/octokit", "master", "pengwynn:octokit", "15")
      expect(pull.number).to eq(15)
    end

  end

  describe ".pull_requests" do

    it "returns all pull requests" do
      stub_get("https://api.github.com/repos/pengwynn/octokit/pulls?state=open").
        to_return(json_response("pull_requests.json"))
      pulls = @client.pulls("pengwynn/octokit")
      expect(pulls.first.number).to eq(928)
    end

  end

  describe ".pull_requests_comments" do

    it "returns all comments on all pull requests" do
      stub_get("https://api.github.com/repos/pengwynn/octokit/pulls/comments").
        to_return(json_response("pull_requests_comments.json"))
      comments = @client.pull_requests_comments("pengwynn/octokit")
      expect(comments.first.user.login).to eq("sferik")
    end

  end

  describe ".pull_request" do

    it "returns a pull request" do
      stub_get("https://api.github.com/repos/pengwynn/octokit/pulls/67").
        to_return(json_response("pull_request.json"))
      pull = @client.pull("pengwynn/octokit", 67)
      expect(pull.number).to eq(67)
    end

  end

  describe ".pull_request_commits" do

    it "returns the commits for a pull request" do
      stub_get("https://api.github.com/repos/pengwynn/octokit/pulls/67/commits").
        to_return(json_response("pull_request_commits.json"))
      commits = @client.pull_commits("pengwynn/octokit", 67)
      expect(commits.first["sha"]).to eq("2097821c7c5aa4dc02a2cc54d5ca51968b373f95")
    end

  end

  describe ".pull_request_comments" do

    it "returns the comments for a pull request" do
      stub_get("https://api.github.com/repos/pengwynn/octokit/pulls/67/comments").
        to_return(json_response("pull_request_comments.json"))
      commits = @client.pull_comments("pengwynn/octokit", 67)
      expect(commits.first["id"]).to eq(401530)
    end

  end

  describe ".pull_request_comment" do

    it "returns a comment on a pull request" do
      stub_get("https://api.github.com/repos/pengwynn/octokit/pulls/comments/1903950").
        to_return(json_response("pull_request_comment.json"))
      comment = @client.pull_request_comment("pengwynn/octokit", 1903950)
      expect(comment.id).to eq(1903950)
      expect(comment.body).to include("Tests FTW.")
    end

  end

  describe ".create_pull_request_comment" do

    it "creates a new comment on a pull request" do
      comment_content = JSON.parse(fixture("pull_request_comment_create.json").read)
      new_comment = {
        :body => comment_content['body'],
        :commit_id => comment_content['commit_id'],
        :path => comment_content['path'],
        :position => comment_content['position']
      }
      stub_post("https://api.github.com/repos/pengwynn/octokit/pulls/163/comments").
        with(:body => new_comment).
          to_return(json_response("pull_request_comment_create.json"))
      comment = @client.create_pull_request_comment("pengwynn/octokit", 163, new_comment[:body], new_comment[:commit_id], new_comment[:path], new_comment[:position])
      expect(comment).to eq(comment_content)
    end

  end

  describe ".create_pull_request_comment_reply" do

    it "creates a new reply to a pull request comment" do
      new_comment = {
        :body => "done.",
        :in_reply_to => 1903950
      }
      stub_post("https://api.github.com/repos/pengwynn/octokit/pulls/163/comments").
        with(:body => new_comment).
          to_return(json_response("pull_request_comment_reply.json"))
      reply = @client.create_pull_request_comment_reply("pengwynn/octokit", 163, new_comment[:body], new_comment[:in_reply_to])
      expect(reply.id).to eq(1907270)
      expect(reply.body).to eq(new_comment[:body])
    end

  end

  describe ".update_pull_request_comment" do

    it "updates a pull request comment" do
      stub_patch("https://api.github.com/repos/pengwynn/octokit/pulls/comments/1907270").
        with(:body => { :body => ":shipit:"}).
          to_return(json_response("pull_request_comment_update.json"))
      comment = @client.update_pull_request_comment("pengwynn/octokit", 1907270, ":shipit:")
      expect(comment.body).to eq(":shipit:")
    end

  end

  describe ".delete_pull_request_comment" do

    it "deletes a pull request comment" do
      stub_delete("https://api.github.com/repos/pengwynn/octokit/pulls/comments/1907270").
        to_return(:status => 204)
      result = @client.delete_pull_request_comment("pengwynn/octokit", 1907270)
      expect(result).to eq(true)
    end

  end

  describe ".merge_pull_request" do

    it "merges the pull request" do
      stub_put("https://api.github.com/repos/pengwynn/octokit/pulls/67/merge").
        to_return(json_response("pull_request_merged.json"))
      response = @client.merge_pull_request("pengwynn/octokit", 67)
      expect(response["sha"]).to eq("2097821c7c5aa4dc02a2cc54d5ca51968b373f95")
    end

  end

  describe ".pull_request_files" do

    it "lists files for a pull request" do
      stub_get("https://api.github.com/repos/pengwynn/octokit/pulls/142/files").
        to_return(json_response("pull_request_files.json"))

      files = @client.pull_request_files("pengwynn/octokit", 142)
      file = files.first
      expect(file.filename).to eq('README.md')
      expect(file.additions).to eq(28)
    end

  end

  describe ".pull_merged?" do

    it "returns whether the pull request has been merged" do
      stub_get("https://api.github.com/repos/pengwynn/octokit/pulls/67/merge").
        to_return(:status => 204)
      merged = @client.pull_merged?("pengwynn/octokit", 67)
      expect(merged).to eq(true)
    end
  end

end
