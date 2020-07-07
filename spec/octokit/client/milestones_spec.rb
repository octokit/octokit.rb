require 'helper'

describe Octokit::Client::IssuesMilestones do

  before do
    Octokit.reset!
    @client = oauth_client
  end

  describe ".issue_milestones", :vcr do
    it "lists milestones belonging to repository" do
      milestones = @client.issue_milestones(@test_repo)
      expect(milestones).to be_kind_of Array
      assert_requested :get, github_url("/repos/#{@test_repo}/milestones")
    end

    it "lists milestones belonging to repository using id of repository" do
      milestones = @client.issue_milestones(@test_repo_id)
      expect(milestones).to be_kind_of Array
      assert_requested :get, github_url("/repositories/#{@test_repo_id}/milestones")
    end
  end # .issue_milestones

  context "with milestone" do
    before(:each) do
      name = "Test Milestone #{Time.now.to_i}"
      @milestone = @client.create_issue_milestone(@test_repo, name)
    end

    after(:each) do
      @client.delete_issue_milestone @test_repo, @milestone.number
    end

    describe ".issue_milestone", :vcr do
      it "gets a single milestone belonging to repository" do
        @client.issue_milestone @test_repo, @milestone.number
        assert_requested :get, github_url("/repos/#{@test_repo}/milestones/#{@milestone.number}")
      end
    end # .issue_milestone

    describe ".create_issue_milestone", :vcr do
      it "creates a milestone" do
        expect(@milestone.title).not_to be_nil
        assert_requested :post, github_url("/repos/#{@test_repo}/milestones")
      end
    end # .create_issue_milestone

    describe ".update_issue_milestone", :vcr do
      it "updates a milestone" do
        @client.update_issue_milestone(@test_repo, @milestone.number, {:description => "Add support for API v3"})
        assert_requested :patch, github_url("/repos/#{@test_repo}/milestones/#{@milestone.number}")
      end
    end # .update_issue_milestone

    describe ".delete_issue_milestone", :vcr do
      it "deletes a milestone from a repository" do
        @client.delete_issue_milestone(@test_repo, @milestone.number)
        assert_requested :delete, github_url("/repos/#{@test_repo}/milestones/#{@milestone.number}")
      end
    end # .delete_issue_milestone
  end # with milestone

  describe ".lables_for_milestone", :vcr do
    it "returns all labels for a repository" do
      labels = @client.milestone_labels('octokit/octokit.rb', 2)
      expect(labels).to be_kind_of Array
      assert_requested :get, github_url("/repos/octokit/octokit.rb/milestones/2/labels")
    end
  end # .labels_for_milestone
end
