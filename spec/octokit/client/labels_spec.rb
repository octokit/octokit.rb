require 'helper'

describe Octokit::Client::Labels do

  before do
    Octokit.reset!
    @client = oauth_client
  end

  describe ".repository_labels", :vcr do
    it "returns labels" do
      labels = @client.repository_labels("octokit/octokit.rb")
      expect(labels).to be_kind_of Array
      assert_requested :get, github_url("/repos/octokit/octokit.rb/labels")
    end
  end # .repository_labels

  describe ".label", :vcr do
    it "returns a single label" do
      label = @client.label("octokit/octokit.rb", "V3 Addition")
      expect(label.name).to eq("v3 addition")
      assert_requested :get, github_url("/repos/octokit/octokit.rb/labels/V3%20Addition")
    end
  end # .label

  describe ".create_label", :vcr do
    it "adds a label with a color" do
      @client.delete_label(@test_repo, 'test-label', {:color => 'ededed'})
      label = @client.create_label(@test_repo, "test-label", 'ededed')
      expect(label.color).to eq("ededed")
      assert_requested :post, github_url("/repos/#{@test_repo}/labels")
    end
  end # .create_label

  context "with label" do
    before do
      @client.delete_label(@test_repo, 'test-label', {:color => 'ededed'})
      @label = @client.create_label(@test_repo, "test-label", 'ededed')
    end

    describe ".update_label", :vcr do
      it "updates a label with a new color" do
        @client.update_label(@test_repo, @label.name, {:color => 'ffdd33'})
        assert_requested :patch, github_url("/repos/#{@test_repo}/labels/#{@label.name}")
      end
    end # .update_label
  end # with label

  describe ".delete_label", :vcr do
    it "deletes a label from the repository" do
      label = @client.create_label(@test_repo, "add label with space", 'ededed')
      @client.delete_label(@test_repo, label.name, {:color => 'ededed'})
      assert_requested :delete, github_url("/repos/#{@test_repo}/labels/add%20label%20with%20space")
    end
  end # .delete_label
end
