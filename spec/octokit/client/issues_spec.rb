require 'helper'

describe Octokit::Client::Issues do

  before do
    Octokit.reset!
    VCR.insert_cassette 'issues', :match_requests_on => [:method, :path, :body, :headers]
    @client = basic_auth_client
  end

  after do
    Octokit.reset!
    VCR.eject_cassette
  end

  describe ".list_issues" do
    it "returns issues for a repository" do
      issues = Octokit.issues("sferik/rails_admin")
      expect(issues).to be_kind_of Array
      assert_requested :get, github_url("/repos/sferik/rails_admin/issues")
    end
    it "returns dashboard issues for the authenticated user" do
      issues = @client.issues
      expect(issues).to be_kind_of Array
      assert_requested :get, basic_github_url("/issues")
    end
  end # .list_issues

  describe ".user_issues" do
    it "returns issues for the authenticated user for owned and member repos" do
      issues = @client.user_issues
      expect(issues).to be_kind_of Array
      assert_requested :get, basic_github_url("/user/issues")
    end
  end # .user_issues

  describe ".org_issues" do
    it "returns issues for the organization for the authenticated user" do
      issues = @client.org_issues('dotfiles')
      expect(issues).to be_kind_of Array
      assert_requested :get, basic_github_url("/orgs/dotfiles/issues")
    end
  end # .org_issues

  describe ".create_issue" do
    it "creates an issue" do
      issue = @client.create_issue("api-playground/api-sandbox", "Migrate issues to v3", "Move all Issues calls to v3 of the API")
      expect(issue.title).to match /Migrate/
      assert_requested :post, basic_github_url("/repos/api-playground/api-sandbox/issues")
    end
  end # .create_issue

  context "methods requiring a new issue" do

    before do
      @issue = @client.create_issue("api-playground/api-sandbox", "Migrate issues to v3", "Move all Issues calls to v3 of the API")
    end

    describe ".issue" do
      it "returns an issue" do
        issue = @client.issue("api-playground/api-sandbox", @issue.number)
        assert_requested :get, basic_github_url("/repos/api-playground/api-sandbox/issues/#{@issue.number}")
        expect(issue.number).to eq @issue.number
      end
      it "returns a full issue" do
        issue = @client.issue("api-playground/api-sandbox", @issue.number, :accept => 'application/vnd.github.full+json')
        assert_requested :get, basic_github_url("/repos/api-playground/api-sandbox/issues/#{@issue.number}")
        expect(issue.body_html).to include '<p>Move all'
        expect(issue.body_text).to include 'Move all'
      end
    end # .issue

    describe ".close_issue" do
      it "closes an issue" do
        issue = @client.close_issue("api-playground/api-sandbox", @issue.number)
        expect(issue.number).to eq @issue.number
        assert_requested :patch, basic_github_url("/repos/api-playground/api-sandbox/issues/#{@issue.number}")
      end
    end # .close_issue

    describe ".reopen_issue" do
      it "reopens an issue" do
        issue = @client.close_issue("api-playground/api-sandbox", @issue.number)
        expect(issue.number).to eq @issue.number
        assert_requested :patch, basic_github_url("/repos/api-playground/api-sandbox/issues/#{@issue.number}")
      end
    end # .reopen_issue

    describe ".update_issue" do
      it "updates an issue" do
        issue = @client.update_issue("api-playground/api-sandbox", @issue.number, "Use all the v3 api!", "")
        expect(issue.number).to eq @issue.number
        assert_requested :patch, basic_github_url("/repos/api-playground/api-sandbox/issues/#{@issue.number}")
      end
    end # .update_issue

    describe ".add_comment" do
      it "adds a comment" do
        comment = @client.add_comment("api-playground/api-sandbox", @issue.number, "A test comment")
        expect(comment.user.login).to eq test_github_login
        assert_requested :post, basic_github_url("/repos/api-playground/api-sandbox/issues/#{@issue.number}/comments")
      end
    end # .add_comment

    context "methods requiring a new issue comment" do

      before do
        @issue_comment = @client.add_comment("api-playground/api-sandbox", @issue.number, "Another test comment")
      end

      describe ".update_comment" do
        it "updates an existing comment" do
          @client.update_comment("api-playground/api-sandbox", @issue_comment.id, "A test comment update")
          assert_requested :patch, basic_github_url("/repos/api-playground/api-sandbox/issues/comments/#{@issue_comment.id}")
        end
      end # .update_comment

      describe ".delete_comment" do
        it "deletes an existing comment" do
          @client.delete_comment("api-playground/api-sandbox", @issue_comment.id)
          assert_requested :delete, basic_github_url("/repos/api-playground/api-sandbox/issues/comments/#{@issue_comment.id}")
        end # .delete_comment
      end

    end

  end

  describe ".repository_issues_comments" do
    it "returns comments for all issues in a repository" do
      comments = Octokit.issues_comments("pengwynn/octokit")
      expect(comments).to be_kind_of Array
      assert_requested :get, github_url('/repos/pengwynn/octokit/issues/comments')
    end
  end # .repository_issues_comments

  describe ".issue_comments" do
    it "returns comments for an issue" do
      comments = Octokit.issue_comments("pengwynn/octokit", 25)
      expect(comments).to be_kind_of Array
      assert_requested :get, github_url('/repos/pengwynn/octokit/issues/25/comments')
    end
  end # .issue_comments

  describe ".issue_comment" do
    it "returns a single comment for an issue" do
      comment = Octokit.issue_comment("pengwynn/octokit", 1194690)
      expect(comment.rels[:self].href).to eq "https://api.github.com/repos/pengwynn/octokit/issues/comments/1194690"
      assert_requested :get, github_url('/repos/pengwynn/octokit/issues/comments/1194690')
    end
  end # .issue_comment

end
