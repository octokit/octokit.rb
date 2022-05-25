require 'helper'

describe Octokit::Client::IssuesLabels do

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
end
