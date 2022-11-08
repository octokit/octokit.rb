# frozen_string_literal: true

require 'helper'

describe Octokit::Client::Stats do
  before do
    Octokit.reset!
    @client = oauth_client
  end

  context 'with empty repo' do
    before do
      VCR.turn_off!
      stub_request(:any, %r{api\.github\.com/repos/octokit})
        .to_return(
          { status: 202 }, # Cold request
          { status: 202 }, # Cold request
          { status: 204, body: [].to_json }, # Warm request
          { status: 204, body: [].to_json } # Warm request
        )
    end

    after do
      VCR.turn_on!
    end

    describe '.contributors_stats' do
      it 'returns nil when statistics are not ready' do
        stats = @client.contributors_stats('octokit/octokit.rb')
        expect(stats).to be_nil
        assert_requested :get, github_url('/repos/octokit/octokit.rb/stats/contributors')
      end

      it 'returns [] when GitHub returns 204' do
        stats = @client.contributors_stats('octokit/octokit.rb', retry_timeout: 3)
        expect(stats).to eq([])
      end

      it "doesn't retry when GitHub returns 204" do
        @client.contributors_stats('octokit/octokit.rb', retry_timeout: 4)
        assert_requested :get, github_url('/repos/octokit/octokit.rb/stats/contributors'), times: 3
      end

      it 'returns nil on timeout' do
        stats = @client.contributors_stats('octokit/octokit.rb', retry_timeout: 1, retry_wait: 1)
        expect(stats).to be_nil
        assert_requested :get, github_url('/repos/octokit/octokit.rb/stats/contributors'), times: 2
      end
    end
  end

  context 'with cold graph cache' do
    before do
      VCR.turn_off!
      stub_request(:any, %r{api\.github\.com/repos/octokit})
        .to_return(
          { status: 202 }, # Cold request
          { status: 202 }, # Cold request
          { status: 200, body: [].to_json } # Warm request
        )
    end

    after do
      VCR.turn_on!
    end

    describe '.contributors_stats' do
      it 'returns contributors and their contribution stats' do
        stats = @client.contributors_stats('octokit/octokit.rb')
        expect(stats).to be_nil
        assert_requested :get, github_url('/repos/octokit/octokit.rb/stats/contributors')
      end

      it 'retries' do
        stats = @client.contributors_stats('octokit/octokit.rb', retry_timeout: 3)
        expect(stats).to_not be_nil

        assert_requested :get, github_url('/repos/octokit/octokit.rb/stats/contributors'), times: 3
      end

      it 'returns nil on timeout' do
        stats = @client.contributors_stats('octokit/octokit.rb', retry_timeout: 1, retry_wait: 1)
        expect(stats).to be_nil
        assert_requested :get, github_url('/repos/octokit/octokit.rb/stats/contributors'), times: 2
      end
    end # .contributors_stats

    describe '.commit_activity_stats' do
      it 'returns the commit activity stats' do
        stats = @client.commit_activity_stats('octokit/octokit.rb')
        expect(stats).to be_nil
        assert_requested :get, github_url('/repos/octokit/octokit.rb/stats/commit_activity')
      end

      it 'retries' do
        stats = @client.commit_activity_stats('octokit/octokit.rb', retry_timeout: 3)
        expect(stats).to_not be_nil

        assert_requested :get, github_url('/repos/octokit/octokit.rb/stats/commit_activity'), times: 3
      end
    end # .commit_activity_stats

    describe '.code_frequency_stats' do
      it 'returns the code frequency stats' do
        stats = @client.code_frequency_stats('octokit/octokit.rb')
        expect(stats).to be_nil
        assert_requested :get, github_url('/repos/octokit/octokit.rb/stats/code_frequency')
      end

      it 'retries' do
        stats = @client.code_frequency_stats('octokit/octokit.rb', retry_timeout: 3)
        expect(stats).to_not be_nil

        assert_requested :get, github_url('/repos/octokit/octokit.rb/stats/code_frequency'), times: 3
      end
    end # .code_frequency_stats

    describe '.participation_stats' do
      it 'returns the owner and contributor participation stats' do
        stats = @client.participation_stats('octokit/octokit.rb')
        expect(stats).to be_nil
        assert_requested :get, github_url('/repos/octokit/octokit.rb/stats/participation')
      end

      it 'retries' do
        stats = @client.participation_stats('octokit/octokit.rb', retry_timeout: 3)
        expect(stats).to_not be_nil

        assert_requested :get, github_url('/repos/octokit/octokit.rb/stats/participation'), times: 3
      end
    end # .participation_stats

    describe '.punch_card_stats' do
      it 'returns commit count by hour punch card stats' do
        stats = @client.punch_card_stats('octokit/octokit.rb')
        expect(stats).to be_nil
        assert_requested :get, github_url('/repos/octokit/octokit.rb/stats/punch_card')
      end

      it 'retries' do
        stats = @client.punch_card_stats('octokit/octokit.rb', retry_timeout: 3)
        expect(stats).to_not be_nil

        assert_requested :get, github_url('/repos/octokit/octokit.rb/stats/punch_card'), times: 3
      end
    end # .punch_card_stats
  end

  describe '.contributors_stats', :vcr do
    it 'returns contributors and their contribution stats' do
      stats = @client.contributors_stats('pengwynn/pingwynn')
      expect(stats).to be_kind_of Array
      expect(stats.first.author.login).not_to be_nil
      assert_requested :get, github_url('/repos/pengwynn/pingwynn/stats/contributors')
    end
  end # .contributors_stats

  describe '.commit_activity_stats', :vcr do
    it 'returns the commit activity stats' do
      stats = @client.commit_activity_stats('pengwynn/pingwynn')
      expect(stats).to be_kind_of Array
      expect(stats.first.week).to be_kind_of Integer
      assert_requested :get, github_url('/repos/pengwynn/pingwynn/stats/commit_activity')
    end
  end # .commit_activity_stats

  describe '.code_frequency_stats', :vcr do
    it 'returns the code frequency stats' do
      stats = @client.code_frequency_stats('pengwynn/pingwynn')
      expect(stats).to be_kind_of Array
      assert_requested :get, github_url('/repos/pengwynn/pingwynn/stats/code_frequency')
    end
  end # .code_frequency_stats

  describe '.participation_stats', :vcr do
    it 'returns the owner and contributor participation stats' do
      stats = @client.participation_stats('pengwynn/pingwynn')
      expect(stats.fields).to include(:owner)
      assert_requested :get, github_url('/repos/pengwynn/pingwynn/stats/participation')
    end
  end # .participation_stats

  describe '.punch_card_stats', :vcr do
    it 'returns commit count by hour punch card stats' do
      stats = @client.punch_card_stats('pengwynn/pingwynn')
      expect(stats).to be_kind_of Array
      assert_requested :get, github_url('/repos/pengwynn/pingwynn/stats/punch_card')
    end
  end # .punch_card_stats
end
