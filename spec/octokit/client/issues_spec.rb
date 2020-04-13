require 'helper'

describe Octokit::Client::Issues do

  before do
    Octokit.reset!
    @client = oauth_client
    @test_login = test_github_login
  end

  after do
    Octokit.reset!
  end

  describe ".issues", :vcr do
    it "returns dashboard issues for the authenticated user" do
      issues = @client.issues
      expect(issues).to be_kind_of Array
      assert_requested :get, github_url("/issues")
    end
  end # .issues

  describe ".repo_issues", :vcr do
    it "returns issues for a repository" do
      issues = @client.repo_issues(@test_repo)
      expect(issues).to be_kind_of Array
      assert_requested :get, github_url("/repos/#{@test_repo}/issues")
    end
  end # .repo_issues

  describe ".org_issues", :vcr do
    it "returns issues for the organization for the authenticated user" do
      issues = @client.org_issues(test_github_org)
      expect(issues).to be_kind_of Array
      assert_requested :get, github_url("/orgs/#{test_github_org}/issues")
    end
  end # .org_issues

  context "with repository", :vcr do
    describe ".create_issue", :vcr do
      it "creates an issue" do
        issue = @client.create_issue \
          @test_repo,
          "Migrate issues to v3"
        expect(issue.title).to match(/Migrate/)
        assert_requested :post, github_url("/repos/#{@test_repo}/issues")
      end

      it "creates an issue with labels array" do
        issue = @client.create_issue \
          @test_repo,
          "New issue with labels array",
          :labels => %w(bug feature)
        expect(issue.title).to match(/array/)
        expect(issue.labels.map(&:name)).to include("feature")
        assert_requested :post, github_url("/repos/#{@test_repo}/issues")
      end

      it "creates an issue without body argument" do
        issue = @client.create_issue(@test_repo, "New issue without body argument")
        expect(issue.body).to be_nil
        assert_requested :post, github_url("/repos/#{@test_repo}/issues")
      end
    end # .create_issue

    context "with issue", :vcr do
      before(:each) do
        @issue = @client.create_issue(@test_repo, "Migrate issues to v3", :body => "Move all Issues calls to v3 of the API")
      end

      describe ".issue", :vcr do
        it "returns an issue" do
          issue = @client.issue(@test_repo, @issue.number)
          assert_requested :get, github_url("/repos/#{@test_repo}/issues/#{@issue.number}")
          expect(issue.number).to eq(@issue.number)
        end
        it "returns a full issue" do
          issue = @client.issue(@test_repo, @issue.number, :accept => 'application/vnd.github.full+json')
          assert_requested :get, github_url("/repos/#{@test_repo}/issues/#{@issue.number}")
          expect(issue.body_html).to include('<p>Move all')
          expect(issue.body_text).to include('Move all')
        end
      end # .issue

      describe ".close_issue", :vcr do
        it "closes an issue" do
          issue = @client.close_issue(@test_repo, @issue.number)
          expect(issue.state).to eq "closed"
          expect(issue.number).to eq(@issue.number)
          assert_requested :patch, github_url("/repos/#{@test_repo}/issues/#{@issue.number}")
        end
      end # .close_issue

      context "with closed issue" do
        before(:each) do
          @client.close_issue(@test_repo, @issue.number)
        end

        describe ".reopen_issue", :vcr do
          it "reopens an issue" do
            issue = @client.reopen_issue(@test_repo, @issue.number)
            expect(issue.state).to eq "open"
            expect(issue.number).to eq(@issue.number)
            assert_requested :patch, github_url("/repos/#{@test_repo}/issues/#{@issue.number}"), :times => 2
          end
        end # .reopen_issue
      end # with closed issue

      describe ".lock_issue", :vcr do
        it "locks an issue" do
          @client.lock_issue(@test_repo, @issue.number)
          assert_requested :put, github_url("/repos/#{@test_repo}/issues/#{@issue.number}/lock")
        end
      end # .lock_issue

      context "with locked issue" do
        before(:each) do
          @client.lock_issue(@test_repo, @issue.number)
        end

        describe ".unlock_issue", :vcr do
          it "unlocks an issue" do
            @client.unlock_issue(@test_repo, @issue.number)
            assert_requested :delete, github_url("/repos/#{@test_repo}/issues/#{@issue.number}/lock")
          end
        end # .unlock_issue
      end # with locked issue

      describe ".update_issue", :vcr do
        it "updates an issue" do
          issue = @client.update_issue(@test_repo, @issue.number, :title => "Use all the v3 api!")
          expect(issue.number).to eq(@issue.number)
          assert_requested :patch, github_url("/repos/#{@test_repo}/issues/#{@issue.number}")
        end
      end # .update_issue

      describe ".create_issue_comment", :vcr do
        it "adds a comment" do
          comment = @client.create_issue_comment(@test_repo, @issue.number, "A test comment")
          expect(comment.user.login).to eq(test_github_login)
          assert_requested :post, github_url("/repos/#{@test_repo}/issues/#{@issue.number}/comments")
        end
      end # .create_issue_comment

      context "with issue comment" do
        before(:each) do
          @issue_comment = @client.create_issue_comment(@test_repo, @issue.number, "Another test comment")
        end

        describe ".update_issue_comment", :vcr do
          it "updates an existing comment" do
            @client.update_issue_comment(@test_repo, @issue_comment.id, "A test comment update")
            assert_requested :patch, github_url("/repos/#{@test_repo}/issues/comments/#{@issue_comment.id}")
          end
        end # .update_issue_comment

        describe ".delete_issue_comment", :vcr do
          it "deletes an existing comment" do
            @client.delete_issue_comment(@test_repo, @issue_comment.id)
            assert_requested :delete, github_url("/repos/#{@test_repo}/issues/comments/#{@issue_comment.id}")
          end
        end # .delete_issue_comment
      end # with issue comment
    end # with issue
  end # with repository
end
