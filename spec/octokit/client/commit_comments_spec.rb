require 'helper'

describe Octokit::Client::CommitComments do

  before do
    Octokit.reset!
    VCR.insert_cassette 'commit_comments', :match_requests_on => [:method, :uri, :query]
  end

  after do
    VCR.eject_cassette
  end

  describe ".list_commit_comments" do
    it "returns a list of all commit comments" do
      commit_comments = Octokit.list_commit_comments("sferik/rails_admin")
      expect(commit_comments.first.user.login).to eq("sferik")
      assert_requested :get, github_url("/repos/sferik/rails_admin/comments")
    end
  end # .list_commit_comments

  describe ".commit_comments" do
    it "returns a list of comments for a specific commit" do
      commit_comments = Octokit.commit_comments("sferik/rails_admin", "629e9fd9d4df25528e84d31afdc8ebeb0f56fbb3")
      expect(commit_comments.first.user.login).to eq("bbenezech")
      assert_requested :get, github_url("/repos/sferik/rails_admin/commits/629e9fd9d4df25528e84d31afdc8ebeb0f56fbb3/comments")
    end
  end # .commit_comments

  describe ".commit_comment" do
    it "returns a single commit comment" do
      commit = Octokit.commit_comment("sferik/rails_admin", "861907")
      expect(commit.user.login).to eq("bbenezech")
      assert_requested :get, github_url("/repos/sferik/rails_admin/comments/861907")
    end
  end # .commit_comment

  describe ".create_commit_comment" do
    it "creates a commit comment" do
      client = basic_auth_client
      commit_comment = client.create_commit_comment("api-playground/api-sandbox", "eb11b3141c9dec3ba88d15b499d597a65df15320", ":metal:\n:sparkles:\n:cake:", ".todo")
      expect(commit_comment.user.login).to eq test_github_login
      assert_requested :post, basic_github_url("/repos/api-playground/api-sandbox/commits/eb11b3141c9dec3ba88d15b499d597a65df15320/comments")
    end
  end # .create_commit_comment

  describe ".update_commit_comment" do
    it "updates a commit comment" do
      client = basic_auth_client
      commit_comment = client.update_commit_comment("api-playground/api-sandbox", 3132501, ":penguin:")
      assert_requested :patch, basic_github_url("/repos/api-playground/api-sandbox/comments/3132501")
    end
  end # .update_commit_comment

  describe ".delete_commit_comment" do
    it "deletes a commit comment" do
      client = basic_auth_client
      result = client.delete_commit_comment("api-playground/api-sandbox", 3132501)
      expect(result).to be_true
      assert_requested :delete, basic_github_url("/repos/api-playground/api-sandbox/comments/3132501")
    end
  end # .delete_commit_comment
end
