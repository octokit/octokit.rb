require 'helper'

describe Octokit::Client::Issues do

  before do
    Octokit.reset!
    @client = oauth_client
  end

  after do
    Octokit.reset!
  end

  describe ".list_issues", :vcr do
    it "returns issues for a repository" do
      issues = @client.issues("sferik/rails_admin")
      expect(issues).to be_kind_of Array
      assert_requested :get, github_url("/repos/sferik/rails_admin/issues")
    end
    it "returns dashboard issues for the authenticated user" do
      issues = @client.issues
      expect(issues).to be_kind_of Array
      assert_requested :get, github_url("/issues")
    end

    context "when use manual pagination" do
      it "returns issues for a repository" do
        data = []
        first_page_data = @client.issues("sferik/rails_admin") do |_, next_page|
          data += next_page.data
        end
        data = first_page_data + data
        expect(data).to be_kind_of Array
      end
    end
  end # .list_issues

  describe ".user_issues", :vcr do
    it "returns issues for the authenticated user for owned and member repos" do
      issues = @client.user_issues
      expect(issues).to be_kind_of Array
      assert_requested :get, github_url("/user/issues")
    end

    context "when use manual pagination" do
      it "returns issues for the authenticated user for owned and member repos" do
        data = []
        first_page_data = @client.user_issues do |_, next_page|
          data += next_page.data
        end
        data = first_page_data + data
        expect(data).to be_kind_of Array
      end
    end
  end # .user_issues

  describe ".org_issues", :vcr do
    it "returns issues for the organization for the authenticated user" do
      issues = @client.org_issues(test_github_org)
      expect(issues).to be_kind_of Array
      assert_requested :get, github_url("/orgs/#{test_github_org}/issues")
    end

    context "when use manual pagination" do
      it "returns issues for the organization for the authenticated user" do
        data = []
        first_page_data = @client.org_issues(test_github_org) do |_, next_page|
          data += next_page.data
        end
        data = first_page_data + data
        expect(data).to be_kind_of Array
      end
    end
  end # .org_issues

  context "with repository" do
    before(:each) do
      @repo = @client.create_repository("#{test_github_repository}_#{Time.now.to_f}")
    end

    after(:each) do
      begin
        @client.delete_repository(@repo.full_name)
      rescue Octokit::NotFound
      end
    end

    describe ".create_issue", :vcr do
      it "creates an issue" do
        issue = @client.create_issue \
          @repo.full_name,
          "Migrate issues to v3",
          "Move all Issues calls to v3 of the API"
        expect(issue.title).to match(/Migrate/)
        assert_requested :post, github_url("/repos/#{@repo.full_name}/issues")
      end

      it "creates an issue with delimited labels" do
        issue = @client.create_issue \
          @repo.full_name,
          "New issue with delimited labels",
          "Testing",
          :labels => "bug, feature"
        expect(issue.title).to match(/delimited/)
        expect(issue.labels.map(&:name)).to include("feature")
        assert_requested :post, github_url("/repos/#{@repo.full_name}/issues")
      end

      it "creates an issue with labels array" do
        issue = @client.create_issue \
          @repo.full_name,
          "New issue with labels array",
          "Testing",
          :labels => %w(bug feature)
        expect(issue.title).to match(/array/)
        expect(issue.labels.map(&:name)).to include("feature")
        assert_requested :post, github_url("/repos/#{@repo.full_name}/issues")
      end

      it "creates an issue without body argument" do
        issue = @client.create_issue(@repo.full_name, "New issue without body argument")
        expect(issue.body).to be_nil
        assert_requested :post, github_url("/repos/#{@repo.full_name}/issues")
      end
    end # .create_issue

    context "with issue" do
      before(:each) do
        @issue = @client.create_issue(@repo.full_name, "Migrate issues to v3", "Move all Issues calls to v3 of the API")
      end

      describe ".issue", :vcr do
        it "returns an issue" do
          issue = @client.issue(@repo.full_name, @issue.number)
          assert_requested :get, github_url("/repos/#{@repo.full_name}/issues/#{@issue.number}")
          expect(issue.number).to eq(@issue.number)
        end
        it "returns a full issue" do
          issue = @client.issue(@repo.full_name, @issue.number, :accept => 'application/vnd.github.full+json')
          assert_requested :get, github_url("/repos/#{@repo.full_name}/issues/#{@issue.number}")
          expect(issue.body_html).to include('<p>Move all')
          expect(issue.body_text).to include('Move all')
        end
      end # .issue

      describe ".close_issue", :vcr do
        it "closes an issue" do
          issue = @client.close_issue(@repo.full_name, @issue.number)
          expect(issue.state).to eq "closed"
          expect(issue.number).to eq(@issue.number)
          assert_requested :patch, github_url("/repos/#{@repo.full_name}/issues/#{@issue.number}")
        end
      end # .close_issue

      context "with closed issue" do
        before(:each) do
          @client.close_issue(@repo.full_name, @issue.number)
        end

        describe ".reopen_issue", :vcr do
          it "reopens an issue" do
            issue = @client.reopen_issue(@repo.full_name, @issue.number)
            expect(issue.state).to eq "open"
            expect(issue.number).to eq(@issue.number)
            assert_requested :patch, github_url("/repos/#{@repo.full_name}/issues/#{@issue.number}"), :times => 2
          end
        end # .reopen_issue
      end # with closed issue

      describe ".lock_issue", :vcr do
        it "locks an issue" do
          @client.lock_issue(@repo.full_name, @issue.number)
          assert_requested :put, github_url("/repos/#{@repo.full_name}/issues/#{@issue.number}/lock")
        end
      end # .lock_issue

      context "with locked issue" do
        before(:each) do
          @client.lock_issue(@repo.full_name, @issue.number)
        end

        describe ".unlock_issue", :vcr do
          it "unlocks an issue" do
            @client.unlock_issue(@repo.full_name, @issue.number)
            assert_requested :delete, github_url("/repos/#{@repo.full_name}/issues/#{@issue.number}/lock")
          end
        end # .unlock_issue
      end # with locked issue

      describe ".update_issue", :vcr do
        it "updates an issue" do
          issue = @client.update_issue(@repo.full_name, @issue.number, "Use all the v3 api!", "")
          expect(issue.number).to eq(@issue.number)
          assert_requested :patch, github_url("/repos/#{@repo.full_name}/issues/#{@issue.number}")
        end

        it "updates an issue without positional args" do
          issue = @client.update_issue(@repo.full_name, @issue.number, :title => "Use all the v3 api!", :body => "")
          expect(issue.number).to eq(@issue.number)
          assert_requested :patch, github_url("/repos/#{@repo.full_name}/issues/#{@issue.number}")
        end
      end # .update_issue

      describe ".add_comment", :vcr do
        it "adds a comment" do
          comment = @client.add_comment(@repo.full_name, @issue.number, "A test comment")
          expect(comment.user.login).to eq(test_github_login)
          assert_requested :post, github_url("/repos/#{@repo.full_name}/issues/#{@issue.number}/comments")
        end
      end # .add_comment

      context "with issue comment" do
        before(:each) do
          @issue_comment = @client.add_comment(@repo.full_name, @issue.number, "Another test comment")
        end

        describe ".update_comment", :vcr do
          it "updates an existing comment" do
            @client.update_comment(@repo.full_name, @issue_comment.id, "A test comment update")
            assert_requested :patch, github_url("/repos/#{@repo.full_name}/issues/comments/#{@issue_comment.id}")
          end
        end # .update_comment

        describe ".delete_comment", :vcr do
          it "deletes an existing comment" do
            @client.delete_comment(@repo.full_name, @issue_comment.id)
            assert_requested :delete, github_url("/repos/#{@repo.full_name}/issues/comments/#{@issue_comment.id}")
          end
        end # .delete_comment
      end # with issue comment

      describe ".issue_timeline", :vcr do
        it "returns an issue timeline" do
          timeline = @client.issue_timeline(@repo.full_name, @issue.number)
          expect(timeline).to be_kind_of Array
          assert_requested :get, github_url("/repos/#{@repo.full_name}/issues/#{@issue.number}/timeline")
        end

        context "when use manual pagination" do
          it "returns an issue timeline" do
            data = []
            first_page_data = @client.issue_timeline(@repo.full_name, @issue.number) do |_, next_page|
              data += next_page.data
            end
            data = first_page_data + data
            expect(data).to be_kind_of Array
          end
        end
      end # .issue_timeline
    end # with issue
  end # with repo

  describe ".repository_issues_comments", :vcr do
    it "returns comments for all issues in a repository" do
      comments = @client.issues_comments("octokit/octokit.rb")
      expect(comments).to be_kind_of Array
      assert_requested :get, github_url('/repos/octokit/octokit.rb/issues/comments')
    end

    context "when use manual pagination" do
      it "returns comments for all issues in a repository" do
        data = []
        first_page_data = @client.issues_comments("octokit/octokit.rb") do |_, next_page|
          data += next_page.data
        end
        data = first_page_data + data
        expect(data).to be_kind_of Array
      end
    end
  end # .repository_issues_comments

  describe ".issue_comments", :vcr do
    it "returns comments for an issue" do
      comments = @client.issue_comments("octokit/octokit.rb", 25)
      expect(comments).to be_kind_of Array
      assert_requested :get, github_url('/repos/octokit/octokit.rb/issues/25/comments')
    end

    context "when use manual pagination" do
      it "returns comments for an issue" do
        data = []
        first_page_data = @client.issue_comments("octokit/octokit.rb", 25) do |_, next_page|
          data += next_page.data
        end
        data = first_page_data + data
        expect(data).to be_kind_of Array
      end
    end
  end # .issue_comments

  describe ".issue_comment", :vcr do
    it "returns a single comment for an issue" do
      comment = @client.issue_comment("octokit/octokit.rb", 1194690)
      expect(comment.rels[:self].href).to eq("https://api.github.com/repos/octokit/octokit.rb/issues/comments/1194690")
      assert_requested :get, github_url('/repos/octokit/octokit.rb/issues/comments/1194690')
    end
  end # .issue_comment
end
