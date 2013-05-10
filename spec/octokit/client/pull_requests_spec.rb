require 'helper'

describe Octokit::Client::PullRequests do

  before do
    Octokit.reset!
    VCR.insert_cassette 'pull_requests', :match_requests_on => [:uri, :method, :query, :body]
    @client = basic_auth_client
  end

  after do
    VCR.eject_cassette
    Octokit.reset!
  end

  describe ".pull_requests" do
    it "returns all pull requests" do
      pulls = Octokit.pulls("pengwynn/octokit")
      expect(pulls).to be_kind_of Array
      assert_requested :get, github_url("/repos/pengwynn/octokit/pulls")
    end
  end # .pull_requests

  describe ".create_pull_request" do
    it "creates a pull request" do
      pull = @client.create_pull_request("api-playground/api-sandbox", "master", "branch-for-pr", "A new PR", "The Body")
      expect(pull.title).to eq "A new PR"
      assert_requested :post, basic_github_url("/repos/api-playground/api-sandbox/pulls")
    end
  end # .create_pull_request

  context "methods that require a new pull" do

    before do
      @pull = @client.create_pull_request("api-playground/api-sandbox", "master", "branch-for-pr", "A new PR", "The Body")
    end

    describe ".pull_request" do
      it "returns a pull request" do
        pull = @client.pull("api-playground/api-sandbox", @pull.number)
        expect(pull.title).to eq "A new PR"
        assert_requested :get, basic_github_url("/repos/api-playground/api-sandbox/pulls/#{@pull.number}")
      end
    end # .pull_request

    describe ".update_pull_request" do
      it "updates a pull request" do
        pull = @client.update_pull_request('api-playground/api-sandbox', @pull.number, 'New title', 'Updated body')
        assert_requested :patch, basic_github_url("/repos/api-playground/api-sandbox/pulls/#{@pull.number}")
      end
    end # .update_pull_request

    describe ".pull_merged?" do
      it "returns whether the pull request has been merged" do
        merged = @client.pull_merged?("api-playground/api-sandbox", @pull.number)
        expect(merged).to_not be_true
        assert_requested :get, basic_github_url("/repos/api-playground/api-sandbox/pulls/#{@pull.number}/merge")
      end
    end # .pull_merged?

    context "methods requiring a pull request comment" do

      before do
        new_comment = {
          :body => "Hawt",
          :commit_id => "c5ea55b0dabb77dfdaffd2344ab1a40ebd51fe32",
          :path => "new-file.txt",
          :position => 1
        }
        @comment = @client.create_pull_request_comment \
          "api-playground/api-sandbox",
          @pull.number,
          new_comment[:body],
          new_comment[:commit_id],
          new_comment[:path],
          new_comment[:position]
      end

      describe ".create_pull_request_comment" do
        it "creates a new comment on a pull request" do
          assert_requested :post, basic_github_url("/repos/api-playground/api-sandbox/pulls/#{@pull.number}/comments")
        end
      end # .create_pull_request_comment

      describe ".create_pull_request_comment_reply" do
        it "creates a new reply to a pull request comment" do
          new_comment = {
            :body => "done.",
            :in_reply_to => @comment.id
          }
          reply = @client.create_pull_request_comment_reply("api-playground/api-sandbox", @pull.number, new_comment[:body], new_comment[:in_reply_to])
          assert_requested :post, basic_github_url("/repos/api-playground/api-sandbox/pulls/#{@pull.number}/comments"), :times => 2
          expect(reply.body).to eq(new_comment[:body])
        end
      end # .create_pull_request_comment_reply

      describe ".update_pull_request_comment" do
        it "updates a pull request comment" do
          comment = @client.update_pull_request_comment("api-playground/api-sandbox", @comment.id, ":shipit:")
          expect(comment.body).to eq(":shipit:")
          assert_requested :patch, basic_github_url("/repos/api-playground/api-sandbox/pulls/comments/#{@comment.id}")
        end
      end # .update_pull_request_comment

      describe ".delete_pull_request_comment" do
        it "deletes a pull request comment" do
          result = @client.delete_pull_request_comment("api-playground/api-sandbox", @comment.id)
          expect(result).to eq(true)
          assert_requested :delete, basic_github_url("/repos/api-playground/api-sandbox/pulls/comments/#{@comment.id}")
        end
      end # .delete_pull_request_comment

    end # pull request comment methods

    describe ".close_pull_request" do
      it "closes a pull request" do
        response = @client.close_pull_request("api-playground/api-sandbox", @pull.number)
        expect(response.state).to eq 'closed'
        assert_requested :patch, basic_github_url("/repos/api-playground/api-sandbox/pulls/#{@pull.number}")
      end
    end

    # stub this so we don't have to set up new fixture data
    describe ".merge_pull_request" do
      it "merges the pull request" do
        VCR.eject_cassette
        VCR.turn_off!
        request = stub_put(basic_github_url("/repos/api-playground/api-sandbox/pulls/#{@pull.number}/merge"))
        response = @client.merge_pull_request("api-playground/api-sandbox", @pull.number)
        assert_requested request
        VCR.turn_on!
      end
    end # .merge_pull_request

  end # new @pull methods

  describe ".create_pull_request_for_issue" do
    it "creates a pull request and attach it to an existing issue" do
      issue = @client.create_issue("api-playground/api-sandbox", 'A new issue', "Gonna turn this into a PR")
      pull = @client.create_pull_request_for_issue("api-playground/api-sandbox", "master", "some-fourth-branch", issue.number)
      assert_requested :post, basic_github_url("/repos/api-playground/api-sandbox/pulls")

      # cleanup so we can re-run test with blank cassette
      @client.close_pull_request("api-playground/api-sandbox", pull.number)
    end
  end # .create_pull_request_for_issue

  describe ".pull_requests_comments" do
    it "returns all comments on all pull requests" do
      comments = Octokit.pull_requests_comments("pengwynn/octokit")
      expect(comments).to be_kind_of Array
      assert_requested :get, github_url("/repos/pengwynn/octokit/pulls/comments")
    end
  end # .pull_requests_comments

  describe ".pull_request_commits" do
    it "returns the commits for a pull request" do
      commits = Octokit.pull_commits("pengwynn/octokit", 67)
      expect(commits).to be_kind_of Array
      assert_requested :get, github_url("/repos/pengwynn/octokit/pulls/67/commits")
    end
  end # .pull_request_commits

  describe ".pull_request_files" do
    it "lists files for a pull request" do
      files = Octokit.pull_request_files("pengwynn/octokit", 67)
      file = files.first
      expect(file.filename).to eq('lib/octokit/configuration.rb')
      expect(file.additions).to eq(4)
      assert_requested :get, github_url("/repos/pengwynn/octokit/pulls/67/files")
    end
  end # .pull_request_files

  describe ".pull_request_comments" do
    it "returns the comments for a pull request" do
      comments = Octokit.pull_comments("pengwynn/octokit", 67)
      expect(comments).to be_kind_of Array
      assert_requested :get, github_url("/repos/pengwynn/octokit/pulls/67/comments")
    end
  end # .pull_request_comments

  describe ".pull_request_comment" do
    it "returns a comment on a pull request" do
      comment = Octokit.pull_request_comment("pengwynn/octokit", 1903950)
      expect(comment.body).to_not be_nil
      assert_requested :get, github_url("/repos/pengwynn/octokit/pulls/comments/1903950")
    end
  end # .pull_request_comment

end
