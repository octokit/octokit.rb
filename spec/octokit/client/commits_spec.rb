require 'helper'

describe Octokit::Client::Commits do

  before do
    Octokit.reset!
    @client = oauth_client
  end

  describe ".commits", :vcr do
    it "returns all commits" do
      commits = @client.commits("sferik/rails_admin")
      expect(commits.first.author).to_not be_nil
      assert_requested :get, github_url("/repos/sferik/rails_admin/commits")
    end
    it "handles branch or sha argument" do
      commits = @client.commits("sferik/rails_admin", "master")
      assert_requested :get, github_url("/repos/sferik/rails_admin/commits?sha=master")
    end
    it "handles the sha option" do
      commits = @client.commits("sferik/rails_admin", :sha => "master")
      assert_requested :get, github_url("/repos/sferik/rails_admin/commits?sha=master")
    end
  end # .commits

  describe ".commits_on", :vcr do
    it "returns all commits on the specified date" do
      commits = @client.commits_on("sferik/rails_admin", "2011-01-20")
      expect(commits).to be_kind_of Array
      assert_requested :get, github_url("/repos/sferik/rails_admin/commits?since=2011-01-20T00:00:00%2B00:00&until=2011-01-21T00:00:00%2B00:00")
    end
    it "errors if the date is invalid" do
      expect { @client.commits_on "sferik/rails_admin", "A pear" }.to raise_error ArgumentError
    end
    it "handles branch or sha argument" do
      commits = @client.commits_on("sferik/rails_admin", "2011-01-15", "master")
      assert_requested :get, github_url("/repos/sferik/rails_admin/commits?sha=master&since=2011-01-15T00:00:00%2B00:00&until=2011-01-16T00:00:00%2B00:00")
    end
    it "handles the sha option" do
      commits = @client.commits_on("sferik/rails_admin", "2011-01-15", :sha => "master")
      assert_requested :get, github_url("/repos/sferik/rails_admin/commits?sha=master&since=2011-01-15T00:00:00%2B00:00&until=2011-01-16T00:00:00%2B00:00")
    end
  end # .commits_on

  describe ".commits_since", :vcr do
    it "returns all commits since the specified date" do
      commits = @client.commits_since("sferik/rails_admin", "2011-01-20")
      expect(commits).to be_kind_of Array
      assert_requested :get, github_url("/repos/sferik/rails_admin/commits?since=2011-01-20T00:00:00%2B00:00")
    end
    it "errors if the date is invalid" do
      expect { @client.commits_since "sferik/rails_admin", "A pear" }.to raise_error ArgumentError
    end
    it "handles branch or sha argument" do
      commits = @client.commits_since("sferik/rails_admin", "2011-01-15", "master")
      assert_requested :get, github_url("/repos/sferik/rails_admin/commits?sha=master&since=2011-01-15T00:00:00%2B00:00")
    end
    it "handles the sha option" do
      commits = @client.commits_since("sferik/rails_admin", "2011-01-15", :sha => "master")
      assert_requested :get, github_url("/repos/sferik/rails_admin/commits?sha=master&since=2011-01-15T00:00:00%2B00:00")
    end
  end # .commits_since

  describe ".commits_before", :vcr do
    it "returns all commits until the specified date" do
      commits = @client.commits_before("sferik/rails_admin", "2011-01-20")
      expect(commits).to be_kind_of Array
      assert_requested :get, github_url("/repos/sferik/rails_admin/commits?until=2011-01-20T00:00:00%2B00:00")
    end
    it "errors if the date is invalid" do
      expect { @client.commits_before "sferik/rails_admin", "A pear" }.to raise_error ArgumentError
    end
    it "handles branch or sha argument" do
      commits = @client.commits_before("sferik/rails_admin", "2011-01-15", "master")
      assert_requested :get, github_url("/repos/sferik/rails_admin/commits?sha=master&until=2011-01-15T00:00:00%2B00:00")
    end
    it "handles the sha option" do
      commits = @client.commits_before("sferik/rails_admin", "2011-01-15", :sha => "master")
      assert_requested :get, github_url("/repos/sferik/rails_admin/commits?sha=master&until=2011-01-15T00:00:00%2B00:00")
    end
  end # .commits_before

  describe ".commits_between", :vcr do
    it "returns all commits until the specified date" do
      commits = @client.commits_between("sferik/rails_admin", "2011-01-20", "2013-01-20")
      expect(commits).to be_kind_of Array
      assert_requested :get, github_url("/repos/sferik/rails_admin/commits?since=2011-01-20T00:00:00%2B00:00&until=2013-01-20T00:00:00%2B00:00")
    end
    it "errors if the date is invalid" do
      expect { @client.commits_between "sferik/rails_admin", "A pear" }.to raise_error ArgumentError
    end
    it "handles branch or sha argument" do
      commits = @client.commits_between("sferik/rails_admin", "2011-01-20", "2013-01-20", "master")
      assert_requested :get, github_url("/repos/sferik/rails_admin/commits?sha=master&since=2011-01-20T00:00:00%2B00:00&until=2013-01-20T00:00:00%2B00:00")
    end
    it "handles the sha option" do
      commits = @client.commits_between("sferik/rails_admin", "2011-01-20", "2013-01-20", :sha => "master")
      assert_requested :get, github_url("/repos/sferik/rails_admin/commits?sha=master&since=2011-01-20T00:00:00%2B00:00&until=2013-01-20T00:00:00%2B00:00")
    end
  end # .commits_between

  describe ".commit", :vcr do
    it "returns a commit" do
      commit = @client.commit("sferik/rails_admin", "3cdfabd973bc3caac209cba903cfdb3bf6636bcd")
      expect(commit.author.login).to eq 'caboteria'
      assert_requested :get, github_url("/repos/sferik/rails_admin/commits/3cdfabd973bc3caac209cba903cfdb3bf6636bcd")
    end
  end # .commit

  describe ".create_commit", :vcr do
    it "creates a commit" do
      last_commit = @client.commits('api-playground/api-sandbox').last
      commit = @client.create_commit("api-playground/api-sandbox", "My commit message", last_commit.commit.tree.sha, last_commit.sha)
      assert_requested :post, github_url("/repos/api-playground/api-sandbox/git/commits")
    end
  end # .create_commit

  describe ".merge", :vcr do
    it "merges a branch into another" do
      begin
        @client.delete_ref("api-playground/api-sandbox", "heads/branch-to-merge")
      rescue Octokit::Error::UnprocessableEntity
      end
      last_commit = @client.commits('api-playground/api-sandbox').last
      branch = @client.create_ref("api-playground/api-sandbox", "heads/branch-to-merge", last_commit.sha)
      merge = @client.merge("api-playground/api-sandbox", "master", "branch-to-merge", :commit_message => "Testing the merge API")
      assert_requested :post, github_url("/repos/api-playground/api-sandbox/merges")
    end
  end # .merge

  describe ".compare", :vcr do
    it "returns a comparison" do
      comparison = @client.compare("gvaughn/octokit", '0e0d7ae299514da692eb1cab741562c253d44188', 'b7b37f75a80b8e84061cd45b246232ad958158f5')
      expect(comparison.base_commit.sha).to eq('0e0d7ae299514da692eb1cab741562c253d44188')
      expect(comparison.merge_base_commit.sha).to eq('b7b37f75a80b8e84061cd45b246232ad958158f5')
      assert_requested :get, github_url("/repos/gvaughn/octokit/compare/0e0d7ae299514da692eb1cab741562c253d44188...b7b37f75a80b8e84061cd45b246232ad958158f5")
    end
  end # .compare
end
