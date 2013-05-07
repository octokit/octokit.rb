# -*- encoding: utf-8 -*-
require 'helper'

describe Octokit::Client::Stats do

  before do
    @client = Octokit::Client.new(:login => 'sferik')
  end

  describe ".contributor_stats" do
    it "returns contributors and their contribution stats" do
      stub_get("/repos/pengwynn/octokit/stats/contributors").
        to_return(json_response("contributor_stats.json"))
      stats = @client.contributors_stats("pengwynn/octokit")
      expect(stats.first.author.login).to eq("pengwynn")
    end
  end

  describe ".commit_activity_stats" do
    it "returns the commit activity stats" do
      stub_get("/repos/pengwynn/octokit/stats/commit_activity").
        to_return(json_response("commit_activity_stats.json"))
      stats = @client.commit_activity_stats("pengwynn/octokit")
      expect(stats.first.week).to eq(1336867200)
    end
  end

  describe ".code_frequency_stats" do
    it "returns the code frequency stats" do
      stub_get("/repos/pengwynn/octokit/stats/code_frequency").
        to_return(json_response('code_frequency_stats.json'))
      stats = @client.code_frequency_stats('pengwynn/octokit')
      expect(stats.first.first).to eq(1260057600)
    end
  end

  describe ".participation_stats" do
    it "returns the owner and contributor participation stats" do
      stub_get("/repos/pengwynn/octokit/stats/participation").
        to_return(json_response('participation_stats.json'))
      stats = @client.participation_stats('pengwynn/octokit')
      expect(stats.owner.first).to eq(5)
    end
  end

  describe ".punch_card_stats" do
    it "returns commit count by hour punch card stats" do
      stub_get("/repos/pengwynn/octokit/stats/punch_card").
        to_return(json_response('punch_card_stats.json'))
      stats = @client.punch_card_stats('pengwynn/octokit')
      expect(stats.last.first).to eq(6)
    end
  end

end
