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

        describe ".issue_comment_reactions" do
          it "returns an Array of reactions" do
            reactions = @client.issue_comment_reactions(@test_repo, @issue_comment.id, accept: reactions_preview_header)
            expect(reactions).to be_kind_of Array
            assert_requested :get, github_url("/repos/#{@test_repo}/issues/comments/#{@issue_comment.id}/reactions")
          end
        end # .issue_commit_comment_reactions

        describe ".create_issue_comment_reaction" do
          it "creates a reaction" do
            reaction = @client.create_issue_comment_reaction(@test_repo, @issue_comment.id, "+1", accept: reactions_preview_header)
            expect(reaction.content).to eql("+1")
            assert_requested :post, github_url("/repos/#{@test_repo}/issues/comments/#{@issue_comment.id}/reactions")
          end
        end # .create_issue_comment_reaction

        context "with issue comment reaction", :vcr do
          before do
            @reaction = @client.create_issue_comment_reaction(@test_repo, @issue_comment.id, "+1", accept: reactions_preview_header)
          end

          describe ".delete_issue_comment_reaction" do
            it "deletes the issue comment reaction" do
              @client.delete_issue_comment_reaction(@test_repo, @issue_comment.id, @reaction.id, accept: reactions_preview_header)
              assert_requested :delete, github_url("/repos/#{@test_repo}/issues/comments/#{@issue_comment.id}/reactions/#{@reaction.id}")
            end
          end # .delete_issue_comment_reaction
        end # with issue comment reaction
      end # with issue comment

      context "with issue reaction", :vcr do
        before do
          @reaction = @client.create_issue_reaction(@test_repo, @issue.number, "+1", accept: reactions_preview_header)
        end

        describe ".delete_issue_reaction" do
          it "deletes the issue reaction" do
            @client.delete_issue_reaction(@test_repo, @issue.id, @reaction.id, accept: reactions_preview_header)
            assert_requested :delete, github_url("/repos/#{@test_repo}/issues/#{@issue.id}/reactions/#{@reaction.id}")
          end
        end # .delete_issue_reaction
      end # with issue reaction

      describe ".timeline_events", :vcr do
        it "returns an issue timeline" do
          timeline = @client.timeline_events(@test_repo, @issue.number, accept: events_preview_header)
          expect(timeline).to be_kind_of Array
          assert_requested :get, github_url("/repos/#{@test_repo}/issues/#{@issue.number}/timeline")
        end
      end # .issue_timeline

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

      describe ".issues_comments", :vcr do
        it "returns comments for all issues in a repository" do
          comments = @client.issues_comments("octokit/octokit.rb")
          expect(comments).to be_kind_of Array
          assert_requested :get, github_url('/repos/octokit/octokit.rb/issues/comments')
        end
      end # .issues_comments

      describe ".issue_comments", :vcr do
        it "returns comments for an issue" do
          comments = @client.issue_comments("octokit/octokit.rb", 25)
          expect(comments).to be_kind_of Array
          assert_requested :get, github_url('/repos/octokit/octokit.rb/issues/25/comments')
        end
      end # .issue_comments

      describe ".issue_comment", :vcr do
        it "returns a single comment for an issue" do
          comment = @client.issue_comment("octokit/octokit.rb", 1194690)
          expect(comment.rels[:self].href).to eq("https://api.github.com/repos/octokit/octokit.rb/issues/comments/1194690")
          assert_requested :get, github_url('/repos/octokit/octokit.rb/issues/comments/1194690')
        end
      end # .issue_comment

      describe ".add_issue_assignees", :vcr do
        it "adds assignees" do
          issue = @client.add_issue_assignees(@test_repo, @issue.number, :assignees => [@test_login])
          expect(issue.assignees.count).not_to be_zero
          assert_requested :post, github_url("repos/#{@test_repo}/issues/#{@issue.number}/assignees")
        end
      end # .add_issue_assignees

      describe ".issue_reactions" do
        it "returns an Array of reactions" do
          reactions = @client.issue_reactions(@test_repo, @issue.number, accept: reactions_preview_header)
          expect(reactions).to be_kind_of Array
          assert_requested :get, github_url("/repos/#{@test_repo}/issues/#{@issue.number}/reactions")
        end
      end # .issue_reactions

      describe ".create_issue_reaction" do
        it "creates a reaction" do
          reaction = @client.create_issue_reaction(@test_repo, @issue.number, "+1", accept: reactions_preview_header)
          expect(reaction.content).to eql("+1")
          assert_requested :post, github_url("/repos/#{@test_repo}/issues/#{@issue.number}/reactions")
        end
      end # .create_issue_reaction

      context "with reaction" do
        before do
          @reaction = @client.create_issue_reaction(@test_repo, @issue.number, "+1", accept: reactions_preview_header)
        end

        describe ".delete_reaction" do
          it "deletes the reaction" do
            @client.delete_reaction_legacy(@reaction.id, accept: reactions_preview_header)
            assert_requested :delete, github_url("/reactions/#{@reaction.id}")
          end
        end # .delete_reaction
      end # with reaction

      describe ".add_issue_labels" do
        it "adds labels to a given issue" do
          @client.add_issue_labels(@test_repo, @issue.number, ['bug'])
          assert_requested :post, github_url("/repos/#{@test_repo}/issues/#{@issue.number}/labels")
        end
      end # .add_issue_labels

      context "with labels", :vcr do
        before do
          @client.add_issue_labels(@test_repo, @issue.number, ['bug', 'feature'])
        end

        describe ".issue_labels" do
          it "returns all labels for a given issue" do
            labels = @client.issue_labels(@test_repo, @issue.number)
            expect(labels).to be_kind_of Array
            assert_requested :get, github_url("/repos/#{@test_repo}/issues/#{@issue.number}/labels")
          end
        end # .issue_labels

        describe ".remove_issue_label" do
          it "removes a label from the specified issue" do
            @client.remove_issue_label(@test_repo, @issue.number, 'bug')
            assert_requested :delete, github_url("/repos/#{@test_repo}/issues/#{@issue.number}/labels/bug")

            labels = @client.issue_labels(@test_repo, @issue.number)
            expect(labels.map(&:name)).to eq(['feature'])
          end
        end # .remove_issue_label

        describe ".remove_issue_labels" do
          it "removes all labels from the specified issue" do
            @client.remove_all_labels(@test_repo, @issue.number)
            assert_requested :delete, github_url("/repos/#{@test_repo}/issues/#{@issue.number}/labels")

            labels = @client.issue_labels(@test_repo, @issue.number)
            expect(labels).to be_empty
          end
        end # .remove_labels

        describe ".set_issue_labels" do
          it "replaces all labels for an issue" do
            @client.set_issue_labels(@test_repo, @issue.number, ['random'])
            assert_requested :put, github_url("/repos/#{@test_repo}/issues/#{@issue.number}/labels")

            labels = @client.issue_labels(@test_repo, @issue.number)
            expect(labels.map(&:name)).to eq(['random'])
          end
        end # .set_issue_labels
      end # with labels

      describe ".issues_events" do
        it "lists issue events for a repository" do
          issue_events = @client.issues_events("octokit/octokit.rb")
          expect(issue_events).to be_kind_of Array
          assert_requested :get, github_url("/repos/octokit/octokit.rb/issues/events")
        end
      end # .issues_events

      describe ".issue_events" do
        it "lists issue events for a repository" do
          issue_events = @client.issue_events("octokit/octokit.rb", 4)
          expect(issue_events).to be_kind_of Array
          assert_requested :get, github_url("/repos/octokit/octokit.rb/issues/4/events")
        end
      end # .issue_events

      describe ".issue_event" do
        it "lists a issue event for a repository" do
          # TODO: Remove and use hypermedia
          @client.issue_event("octokit/octokit.rb", 37786228)
          assert_requested :get, github_url("/repos/octokit/octokit.rb/issues/events/37786228")
        end
      end # .issue_event
    end # with issue
  end # with repository

  private

  def reactions_preview_header
    Octokit::Preview::PREVIEW_TYPES[:reactions]
  end

  def events_preview_header
    Octokit::Preview::PREVIEW_TYPES[:timeline_events]
  end
end
