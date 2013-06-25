require 'helper'

describe Octokit::Client::Milestones do

  before do
    Octokit.reset!
    @client = oauth_client
  end

  describe ".list_milestones", :vcr do
    it "lists milestones belonging to repository" do
      milestones = @client.list_milestones("api-playground/api-sandbox")
      expect(milestones).to be_kind_of Array
      assert_requested :get, github_url("/repos/api-playground/api-sandbox/milestones")
    end
  end # .list_milestones

  context "methods that need a milestone" do

    before(:each) do
      name = "Test Milestone #{Time.now.to_i}"
      @milestone = @client.create_milestone("api-playground/api-sandbox", name)
    end

    after(:each) do
      @client.delete_milestone("api-playground/api-sandbox", @milestone.number)
    end

    describe ".milestone", :vcr do
      it "gets a single milestone belonging to repository" do
        milestone = @client.milestone("api-playground/api-sandbox", @milestone.number)
        assert_requested :get, github_url("/repos/api-playground/api-sandbox/milestones/#{@milestone.number}")
      end
    end # .milestone

    describe ".create_milestone", :vcr do
      it "creates a milestone" do
        expect(@milestone.title).to_not be_nil
        assert_requested :post, github_url("/repos/api-playground/api-sandbox/milestones")
      end
    end # .create_milestone

    describe ".update_milestone", :vcr do
      it "updates a milestone" do
        @client.update_milestone("api-playground/api-sandbox", @milestone.number, {:description => "Add support for API v3"})
        assert_requested :patch, github_url("/repos/api-playground/api-sandbox/milestones/#{@milestone.number}")
      end
    end # .update_milestone

    describe ".delete_milestone", :vcr do
      it "deletes a milestone from a repository" do
        @client.delete_milestone("api-playground/api-sandbox", @milestone.number)
        assert_requested :delete, github_url("/repos/api-playground/api-sandbox/milestones/#{@milestone.number}")
      end
    end # .delete_milestone

  end

end
