require 'helper'

describe Octokit::Client::CommitComments do
  before do
    @client = oauth_client
  end

  describe ".list_commit_comments", :vcr do
    it "returns a list of all commit comments" do
      commit_comments = @client.list_commit_comments("sferik/rails_admin")
      expect(commit_comments.first.user.login).to eq("sferik")
      assert_requested :get, github_url("/repos/sferik/rails_admin/comments")
    end
  end # .list_commit_comments

  describe ".commit_comments", :vcr do
    it "returns a list of comments for a specific commit" do
      commit_comments = @client.commit_comments("sferik/rails_admin", "629e9fd9d4df25528e84d31afdc8ebeb0f56fbb3")
      expect(commit_comments.first.user.login).to eq("bbenezech")
      assert_requested :get, github_url("/repos/sferik/rails_admin/commits/629e9fd9d4df25528e84d31afdc8ebeb0f56fbb3/comments")
    end
  end # .commit_comments

  describe ".commit_comment", :vcr do
    it "returns a single commit comment" do
      commit = @client.commit_comment("sferik/rails_admin", "861907")
      expect(commit.user.login).to eq("bbenezech")
      assert_requested :get, github_url("/repos/sferik/rails_admin/comments/861907")
    end
  end # .commit_comment

  context "with commit comment", :vcr do
    before do
      @commit = @client.commits(@test_repo).last.rels[:self].get.data
      @commit_comment = @client.create_commit_comment \
        @test_repo,
        @commit.sha, ":metal:\n:sparkles:\n:cake:",
        @commit.files.last.filename
    end

    after do
      @client.delete_commit_comment @test_repo, @commit_comment.id
    end

    describe ".create_commit_comment" do
      it "creates a commit comment" do
        expect(@commit_comment.user.login).to eq(test_github_login)
        assert_requested :post, github_url("/repos/#{@test_repo}/commits/#{@commit.sha}/comments")
      end
    end # .create_commit_comment

    describe ".update_commit_comment" do
      it "updates a commit comment" do
        updated_comment = @client.update_commit_comment(@test_repo, @commit_comment.id, ":penguin:")
        expect(updated_comment.body).to eq(":penguin:")
        assert_requested :patch, github_url("/repos/#{@test_repo}/comments/#{@commit_comment.id}")
      end
    end # .update_commit_comment

    describe ".delete_commit_comment" do
      it "deletes a commit comment" do
        result = @client.delete_commit_comment(@test_repo, @commit_comment.id)
        expect(result).to be true
        assert_requested :delete, github_url("/repos/#{@test_repo}/comments/#{@commit_comment.id}")
      end
    end # .delete_commit_comment
  end # with commit comment
end
