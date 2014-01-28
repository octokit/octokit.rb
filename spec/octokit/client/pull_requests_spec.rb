require 'helper'

describe Octokit::Client::PullRequests do
  before do
    Octokit.reset!
    @client = oauth_client
  end

  describe ".pull_requests", :vcr do
    it "lists all pull requests" do
      pulls = @client.pulls("octokit/octokit.rb")
      expect(pulls).to be_kind_of Array
      assert_requested :get, github_url("/repos/octokit/octokit.rb/pulls")
    end
    it "lists all pull requests with state option" do
      pulls = @client.pulls("octokit/octokit.rb", :state => 'open')
      expect(pulls).to be_kind_of Array
      assert_requested :get, github_url("/repos/octokit/octokit.rb/pulls?state=open")
    end
    # Deprecated
    it "lists all pull requests with state argument" do
      pulls = @client.pulls("octokit/octokit.rb", 'closed')
      expect(pulls).to be_kind_of Array
      assert_requested :get, github_url("/repos/octokit/octokit.rb/pulls?state=closed")
    end
  end # .pull_requests

  describe ".pull_requests_comments", :vcr do
    it "returns all comments on all pull requests" do
      comments = @client.pull_requests_comments("octokit/octokit.rb")
      expect(comments).to be_kind_of Array
      assert_requested :get, github_url("/repos/octokit/octokit.rb/pulls/comments")
    end
  end # .pull_requests_comments

  describe ".pull_request_commits", :vcr do
    it "returns the commits for a pull request" do
      commits = @client.pull_commits("octokit/octokit.rb", 67)
      expect(commits).to be_kind_of Array
      assert_requested :get, github_url("/repos/octokit/octokit.rb/pulls/67/commits")
    end
  end # .pull_request_commits

  describe ".pull_request_files", :vcr do
    it "lists files for a pull request" do
      files = @client.pull_request_files("octokit/octokit.rb", 67)
      file = files.first
      expect(file.filename).to eq('lib/octokit/configuration.rb')
      expect(file.additions).to eq(4)
      assert_requested :get, github_url("/repos/octokit/octokit.rb/pulls/67/files")
    end
  end # .pull_request_files

  describe ".pull_request_comments", :vcr do
    it "returns the comments for a pull request" do
      comments = @client.pull_comments("octokit/octokit.rb", 67)
      expect(comments).to be_kind_of Array
      assert_requested :get, github_url("/repos/octokit/octokit.rb/pulls/67/comments")
    end
  end # .pull_request_comments

  describe ".pull_request_comment", :vcr do
    it "returns a comment on a pull request" do
      comment = @client.pull_request_comment("octokit/octokit.rb", 1903950)
      expect(comment.body).to_not be_nil
      assert_requested :get, github_url("/repos/octokit/octokit.rb/pulls/comments/1903950")
    end
  end # .pull_request_comment

  context "with repository" do
    before do
      @test_repo = setup_test_repo(:auto_init => true).full_name
      @master_sha = @client.commits(@test_repo).first.sha
    end

    after do
      teardown_test_repo @test_repo
    end

    context "with modified branch" do
      before do
        @branch = 'feature-branch'
        @client.create_ref(@test_repo, "heads/#{@branch}", @master_sha)
        @new_contents = @client.create_contents \
          @test_repo,
          'new-file.txt',
          'add new-file.txt',
          'new file contents',
          :branch => @branch
      end

      describe ".create_pull_request_for_issue", :vcr do
        it "creates a pull request and attach it to an existing issue" do
          issue = @client.create_issue(@test_repo, 'A new issue', "Gonna turn this into a PR")
          pull = @client.create_pull_request_for_issue(@test_repo, "master", @branch, issue.number)
          assert_requested :post, github_url("/repos/#{@test_repo}/pulls")
        end
      end # .create_pull_request_for_issue

      context "with pull request" do
        before(:each) do
          @pull = @client.create_pull_request \
            @test_repo,
            "master",
            @branch,
            "A new PR",
            "The Body"
        end

        describe ".create_pull_request", :vcr do
          it "creates a pull request" do
            expect(@pull.title).to eq "A new PR"
            assert_requested :post, github_url("/repos/#{@test_repo}/pulls")
          end
        end # .create_pull_request

        describe ".pull_request", :vcr do
          it "returns a pull request" do
            pull = @client.pull(@test_repo, @pull.number)
            expect(pull.title).to eq "A new PR"
            assert_requested :get, github_url("/repos/#{@test_repo}/pulls/#{@pull.number}")
          end
        end # .pull_request

        describe ".update_pull_request", :vcr do
          it "updates a pull request" do
            pull = @client.update_pull_request(@test_repo, @pull.number, 'New title', 'Updated body')
            assert_requested :patch, github_url("/repos/#{@test_repo}/pulls/#{@pull.number}")
          end
        end # .update_pull_request

        describe ".pull_merged?", :vcr do
          it "returns whether the pull request has been merged" do
            merged = @client.pull_merged?(@test_repo, @pull.number)
            expect(merged).to_not be_true
            assert_requested :get, github_url("/repos/#{@test_repo}/pulls/#{@pull.number}/merge")
          end
        end # .pull_merged?

        describe ".merge_pull_request", :vcr do
          it "merges the pull request" do
            result = @client.merge_pull_request(@test_repo, @pull.number)
            expect(result.merged).to be_true
            assert_requested :put, github_url("/repos/#{@test_repo}/pulls/#{@pull.number}/merge")
          end
        end # .merge_pull_request

        describe ".close_pull_request", :vcr do
          it "closes a pull request" do
            response = @client.close_pull_request(@test_repo, @pull.number)
            expect(response.state).to eq 'closed'
            assert_requested :patch, github_url("/repos/#{@test_repo}/pulls/#{@pull.number}")
          end
        end # .close_pull_request

        context "with pull request comment" do
          before do
            new_comment = {
              :body => "Hawt",
              :commit_id => @new_contents.commit.sha,
              :path => @new_contents.content.path,
              :position => 1
            }
            @comment = @client.create_pull_request_comment \
              @test_repo,
              @pull.number,
              new_comment[:body],
              new_comment[:commit_id],
              new_comment[:path],
              new_comment[:position]
          end

          describe ".create_pull_request_comment", :vcr do
            it "creates a new comment on a pull request" do
              assert_requested :post, github_url("/repos/#{@test_repo}/pulls/#{@pull.number}/comments")
            end
          end # .create_pull_request_comment

          describe ".create_pull_request_comment_reply", :vcr do
            it "creates a new reply to a pull request comment" do
              new_comment = {
                :body => "done.",
                :in_reply_to => @comment.id
              }
              reply = @client.create_pull_request_comment_reply(@test_repo, @pull.number, new_comment[:body], new_comment[:in_reply_to])
              assert_requested :post, github_url("/repos/#{@test_repo}/pulls/#{@pull.number}/comments"), :times => 2
              expect(reply.body).to eq(new_comment[:body])
            end
          end # .create_pull_request_comment_reply

          describe ".update_pull_request_comment", :vcr do
            it "updates a pull request comment" do
              comment = @client.update_pull_request_comment(@test_repo, @comment.id, ":shipit:")
              expect(comment.body).to eq(":shipit:")
              assert_requested :patch, github_url("/repos/#{@test_repo}/pulls/comments/#{@comment.id}")
            end
          end # .update_pull_request_comment

          describe ".delete_pull_request_comment", :vcr do
            it "deletes a pull request comment" do
              result = @client.delete_pull_request_comment(@test_repo, @comment.id)
              expect(result).to eq(true)
              assert_requested :delete, github_url("/repos/#{@test_repo}/pulls/comments/#{@comment.id}")
            end
          end # .delete_pull_request_comment
        end # with pull request comment
      end # with pull request
    end # with modified branch
  end # with repository
end # Octokit::Client::PullRequests
