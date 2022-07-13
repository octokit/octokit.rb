# frozen_string_literal: true

require 'helper'

describe Octokit::Client::Traffic do
  describe '.top_referrers', :vcr do
    it 'returns the referrers stats for a repository' do
      referrers = oauth_client.top_referrers(@test_repo, accept: preview_header)
      expect(referrers).to be_kind_of Array
      assert_requested :get, github_url("/repos/#{@test_repo}/traffic/popular/referrers")
    end
  end # .top_referrers

  describe '.top_paths', :vcr do
    it 'returns the top path statistics for a repository' do
      top_paths = oauth_client.top_paths(@test_repo, accept: preview_header)
      expect(top_paths).to be_kind_of Array
      assert_requested :get, github_url("/repos/#{@test_repo}/traffic/popular/paths")
    end
  end # .top_paths

  describe '.views', :vcr do
    it 'returns the views breakdown for a repository' do
      views = oauth_client.views(@test_repo, accept: preview_header)
      expect(views.count).to be_kind_of Integer
      assert_requested :get, github_url("/repos/#{@test_repo}/traffic/views")
    end
  end # .views

  describe '.clones', :vcr do
    it 'returns the clone stats for a repository' do
      clones = oauth_client.clones(@test_repo, accept: preview_header)
      expect(clones.count).to be_kind_of Integer
      assert_requested :get, github_url("/repos/#{@test_repo}/traffic/clones")
    end
  end # .clones

  private

  def preview_header
    Octokit::Preview::PREVIEW_TYPES[:traffic]
  end
end
