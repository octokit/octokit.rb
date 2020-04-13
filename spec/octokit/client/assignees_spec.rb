require 'helper'

describe Octokit::Client::Assignees do

  before do
    Octokit.reset!
    @client = oauth_client
    @test_login = test_github_login
  end

  after do
    Octokit.reset!
  end

  context "with issue", :vcr do
    before(:each) do
      @issue = @client.create_issue(@test_repo, "Migrate issues to v3", :body => "Move all Issues calls to v3 of the API")
    end

    describe ".add_issue_assignees", :vcr do
      it "adds assignees" do
        issue = @client.add_issue_assignees(@test_repo, @issue.number, :assignees => [@test_login])
        expect(issue.assignees.count).not_to be_zero
        assert_requested :post, github_url("repos/#{@test_repo}/issues/#{@issue.number}/assignees")
      end
    end # .add_issue_assignees

    context "with assignees" do
      before(:each) do
        issue = @client.add_issue_assignees(@test_repo, @issue.number, :assignees => [@test_login])
        expect(issue.assignees.count).not_to be_zero
      end

      describe ".remove_issue_assignees", :vcr do
        it "removes assignees" do
          issue = @client.remove_issue_assignees(
            @test_repo, @issue.number, :assignees => [@test_login]
          )
          expect(issue.assignees.count).to be_zero
          assert_requested :post, github_url("repos/#{@test_repo}/issues/#{@issue.number}/assignees")
        end
      end # .remove_issue_assignees
    end # with assignees
  end # with issue
end
