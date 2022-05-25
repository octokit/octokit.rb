require 'helper'

describe Octokit::Client::Pulls do

  before do
    Octokit.reset!
    @client = oauth_client
  end

  describe ".pulls", :vcr do
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
  end # .pulls

  describe ".create_pull", :vcr do
    it "creates a pull request" do
      @pull = @client.create_pull(@test_repo, "A new PR", "branch-for-pr", "master", :body => "The Body")
      expect(@pull.title).to eq("A new PR")
      assert_requested :post, github_url("/repos/#{@test_repo}/pulls")
      @client.close_pull(@test_repo, @pull.number)
    end

    it "creates a pull request without body argument" do
      @pull = @client.create_pull(@test_repo, "A new PR", "branch-for-pr", "master")
      expect(@pull.body).to be_nil
      assert_requested :post, github_url("/repos/#{@test_repo}/pulls")
      @client.close_pull(@test_repo, @pull.number)
    end
  end # .create_pull

  context "with pull" do

    before(:each) do
      # create new branch?
      @pull = @client.create_pull(@test_repo, "A new PR", "branch-for-pr", "master", :body => "The Body")
    end

    after(:each) do
      @client.close_pull(@test_repo, @pull.number)
    end

    describe ".pull", :vcr do
      it "returns a pull request" do
        pull = @client.pull(@test_repo, @pull.number)
        expect(pull.title).to eq("A new PR")
        assert_requested :get, github_url("/repos/#{@test_repo}/pulls/#{@pull.number}")
      end
    end # .pull

    describe ".update_pull", :vcr do
      it "updates a pull request" do
        @client.update_pull(@test_repo, @pull.number, :title => 'New title', :body=> 'Updated body')
        assert_requested :patch, github_url("/repos/#{@test_repo}/pulls/#{@pull.number}")
      end
    end # .update_pull

    describe ".pull_merged?", :vcr do
      it "returns whether the pull request has been merged" do
        merged = @client.pull_merged?(@test_repo, @pull.number)
        expect(merged).not_to be true
        assert_requested :get, github_url("/repos/#{@test_repo}/pulls/#{@pull.number}/merge")
      end
    end # .pull_merged?

    describe ".update_pull_branch", :vcr do
      it "updates the pull request branch" do
        result = @client.update_pull_branch(@test_repo, @pull.number)
      end
    end # .update_pull_branch

    context "with pull request comment" do

      before do
        @comment = @client.create_review_comment \
          @test_repo,
          @pull.number,
          "The body",
          @pull.head.sha,
          "README.md",
          :position => 1
      end

      describe ".create_review_comment", :vcr do
        it "creates a new comment on a pull request" do
          assert_requested :post, github_url("/repos/#{@test_repo}/pulls/#{@pull.number}/comments")
        end
      end # .create_review_comment

      describe ".update_review_comment", :vcr do
        it "updates a pull request comment" do
          comment = @client.update_review_comment(@test_repo, @comment.id, ":shipit:")
          expect(comment.body).to eq(":shipit:")
          assert_requested :patch, github_url("/repos/#{@test_repo}/pulls/comments/#{@comment.id}")
        end
      end # .update_review_comment

      describe ".delete_review_comment", :vcr do
        it "deletes a pull request comment" do
          result = @client.delete_review_comment(@test_repo, @comment.id)
          expect(result).to eq(true)
          assert_requested :delete, github_url("/repos/#{@test_repo}/pulls/comments/#{@comment.id}")
        end
      end # .delete_review_comment

      describe ".create_comment_reply", :vcr do
        it "creates a review comment reply" do
          result = @client.create_comment_reply(@test_repo, @pull.number, @comment.id, "replying")
          expect(result.body).to eq("replying")
          assert_requested :post, github_url("/repos/#{@test_repo}/pulls/#{@pull.number}/comments/#{@comment.id}/replies")
        end
      end # .create_comment_reply

      describe ".create_pull_request_review_comment_reaction", :vcr do
        it "creates a reaction on a pull request comment" do
          result = @client.create_pull_request_review_comment_reaction(@test_repo, @comment.id, "hooray")
          expect(result.content).to eq("hooray")
          assert_requested :post, github_url("/repos/#{@test_repo}/pulls/comments/#{@comment.id}/reactions")
        end
      end # .create_pull_request_review_comment_reaction

      context "with pull request comment reaction", :vcr do
        before do
          @reaction = @client.create_pull_request_review_comment_reaction(@test_repo, @comment.id, "rocket")
        end

        describe ".pull_request_review_comment_reactions" do
          it "returns a list of reactions" do
            result = @client.pull_request_review_comment_reactions(@test_repo, @comment.id)
            expect(result).to be_kind_of Array
          assert_requested :post, github_url("/repos/#{@test_repo}/pulls/comments/#{@comment.id}/reactions")
          end
        end # .pull_request_review_comment_reactions

        describe ".delete_pull_request_comment_reaction" do
          it "deletes a reaction on a pull request comment" do
            result = @client.delete_pull_request_comment_reaction(@test_repo, @comment.id, @reaction.id)
            expect(result).to be_truthy
            assert_requested :post, github_url("/repos/#{@test_repo}/pulls/comments/#{@comment.id}/reactions")
          end
        end # .pull_request_review_comment_reactions
      end # with pull request comment reaction
    end # with pull request comment

    describe ".left_review_comment", :vcr do
      it "creates a new comment on the left side of a pull request" do
        comment = @client.left_review_comment \
          @test_repo,
          @pull.number,
          "The body",
          @pull.head.sha,
          "README.md",
          :line => 1,
          :accept => "application/vnd.github.comfort-fade-preview+json"
      end
    end # .left_review_comment

    describe ".right_review_comment", :vcr do
      it "creates a new comment on the right side of a pull request" do
        comment = @client.left_review_comment \
          @test_repo,
          @pull.number,
          "The body",
          @pull.head.sha,
          "README.md",
          :line => 1,
          :accept => "application/vnd.github.comfort-fade-preview+json"
      end
    end # .right_review_comment

    context "with closed pull request" do
      before do
        @updated_pull = @client.close_pull(@test_repo, @pull.number)
      end

      describe ".close_pull", :vcr do
        it "closes a pull request" do
          expect(@updated_pull.state).to eq('closed')
          assert_requested :patch, github_url("/repos/#{@test_repo}/pulls/#{@pull.number}")
        end
      end

      describe ".reopen_pull", :vcr do
        it "closes a pull request" do
          response = @client.reopen_pull(@test_repo, @pull.number)
          expect(response.state).to eq('open')
          assert_requested :patch, github_url("/repos/#{@test_repo}/pulls/#{@pull.number}"), times: 2
        end
      end
    end # with closed pull request
  end # with pull

  # stub this so we don't have to set up new fixture data
  describe ".merge_pull" do
    it "merges the pull request" do
      request = stub_put(github_url("/repos/api-playground/api-sandbox/pulls/123/merge"))
      @client.merge_pull("api-playground/api-sandbox", 123)
      assert_requested request
    end
  end # .merge_pull

  describe ".pulls_review_comments", :vcr do
    it "returns all comments on all pull requests" do
      comments = @client.pulls_review_comments("octokit/octokit.rb")
      expect(comments).to be_kind_of Array
      assert_requested :get, github_url("/repos/octokit/octokit.rb/pulls/comments")
    end
  end # .pulls_review_comments

  describe ".pull_commits", :vcr do
    it "returns the commits for a pull request" do
      commits = @client.pull_commits("octokit/octokit.rb", 67)
      expect(commits).to be_kind_of Array
      assert_requested :get, github_url("/repos/octokit/octokit.rb/pulls/67/commits")
    end
  end # .pull_commits

  describe ".pull_files", :vcr do
    it "lists files for a pull request" do
      files = @client.pull_files("octokit/octokit.rb", 67)
      file = files.first
      expect(file.filename).to eq('lib/octokit/configuration.rb')
      expect(file.additions).to eq(4)
      assert_requested :get, github_url("/repos/octokit/octokit.rb/pulls/67/files")
    end
  end # .pull_files

  describe ".review_comments", :vcr do
    it "returns the comments for a pull request" do
      comments = @client.review_comments("octokit/octokit.rb", 67)
      expect(comments).to be_kind_of Array
      assert_requested :get, github_url("/repos/octokit/octokit.rb/pulls/67/comments")
    end
  end # .review_comments

  describe ".review_comment", :vcr do
    it "returns a comment on a pull request" do
      comment = @client.review_comment("octokit/octokit.rb", 1903950)
      expect(comment.body).not_to be_nil
      assert_requested :get, github_url("/repos/octokit/octokit.rb/pulls/comments/1903950")
    end
  end # .review_comment
end
