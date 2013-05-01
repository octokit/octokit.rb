require File.expand_path('../../../spec_helper.rb', __FILE__)

describe Octokit::Client::PullRequests do

  before do
    Octokit.reset!
    VCR.insert_cassette 'pull_requests', :match_requests_on => [:uri, :method, :query, :body]
    @client = basic_auth_client
  end

  after do
    Octokit.reset!
    VCR.eject_cassette
  end

  describe ".create_pull_request" do
    it "creates a pull request" do
      pull = @client.create_pull_request("api-playground/api-sandbox", "master", "cool-branch", "The Title", "The Body")
      pull.title.must_equal "The Title"
      assert_requested :post, basic_github_url("/repos/api-playground/api-sandbox/pulls")
    end
  end # .create_pull_request

  describe ".pull_request" do
    it "returns a pull request" do
      pull = @client.pull("api-playground/api-sandbox", 1)
      pull.title.must_equal "The Title"
      assert_requested :get, basic_github_url("/repos/api-playground/api-sandbox/pulls/1")
    end
  end # .pull_request

  describe ".update_pull_request" do
    it "updates a pull request" do
      pull = @client.update_pull_request('api-playground/api-sandbox', 1, 'New title', 'Updated body')
      assert_requested :patch, basic_github_url("/repos/api-playground/api-sandbox/pulls/1")
    end
  end # .update_pull_request

  describe ".pull_merged?" do
    it "returns whether the pull request has been merged" do
      merged = @client.pull_merged?("api-playground/api-sandbox", 1)
      refute merged
      assert_requested :get, basic_github_url("/repos/api-playground/api-sandbox/pulls/1/merge")
    end
  end # .pull_merged?

  describe ".create_pull_request_for_issue" do
    it "creates a pull request and attach it to an existing issue" do
      pull = @client.create_pull_request_for_issue("api-playground/api-sandbox", "master", "cool-branch", 2)
      assert_requested :post, basic_github_url("/repos/api-playground/api-sandbox/pulls")
    end
  end # .create_pull_request_for_issue

  describe ".pull_requests" do
    it "returns all pull requests" do
      pulls = Octokit.pulls("pengwynn/octokit")
      pulls.must_be_kind_of Array
      assert_requested :get, github_url("/repos/pengwynn/octokit/pulls")
    end
  end # .pull_requests

  describe ".pull_requests_comments" do
    it "returns all comments on all pull requests" do
      comments = Octokit.pull_requests_comments("pengwynn/octokit")
      comments.must_be_kind_of Array
      assert_requested :get, github_url("/repos/pengwynn/octokit/pulls/comments")
    end
  end # .pull_requests_comments

  describe ".pull_request_commits" do
    it "returns the commits for a pull request" do
      commits = Octokit.pull_commits("pengwynn/octokit", 67)
      commits.must_be_kind_of Array
      assert_requested :get, github_url("/repos/pengwynn/octokit/pulls/67/commits")
    end
  end # .pull_request_commits

  describe ".pull_request_comments" do
    it "returns the comments for a pull request" do
      comments = Octokit.pull_comments("pengwynn/octokit", 67)
      comments.must_be_kind_of Array
      assert_requested :get, github_url("/repos/pengwynn/octokit/pulls/67/comments")
    end
  end # .pull_request_comments

  describe ".pull_request_comment" do
    it "returns a comment on a pull request" do
      comment = Octokit.pull_request_comment("pengwynn/octokit", 1903950)
      assert comment.body
      assert_requested :get, github_url("/repos/pengwynn/octokit/pulls/comments/1903950")
    end
  end # .pull_request_comment

  describe ".create_pull_request_comment" do
    it "creates a new comment on a pull request" do
      new_comment = {
        :body => "Hawt",
        :commit_id => "e3215d187fbe5cbe7b3522f8966452c2eeff7faf",
        :path => "README",
        :position => 1
      }
      comment = @client.create_pull_request_comment("api-playground/api-sandbox", 1, new_comment[:body], new_comment[:commit_id], new_comment[:path], new_comment[:position])
      assert_requested :post, basic_github_url("/repos/api-playground/api-sandbox/pulls/1/comments")
    end
  end # .create_pull_request_comment

  describe ".create_pull_request_comment_reply" do
    it "creates a new reply to a pull request comment" do
      skip
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
  end # .create_pull_request_comment_reply

  describe ".update_pull_request_comment" do
    it "updates a pull request comment" do
      skip
      stub_patch("https://api.github.com/repos/pengwynn/octokit/pulls/comments/1907270").
        with(:body => { :body => ":shipit:"}).
          to_return(json_response("pull_request_comment_update.json"))
      comment = @client.update_pull_request_comment("pengwynn/octokit", 1907270, ":shipit:")
      expect(comment.body).to eq(":shipit:")
    end
  end # .update_pull_request_comment

  describe ".delete_pull_request_comment" do
    it "deletes a pull request comment" do
      skip
      stub_delete("https://api.github.com/repos/pengwynn/octokit/pulls/comments/1907270").
        to_return(:status => 204)
      result = @client.delete_pull_request_comment("pengwynn/octokit", 1907270)
      expect(result).to eq(true)
    end
  end # .delete_pull_request_comment

  describe ".merge_pull_request" do
    it "merges the pull request" do
      skip
      stub_put("https://api.github.com/repos/pengwynn/octokit/pulls/67/merge").
        to_return(json_response("pull_request_merged.json"))
      response = @client.merge_pull_request("pengwynn/octokit", 67)
      expect(response["sha"]).to eq("2097821c7c5aa4dc02a2cc54d5ca51968b373f95")
    end
  end # .merge_pull_request

  describe ".pull_request_files" do
    it "lists files for a pull request" do
      skip
      stub_get("https://api.github.com/repos/pengwynn/octokit/pulls/142/files").
        to_return(json_response("pull_request_files.json"))

      files = @client.pull_request_files("pengwynn/octokit", 142)
      file = files.first
      expect(file.filename).to eq('README.md')
      expect(file.additions).to eq(28)
    end
  end # .pull_request_files

end
