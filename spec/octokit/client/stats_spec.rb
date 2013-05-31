require 'helper'

describe Octokit::Client::Stats do

  before do
    Octokit.reset!
    VCR.insert_cassette 'stats'
    @client = Octokit::Client.new
  end

  after do
    Octokit.reset!
    VCR.eject_cassette
  end

  describe ".contributors_stats" do
    xit "returns contributors and their contribution stats" do
      stats = @client.contributors_stats("pengwynn/octokit")
      expect(stats).to be_kind_of Array
      expect(stats.first.author.login).to_not be_nil
      assert_requested :get, github_url("/repos/pengwynn/octokit/stats/contributors")
    end
  end # .contributors_stats

  describe ".commit_activity_stats" do
    xit "returns the commit activity stats" do
      stats = @client.commit_activity_stats("pengwynn/octokit")
      expect(stats).to be_kind_of Array
      expect(stats.first.week).to be_kind_of Fixnum
      assert_requested :get, github_url("/repos/pengwynn/octokit/stats/commit_activity")
    end
  end # .commit_activity_stats

  describe ".code_frequency_stats" do
    xit "returns the code frequency stats" do
      stats = @client.code_frequency_stats('pengwynn/octokit')
      expect(stats).to be_kind_of Array
      assert_requested :get, github_url("/repos/pengwynn/octokit/stats/code_frequency")
    end
  end # .code_frequency_stats

  describe ".participation_stats" do
    xit "returns the owner and contributor participation stats" do
      stats = @client.participation_stats('pengwynn/octokit')
      expect(stats.fields).to include :owner
      assert_requested :get, github_url("/repos/pengwynn/octokit/stats/participation")
    end
  end # .participation_stats

  describe ".punch_card_stats" do
    xit "returns commit count by hour punch card stats" do
      stats = @client.punch_card_stats('pengwynn/octokit')
      expect(stats).to be_kind_of Array
      assert_requested :get, github_url("/repos/pengwynn/octokit/stats/punch_card")
    end
  end # .punch_card_stats

end
