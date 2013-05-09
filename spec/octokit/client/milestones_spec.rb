require 'helper'

describe Octokit::Client::Milestones do

  before do
    Octokit.reset!
    VCR.insert_cassette 'milestones'
    @client = basic_auth_client
  end

  after do
    Octokit.reset!
    VCR.eject_cassette
  end

  describe ".list_milestones" do
    it "lists milestones belonging to repository" do
      milestones = @client.list_milestones("pengwynn/api-sandbox")
      expect(milestones).to be_kind_of Array
      assert_requested :get, basic_github_url("/repos/pengwynn/api-sandbox/milestones")
    end
  end # .list_milestones

  describe ".milestone" do
    it "gets a single milestone belonging to repository" do
      milestone = @client.create_milestone("pengwynn/api-sandbox", "2.0.0")
      milestone = @client.milestone("pengwynn/api-sandbox", milestone.number)
      assert_requested :get, basic_github_url("/repos/pengwynn/api-sandbox/milestones/#{milestone.number}")
    end
  end # .milestone

  describe ".create_milestone" do
    it "creates a milestone" do
      milestone = @client.create_milestone("pengwynn/api-sandbox", "2.0.0")
      expect(milestone.title).to_not be_nil
      assert_requested :post, basic_github_url("/repos/pengwynn/api-sandbox/milestones")
    end
  end # .create_milestone

  describe ".update_milestone" do
    it "updates a milestone" do
      milestone = @client.create_milestone("pengwynn/api-sandbox", "2.0.0")
      @client.update_milestone("pengwynn/api-sandbox", milestone.number, {:description => "Add support for API v3"})
      assert_requested :patch, basic_github_url("/repos/pengwynn/api-sandbox/milestones/#{milestone.number}")
    end
  end # .update_milestone

  describe ".delete_milestone" do
    it "deletes a milestone from a repository" do
      milestone = @client.create_milestone("pengwynn/api-sandbox", "2.0.0")
      @client.delete_milestone("pengwynn/api-sandbox", milestone.number)
      assert_requested :delete, basic_github_url("/repos/pengwynn/api-sandbox/milestones/#{milestone.number}")
    end
  end # .delete_milestone

end
