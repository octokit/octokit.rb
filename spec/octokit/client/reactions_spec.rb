require 'helper'

describe Octokit::Client::Reactions do
  before do
    Octokit.reset!
    @client = oauth_client
  end

  context "with issue reaction", :vcr do
    before do
      @issue = @client.create_issue(@test_repo, "Migrate issues to v3")
      @reaction = @client.create_issue_reaction(@test_repo, @issue.number, "+1", accept: preview_header)
    end

    describe ".delete_issue_reaction" do
      it "deletes the issue reaction" do
        @client.delete_issue_reaction(@test_repo, @issue.id, @reaction.id, accept: preview_header)
        assert_requested :delete, github_url("/repos/#{@test_repo}/issues/#{@issue.id}/reactions/#{@reaction.id}")
      end
    end # .delete_issue_reaction

    describe ".delete_reaction_legacy" do
      it "deletes the reaction" do
        @client.delete_reaction_legacy(@reaction.id, accept: preview_header)
        assert_requested :delete, github_url("/reactions/#{@reaction.id}")
      end
    end # .delete_reaction_legacy

    context "with issue comment" do
      before(:each) do
        @issue_comment = @client.create_issue_comment(@test_repo, @issue.number, "Another test comment")
      end

      describe ".issue_comment_reactions" do
        it "returns an Array of reactions" do
          reactions = @client.issue_comment_reactions(@test_repo, @issue_comment.id, accept: preview_header)
          expect(reactions).to be_kind_of Array
          assert_requested :get, github_url("/repos/#{@test_repo}/issues/comments/#{@issue_comment.id}/reactions")
        end
      end # .issue_comment_reactions

      describe ".create_issue_comment_reaction" do
        it "creates a reaction" do
          reaction = @client.create_issue_comment_reaction(@test_repo, @issue_comment.id, "+1", accept: preview_header)
          expect(reaction.content).to eql("+1")
          assert_requested :post, github_url("/repos/#{@test_repo}/issues/comments/#{@issue_comment.id}/reactions")
        end
      end # .create_issue_comment_reaction

      context "with issue comment reaction", :vcr do
        before do
          @reaction = @client.create_issue_comment_reaction(@test_repo, @issue_comment.id, "+1", accept: preview_header)
        end

        describe ".delete_issue_comment_reaction" do
          it "deletes the issue comment reaction" do
            @client.delete_issue_comment_reaction(@test_repo, @issue_comment.id, @reaction.id, accept: preview_header)
            assert_requested :delete, github_url("/repos/#{@test_repo}/issues/comments/#{@issue_comment.id}/reactions/#{@reaction.id}")
          end
        end # .delete_issue_comment_reaction
      end # with issue comment reaction
    end # with issue comment
  end # with issue reaction

  context "with pull" do
    before(:each) do
      @pull = @client.create_pull(@test_repo, "A new PR", "branch-for-pr", "master", :body => "The Body")
    end

    after(:each) do
      @client.close_pull(@test_repo, @pull.number)
    end

    context "with pull request comment" do

      before do
        @comment = @client.create_pull_comment \
          @test_repo,
          @pull.number,
          "The body",
          @pull.head.sha,
          "README.md",
          :position => 1
      end

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
  end # with pull request

  private

  def preview_header
    Octokit::Preview::PREVIEW_TYPES[:reactions]
  end
end
