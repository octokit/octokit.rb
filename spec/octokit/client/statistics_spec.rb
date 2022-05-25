require 'helper'

describe Octokit::Client::ReposStatistics do

  before do
    Octokit.reset!
    @client = oauth_client
  end

  context "with cold graph cache" do
    before do
      VCR.turn_off!
      stub_request(:any, /api\.github\.com\/repos\/octokit/).
        to_return(
          { :status => 202 }, # Cold request
        )
    end

    after do
      VCR.turn_on!
    end

    describe ".contributors_stats" do
      it "returns contributors and their contribution stats" do
        stats = @client.contributors_stats("octokit/octokit.rb")
        expect(stats).to be_empty
        assert_requested :get, github_url("/repos/octokit/octokit.rb/stats/contributors")
      end
    end # .contributors_stats

    describe ".commit_activity_stats" do
      it "returns the commit activity stats" do
        stats = @client.commit_activity_stats("octokit/octokit.rb")
        expect(stats).to be_empty
        assert_requested :get, github_url("/repos/octokit/octokit.rb/stats/commit_activity")
      end
    end # .commit_activity_stats

    describe ".code_frequency_stats" do
      it "returns the code frequency stats" do
        stats = @client.code_frequency_stats('octokit/octokit.rb')
        expect(stats).to be_empty
        assert_requested :get, github_url("/repos/octokit/octokit.rb/stats/code_frequency")
      end
    end # .code_frequency_stats

    describe ".participation_stats" do
      it "returns the owner and contributor participation stats" do
        stats = @client.participation_stats('octokit/octokit.rb')
        expect(stats).to be_empty
        assert_requested :get, github_url("/repos/octokit/octokit.rb/stats/participation")
      end
    end # .participation_stats

    describe ".punch_card_stats" do
      it "returns commit count by hour punch card stats" do
        stats = @client.punch_card_stats('octokit/octokit.rb')
        expect(stats).to be_empty
        assert_requested :get, github_url("/repos/octokit/octokit.rb/stats/punch_card")
      end
    end # .punch_card_stats
  end # with cold graph cache

  describe ".contributors_stats", :vcr do
    it "returns contributors and their contribution stats" do
      stats = @client.contributors_stats(@test_repo)
      expect(stats).to be_kind_of Array
      expect(stats.first.author.login).not_to be_empty
      assert_requested :get, github_url("/repos/#{@test_repo}/stats/contributors")
    end
  end # .contributors_stats

  describe ".commit_activity_stats", :vcr do
    it "returns the commit activity stats" do
      stats = @client.commit_activity_stats(@test_repo)
      expect(stats).to be_kind_of Array
      expect(stats.first.week).to be_kind_of Integer
      assert_requested :get, github_url("/repos/#{@test_repo}/stats/commit_activity")
    end
  end # .commit_activity_stats

  describe ".code_frequency_stats", :vcr do
    it "returns the code frequency stats" do
      stats = @client.code_frequency_stats(@test_repo)
      expect(stats).to be_kind_of Array
      assert_requested :get, github_url("/repos/#{@test_repo}/stats/code_frequency")
    end
  end # .code_frequency_stats

  describe ".participation_stats", :vcr do
    it "returns the owner and contributor participation stats" do
      stats = @client.participation_stats(@test_repo)
      expect(stats.fields).to include(:owner)
      assert_requested :get, github_url("/repos/#{@test_repo}/stats/participation")
    end
  end # .participation_stats

  describe ".punch_card_stats", :vcr do
    it "returns commit count by hour punch card stats" do
      stats = @client.punch_card_stats(@test_repo)
      expect(stats).to be_kind_of Array
      assert_requested :get, github_url("/repos/#{@test_repo}/stats/punch_card")
    end
  end # .punch_card_stats
end
