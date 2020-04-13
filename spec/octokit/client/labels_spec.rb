require 'helper'

describe Octokit::Client::Labels do

  before do
    Octokit.reset!
    @client = oauth_client
  end

  describe ".issues_labels", :vcr do
    it "returns labels" do
      labels = @client.issues_labels("octokit/octokit.rb")
      expect(labels).to be_kind_of Array
      assert_requested :get, github_url("/repos/octokit/octokit.rb/labels")
    end
  end # .issues_labels

  describe ".issue_label", :vcr do
    it "returns a single label" do
      label = @client.issue_label("octokit/octokit.rb", "V3 Addition")
      expect(label.name).to eq("v3 addition")
      assert_requested :get, github_url("/repos/octokit/octokit.rb/labels/V3%20Addition")
    end
  end # .issue_label

  describe ".create_issue_label", :vcr do
    it "adds a label with a color" do
      @client.delete_issue_label(@test_repo, 'test-label', {:color => 'ededed'})
      label = @client.create_issue_label(@test_repo, "test-label", 'ededed')
      expect(label.color).to eq("ededed")
      assert_requested :post, github_url("/repos/#{@test_repo}/labels")
    end
  end # .create_issue_label

  context "with label" do
    before do
      @client.delete_issue_label(@test_repo, 'test-label', {:color => 'ededed'})
      @label = @client.create_issue_label(@test_repo, "test-label", 'ededed')
    end

    describe ".update_issue_label", :vcr do
      it "updates a label with a new color" do
        @client.update_issue_label(@test_repo, @label.name, {:color => 'ffdd33'})
        assert_requested :patch, github_url("/repos/#{@test_repo}/labels/#{@label.name}")
      end
    end # .update_issue_label
  end # with label

  describe ".delete_issue_label", :vcr do
    it "deletes a label from the repository" do
      label = @client.create_issue_label(@test_repo, "add label with space", 'ededed')
      @client.delete_issue_label(@test_repo, label.name, {:color => 'ededed'})
      assert_requested :delete, github_url("/repos/#{@test_repo}/labels/add%20label%20with%20space")
    end
  end # .delete_issue_label

  describe ".lables_for_milestone", :vcr do
    it "returns all labels for a repository" do
      labels = @client.milestone_labels('octokit/octokit.rb', 2)
      expect(labels).to be_kind_of Array
      assert_requested :get, github_url("/repos/octokit/octokit.rb/milestones/2/labels")
    end
  end # .labels_for_milestone

  context "with issue", :vcr do
    before(:each) do
      @issue = @client.create_issue(@test_repo, "Migrate issues to v3", :body => "Move all Issues calls to v3 of the API")
    end

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

      describe ".replace_issue_labels" do
        it "replaces all labels for an issue" do
          @client.replace_all_labels(@test_repo, @issue.number, ['random'])
          assert_requested :put, github_url("/repos/#{@test_repo}/issues/#{@issue.number}/labels")

          labels = @client.issue_labels(@test_repo, @issue.number)
          expect(labels.map(&:name)).to eq(['random'])
        end
      end # .replace_issue_labels
    end # with labels
  end # with issue
end
