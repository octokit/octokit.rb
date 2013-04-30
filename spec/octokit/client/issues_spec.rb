require File.expand_path('../../../spec_helper.rb', __FILE__)

describe Octokit::Client::Issues do

  before do
    Octokit.reset!
    VCR.insert_cassette 'issues', :match_requests_on => [:method, :uri, :body]
  end

  after do
    Octokit.reset!
    VCR.eject_cassette
  end

  describe ".list_issues" do
    it "returns issues for a repository" do
      issues = Octokit.issues("sferik/rails_admin")
      issues.must_be_kind_of Array
      assert_requested :get, github_url("/repos/sferik/rails_admin/issues")
    end
    it "returns dashboard issues for the authenticated user" do
      client = basic_auth_client
      issues = client.issues
      issues.must_be_kind_of Array
      assert_requested :get, basic_github_url("/issues")
    end
  end # .list_issues

  describe ".user_issues" do
    it "returns issues for the authenticated user for owned and member repos" do
      client = basic_auth_client
      issues = client.user_issues
      issues.must_be_kind_of Array
      assert_requested :get, basic_github_url("/user/issues")
    end
  end # .user_issues

  describe ".org_issues" do
    it "returns issues for the organization for the authenticated user" do
      client = basic_auth_client
      issues = client.org_issues('dotfiles')
      issues.must_be_kind_of Array
      assert_requested :get, basic_github_url("/orgs/dotfiles/issues")
    end
  end # .org_issues

  describe ".create_issue" do
    it "creates an issue" do
      client = basic_auth_client
      issue = client.create_issue("pengwynn/api-sandbox", "Migrate issues to v3", "Move all Issues calls to v3 of the API")
      issue.title.must_match /Migrate/
      assert_requested :post, basic_github_url("/repos/pengwynn/api-sandbox/issues")
    end
  end # .create_issue

  describe ".issue" do
    it "returns an issue" do
      client = basic_auth_client
      issue = client.issue("pengwynn/api-sandbox", 22)
      assert_requested :get, basic_github_url("/repos/pengwynn/api-sandbox/issues/22")
      issue.number.must_equal 22
    end
    it "returns a full issue" do
      client = basic_auth_client
      issue = client.issue("pengwynn/api-sandbox", 22, :accept => 'application/vnd.github.full+json')
      assert_requested :get, basic_github_url("/repos/pengwynn/api-sandbox/issues/22")
      issue.body_html.must_include '<p>Move all'
      issue.body_text.must_include 'Move all'
    end
  end # .issue

  describe ".close_issue" do
    it "closes an issue" do
      client = basic_auth_client
      issue = client.close_issue("pengwynn/api-sandbox", 22)
      issue.number.must_equal 22
      assert_requested :patch, basic_github_url("/repos/pengwynn/api-sandbox/issues/22")
    end
  end # .close_issue

  describe ".reopen_issue" do
    it "reopens an issue" do
      client = basic_auth_client
      issue = client.close_issue("pengwynn/api-sandbox", 22)
      issue.number.must_equal 22
      assert_requested :patch, basic_github_url("/repos/pengwynn/api-sandbox/issues/22")
    end
  end # .reopen_issue

  describe ".update_issue" do
    it "updates an issue" do
      client = basic_auth_client
      issue = client.update_issue("pengwynn/api-sandbox", 22, "Use all the v3 api!", "")
      issue.number.must_equal 22
      assert_requested :patch, basic_github_url("/repos/pengwynn/api-sandbox/issues/22")
    end
  end # .update_issue

  describe ".repository_issues_comments" do
    it "returns comments for all issues in a repository" do
      comments = Octokit.issues_comments("pengwynn/octokit")
      comments.must_be_kind_of Array
      assert_requested :get, github_url('/repos/pengwynn/octokit/issues/comments')
    end
  end # .repository_issues_comments

  describe ".issue_comments" do
    it "returns comments for an issue" do
      comments = Octokit.issue_comments("pengwynn/octokit", 25)
      comments.must_be_kind_of Array
      assert_requested :get, github_url('/repos/pengwynn/octokit/issues/25/comments')
    end
  end # .issue_comments

  describe ".issue_comment" do
    it "returns a single comment for an issue" do
      comment = Octokit.issue_comment("pengwynn/octokit", 1194690)
      comment.rels[:self].href.must_equal "https://api.github.com/repos/pengwynn/octokit/issues/comments/1194690"
      assert_requested :get, github_url('/repos/pengwynn/octokit/issues/comments/1194690')
    end
  end # .issue_comment

  describe ".add_comment" do
    it "adds a comment" do
      client = basic_auth_client
      comment = client.add_comment("pengwynn/api-sandbox", 22, "A test comment")
      comment.user.login.must_equal test_github_login
      assert_requested :post, basic_github_url("/repos/pengwynn/api-sandbox/issues/22/comments")
    end
  end # .add_comment

  describe ".update_comment" do
    it "updates an existing comment" do
      client = basic_auth_client
      comment = client.add_comment("pengwynn/api-sandbox", 22, "Another test comment")
      client.update_comment("pengwynn/api-sandbox", comment.id, "A test comment update")
      assert_requested :patch, basic_github_url("/repos/pengwynn/api-sandbox/issues/comments/#{comment.id}")
    end
  end # .update_comment

  describe ".delete_comment" do
    it "deletes an existing comment" do
      client = basic_auth_client
      comment = client.add_comment("pengwynn/api-sandbox", 22, "Another test comment")
      client.delete_comment("pengwynn/api-sandbox", comment.id)
      assert_requested :delete, basic_github_url("/repos/pengwynn/api-sandbox/issues/comments/#{comment.id}")
    end # .delete_comment
  end

end
