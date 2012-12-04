# -*- encoding: utf-8 -*-
require 'helper'

# need this to filter the data
require 'json'
require 'date'

describe Octokit::Client::Commits do

  before do
    @client = Octokit::Client.new(:login => 'sferik')
  end

  describe ".commits" do

    it "returns all commits" do
      stub_get("/repos/sferik/rails_admin/commits?per_page=35&sha=master").
        to_return(json_response("commits.json"))
      commits = @client.commits("sferik/rails_admin")
      expect(commits.first.author.login).to eq("caboteria")
    end

  end

  describe ".commits_on" do

    it "returns all commits on the specified date" do
      stub_http_request(:get, "https://api.github.com/repos/sferik/rails_admin/commits").
        with(:query=>{"per_page" => 35, "sha" => "master",
          "since" => "2011-01-20T00:00:00+00:00", "until" => "2011-01-21T00:00:00+00:00"}).
        to_return json_response('commits.json')
      commits = @client.commits_on("sferik/rails_admin", "2011-01-20")
      expect(commits).to be_an(Array)
    end

    it "returns an empty array if there are no commits on the specified date" do
      stub_http_request(:get, "https://api.github.com/repos/sferik/rails_admin/commits").
        with(:query=>{"per_page" => 35, "sha" => "master",
          "since" => "2011-01-15T00:00:00+00:00",
          "until" => "2011-01-16T00:00:00+00:00"}).
        to_return json_response('commits.json')
      commits = @client.commits_on("sferik/rails_admin", "2011-01-15")
      expect(commits).to be_an(Array)
    end

    it "errors if the date is invalid" do
      expect {@client.commits_on("sferik/rails_admin", "A pear")}.to raise_exception(ArgumentError, "A pear is not a valid date")
    end

  end

  describe ".commits_since" do

    it "returns all commits after the specified date" do
      start_date = Date.parse("2011-01-16T00:00:00+00:00")
      stub_http_request(:get, "https://api.github.com/repos/sferik/rails_admin/commits").
        with(:query=>{"per_page" => 35, "sha" => "master",
          "since" => "2011-01-16T00:00:00+00:00"}).
        to_return json_response('commits.json')
      commits = @client.commits_since("sferik/rails_admin", "2011-01-16")
      expect(commits).to be_an(Array)
    end

    it "returns an empty array if there are no commits after the specified date" do
      start_date = Date.parse("2011-01-22T00:00:00+00:00")
      stub_http_request(:get, "https://api.github.com/repos/sferik/rails_admin/commits").
        with(:query=>{"per_page" => 35, "sha" => "master",
          "since" => "2011-01-22T00:00:00+00:00"}).
        to_return json_response('commits.json')
      commits = @client.commits_since("sferik/rails_admin", "2011-01-22")
      expect(commits).to be_an(Array)
    end

    it "errors if the date is invalid" do
      expect {@client.commits_since("sferik/rails_admin", "A pear")}.to raise_exception(ArgumentError, "A pear is not a valid date")
    end

  end

  describe ".commits_before" do

    it "returns all commits before the specified date" do
      end_date = Date.parse("2011-01-17T00:00:00+00:00")
      stub_http_request(:get, "https://api.github.com/repos/sferik/rails_admin/commits").
        with(:query=>{"per_page" => 35, "sha" => "master",
          "until" => "2011-01-17T00:00:00+00:00"}).
          to_return json_response('commits.json')
      commits = @client.commits_before("sferik/rails_admin", "2011-01-17")
      expect(commits).to be_an(Array)
    end

    it "returns an empty array if there are no commits before the specified date" do
      end_date = DateTime.parse("2011-01-16T00:00:00%2000:00")
      stub_http_request(:get, "https://api.github.com/repos/sferik/rails_admin/commits").
        with(:query=>{"per_page" => 35, "sha" => "master",
          "until" => "2011-01-16T00:00:00+00:00"}).
          to_return json_response('commits.json')
      commits = @client.commits_before("sferik/rails_admin", "2011-01-16")
      expect(commits).to be_an(Array)
    end

    it "errors if the date is invalid" do
      expect {@client.commits_before("sferik/rails_admin", "A pear")}.to raise_exception(ArgumentError, "A pear is not a valid date")
    end

  end

  describe ".commits_between" do

    it "returns all commits between the specified dates" do
      start_date = DateTime.parse("2011-01-17T00:00:00+00:00")
      end_date = DateTime.parse("2011-01-20T00:00:00+00:00")
      stub_http_request(:get, "https://api.github.com/repos/sferik/rails_admin/commits").
        with(:query=>{"per_page" => 35, "sha" => "master",
          "since" => "2011-01-17T00:00:00+00:00", "until" => "2011-01-20T00:00:00+00:00"}).
          to_return json_response('commits.json')
      commits = @client.commits_between("sferik/rails_admin", "2011-01-17", "2011-01-20")
      expect(commits).to be_an(Array)
    end

    it "returns an empty array if there are no commits between the specified dates" do
      start_date = Date.parse("2011-01-15T00:00:00+00:00")
      end_date = Date.parse("2011-01-16T00:00:00+00:00")
      stub_http_request(:get, "https://api.github.com/repos/sferik/rails_admin/commits").
        with(:query=>{"per_page" => 35, "sha" => "master",
          "since" => "2011-01-15T00:00:00+00:00", "until" => "2011-01-16T00:00:00+00:00"}).
          to_return json_response('commits.json')
      commits = @client.commits_between("sferik/rails_admin", "2011-01-15", "2011-01-16")
      expect(commits).to be_an(Array)
    end

    it "errors if the end_date preceeds the start_date" do
      expect {@client.commits_between("sferik/rails_admin", "2011-01-16", "2011-01-15")}.to raise_exception(ArgumentError, "Start date 2011-01-16 does not precede 2011-01-15")
    end

    it "errors if the start date is invalid" do
      expect {@client.commits_between("sferik/rails_admin", "A pear", "2011-01-15")}.to raise_exception(ArgumentError, "A pear is not a valid date")
    end

    it "errors if the end date is invalid" do
      expect {@client.commits_between("sferik/rails_admin", "2011-01-16", "A walrus")}.to raise_exception(ArgumentError, "A walrus is not a valid date")
    end

  end

  describe ".commit" do

    it "returns a commit" do
      stub_get("/repos/sferik/rails_admin/commits/3cdfabd973bc3caac209cba903cfdb3bf6636bcd").
        to_return(json_response("commit.json"))
      commit = @client.commit("sferik/rails_admin", "3cdfabd973bc3caac209cba903cfdb3bf6636bcd")
      expect(commit.author.login).to eq("caboteria")
    end

  end

  describe ".create_commit" do

    it "creates a commit" do
      stub_post("/repos/octocat/Hello-World/git/commits").
        with(:body => { :message => "My commit message", :tree => "827efc6d56897b048c772eb4087f854f46256132", :parents => ["7d1b31e74ee336d15cbd21741bc88a537ed063a0"] },
             :headers => { "Content-Type" => "application/json" }).
        to_return(json_response("commit_create.json"))
      commit = @client.create_commit("octocat/Hello-World", "My commit message", "827efc6d56897b048c772eb4087f854f46256132", "7d1b31e74ee336d15cbd21741bc88a537ed063a0")
      expect(commit.sha).to eq("7638417db6d59f3c431d3e1f261cc637155684cd")
      expect(commit.message).to eq("My commit message")
      expect(commit.parents.size).to eq(1)
      expect(commit.parents.first.sha).to eq("7d1b31e74ee336d15cbd21741bc88a537ed063a0")
    end

  end

  describe ".list_commit_comments" do

    it "returns a list of all commit comments" do
      stub_get("/repos/sferik/rails_admin/comments").
        to_return(json_response("list_commit_comments.json"))
      commit_comments = @client.list_commit_comments("sferik/rails_admin")
      expect(commit_comments.first.user.login).to eq("sferik")
    end

  end

  describe ".commit_comments" do

    it "returns a list of comments for a specific commit" do
      stub_get("/repos/sferik/rails_admin/commits/629e9fd9d4df25528e84d31afdc8ebeb0f56fbb3/comments").
        to_return(json_response("commit_comments.json"))
      commit_comments = @client.commit_comments("sferik/rails_admin", "629e9fd9d4df25528e84d31afdc8ebeb0f56fbb3")
      expect(commit_comments.first.user.login).to eq("bbenezech")
    end

  end

  describe ".commit_comment" do

    it "returns a single commit comment" do
      stub_get("/repos/sferik/rails_admin/comments/861907").
        to_return(json_response("commit_comment.json"))
      commit = @client.commit_comment("sferik/rails_admin", "861907")
      expect(commit.user.login).to eq("bbenezech")
    end

  end

  describe ".create_commit_comment" do

    it "creates a commit comment" do
      stub_post("/repos/sferik/rails_admin/commits/629e9fd9d4df25528e84d31afdc8ebeb0f56fbb3/comments").
        with(:body => { :body => "Hey Eric,\r\n\r\nI think it's a terrible idea: for a number of reasons (dissections, etc.), test suite should stay deterministic IMO.\r\n", :commit_id => "629e9fd9d4df25528e84d31afdc8ebeb0f56fbb3", :line => 1, :path => ".rspec", :position => 4 },
             :headers => { "Content-Type" => "application/json" }).
        to_return(json_response("commit_comment_create.json"))
      commit_comment = @client.create_commit_comment("sferik/rails_admin", "629e9fd9d4df25528e84d31afdc8ebeb0f56fbb3", "Hey Eric,\r\n\r\nI think it's a terrible idea: for a number of reasons (dissections, etc.), test suite should stay deterministic IMO.\r\n", ".rspec", 1, 4)
      expect(commit_comment.body).to eq("Hey Eric,\r\n\r\nI think it's a terrible idea: for a number of reasons (dissections, etc.), test suite should stay deterministic IMO.\r\n")
      expect(commit_comment.commit_id).to eq("629e9fd9d4df25528e84d31afdc8ebeb0f56fbb3")
      expect(commit_comment.path).to eq(".rspec")
      expect(commit_comment.line).to eq(1)
      expect(commit_comment.position).to eq(4)
    end

  end

  describe ".update_commit_comment" do

    it "updates a commit comment" do
      stub_patch("/repos/sferik/rails_admin/comments/860296").
        with(:body => { :body => "Hey Eric,\r\n\r\nI think it's a terrible idea. The test suite should stay deterministic IMO.\r\n" },
          :headers => { "Content-Type" => "application/json" }).
        to_return(json_response("commit_comment_update.json"))
        commit_comment = @client.update_commit_comment("sferik/rails_admin", "860296", "Hey Eric,\r\n\r\nI think it's a terrible idea. The test suite should stay deterministic IMO.\r\n")
        expect(commit_comment.body).to eq("Hey Eric,\r\n\r\nI think it's a terrible idea. The test suite should stay deterministic IMO.\r\n")
    end

  end

  describe ".delete_commit_comment" do

    it "deletes a commit comment" do
      stub_delete("/repos/sferik/rails_admin/comments/860296").
        to_return(:status => 204, :body => "")
      commit_comment = @client.delete_commit_comment("sferik/rails_admin", "860296")
      expect(commit_comment).to eq(true)
    end

  end

  describe ".compare" do

    it "returns a comparison" do
      stub_get("/repos/gvaughn/octokit/compare/0e0d7ae299514da692eb1cab741562c253d44188...b7b37f75a80b8e84061cd45b246232ad958158f5").
        to_return(json_response("compare.json"))
      comparison = @client.compare("gvaughn/octokit", '0e0d7ae299514da692eb1cab741562c253d44188', 'b7b37f75a80b8e84061cd45b246232ad958158f5')
      expect(comparison.base_commit.sha).to eq('0e0d7ae299514da692eb1cab741562c253d44188')
      expect(comparison.merge_base_commit.sha).to eq('b7b37f75a80b8e84061cd45b246232ad958158f5')
    end
  end

  describe ".merge" do

    before do
      stub_post("/repos/pengwynn/api-sandbox/merges").
        to_return(json_response("merge.json"))
    end

    it "merges a branch into another" do
      merge = @client.merge("pengwynn/api-sandbox", "master", "new-branch", :commit_message => "Testing the merge API")
      expect(merge.sha).to eq('4298c8499e0a7a160975adefdecdf9d8a5437095')
      expect(merge.commit.message).to eq('Testing the merge API')
    end

  end
end
