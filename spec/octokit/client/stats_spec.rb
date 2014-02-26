require 'helper'

describe Octokit::Client::Stats do

  before do
    Octokit.reset!
    @client = oauth_client
  end

  context "with cold graph cache" do

    before do
      VCR.turn_off!
      stub_request(:any, /api\.github\.com\/repos\/octokit/).
        to_return(:status => 202)
    end

    after do
      VCR.turn_on!
    end

    describe ".contributors_stats" do
      it "returns contributors and their contribution stats" do
        stats = @client.contributors_stats("octokit/octokit.rb")
        expect(stats).to be_nil
        assert_requested :get, github_url("/repos/octokit/octokit.rb/stats/contributors")
      end
    end # .contributors_stats

    describe ".commit_activity_stats" do
      it "returns the commit activity stats" do
        stats = @client.commit_activity_stats("octokit/octokit.rb")
        expect(stats).to be_nil
        assert_requested :get, github_url("/repos/octokit/octokit.rb/stats/commit_activity")
      end
    end # .commit_activity_stats

    describe ".code_frequency_stats" do
      it "returns the code frequency stats" do
        stats = @client.code_frequency_stats('octokit/octokit.rb')
        expect(stats).to be_nil
        assert_requested :get, github_url("/repos/octokit/octokit.rb/stats/code_frequency")
      end
    end # .code_frequency_stats

    describe ".participation_stats" do
      it "returns the owner and contributor participation stats" do
        stats = @client.participation_stats('octokit/octokit.rb')
        expect(stats).to be_nil
        assert_requested :get, github_url("/repos/octokit/octokit.rb/stats/participation")
      end
    end # .participation_stats

    describe ".punch_card_stats" do
      it "returns commit count by hour punch card stats" do
        stats = @client.punch_card_stats('octokit/octokit.rb')
        expect(stats).to be_nil
        assert_requested :get, github_url("/repos/octokit/octokit.rb/stats/punch_card")
      end
    end # .punch_card_stats
  end

  describe ".contributors_stats", :vcr do
    it "returns contributors and their contribution stats" do
      stats = @client.contributors_stats("pengwynn/pingwynn")
      expect(stats).to be_kind_of Array
      expect(stats.first.author.login).not_to be_nil
      assert_requested :get, github_url("/repos/pengwynn/pingwynn/stats/contributors")
    end
  end # .contributors_stats

  describe ".commit_activity_stats", :vcr do
    it "returns the commit activity stats" do
      stats = @client.commit_activity_stats("pengwynn/pingwynn")
      expect(stats).to be_kind_of Array
      expect(stats.first.week).to be_kind_of Fixnum
      assert_requested :get, github_url("/repos/pengwynn/pingwynn/stats/commit_activity")
    end
  end # .commit_activity_stats

  describe ".code_frequency_stats", :vcr do
    it "returns the code frequency stats" do
      stats = @client.code_frequency_stats("pengwynn/pingwynn")
      expect(stats).to be_kind_of Array
      assert_requested :get, github_url("/repos/pengwynn/pingwynn/stats/code_frequency")
    end
  end # .code_frequency_stats

  describe ".participation_stats", :vcr do
    it "returns the owner and contributor participation stats" do
      stats = @client.participation_stats("pengwynn/pingwynn")
      expect(stats.fields).to include(:owner)
      assert_requested :get, github_url("/repos/pengwynn/pingwynn/stats/participation")
    end
  end # .participation_stats

  describe ".punch_card_stats", :vcr do
    it "returns commit count by hour punch card stats" do
      stats = @client.punch_card_stats("pengwynn/pingwynn")
      expect(stats).to be_kind_of Array
      assert_requested :get, github_url("/repos/pengwynn/pingwynn/stats/punch_card")
    end
  end # .punch_card_stats

end
