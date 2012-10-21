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
        to_return(:body => fixture("v3/pull_created.json"))
      pull = @client.create_pull_request("pengwynn/octokit", "master", "pengwynn:master", "Title", "Body")
      expect(pull.number).to eq(15)
      expect(pull.title).to eq("Pull this awesome v3 stuff")
    end

  end

  describe ".update_pull_request" do

    it "updates a pull request" do
      stub_post("https://api.github.com/repos/pengwynn/octokit/pulls/67").
        with(:pull => { :title => "New title", :body => "Updated body", :state => "closed"}).
          to_return(:body => fixture('v3/pull_update.json'))
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
        to_return(:body => fixture("v3/pull_created.json"))
      pull = @client.create_pull_request_for_issue("pengwynn/octokit", "master", "pengwynn:octokit", "15")
      expect(pull.number).to eq(15)
    end

  end

  describe ".pull_requests" do

    it "returns all pull requests" do
      stub_get("https://api.github.com/repos/pengwynn/octokit/pulls?state=open").
        to_return(:body => fixture("v3/pull_requests.json"))
      pulls = @client.pulls("pengwynn/octokit")
      expect(pulls.first.number).to eq(928)
    end

  end

  describe ".pull_request" do

    it "returns a pull request" do
      stub_get("https://api.github.com/repos/pengwynn/octokit/pulls/67").
        to_return(:body => fixture("v3/pull_request.json"))
      pull = @client.pull("pengwynn/octokit", 67)
      expect(pull.number).to eq(67)
    end

  end

  describe ".pull_request_commits" do

    it "returns the commits for a pull request" do
      stub_get("https://api.github.com/repos/pengwynn/octokit/pulls/67/commits").
        to_return(:body => fixture("v3/pull_request_commits.json"))
      commits = @client.pull_commits("pengwynn/octokit", 67)
      expect(commits.first["sha"]).to eq("2097821c7c5aa4dc02a2cc54d5ca51968b373f95")
    end

  end

  describe ".pull_request_comments" do

    it "returns the comments for a pull request" do
      stub_get("https://api.github.com/repos/pengwynn/octokit/pulls/67/comments").
        to_return(:body => fixture("v3/pull_request_comments.json"))
      commits = @client.pull_comments("pengwynn/octokit", 67)
      expect(commits.first["id"]).to eq(401530)
    end

  end

  describe ".merge_pull_request" do

    it "merges the pull request" do
      stub_put("https://api.github.com/repos/pengwynn/octokit/pulls/67/merge").
        to_return(:body => fixture("v3/pull_request_merged.json"))
      response = @client.merge_pull_request("pengwynn/octokit", 67)
      expect(response["sha"]).to eq("2097821c7c5aa4dc02a2cc54d5ca51968b373f95")
    end

  end

  describe ".pull_request_files" do

    it "lists files for a pull request" do
      stub_get("https://api.github.com/repos/pengwynn/octokit/pulls/142/files").
        to_return(:body => fixture("v3/pull_request_files.json"))

      files = @client.pull_request_files("pengwynn/octokit", 142)
      file = files.first
      expect(file.filename).to eq('README.md')
      expect(file.additions).to eq(28)
    end

  end

  describe ".pull_merged?" do

    it "returns whether the pull request has been merged" do
      stub_get("https://api.github.com/repos/pengwynn/octokit/pulls/67/merged").
        to_return(:status => 204)
      merged = @client.pull_merged?("pengwynn/octokit", 67)
      expect(merged).to be_true
    end
  end

end
