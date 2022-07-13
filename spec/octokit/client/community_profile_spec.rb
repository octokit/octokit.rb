# frozen_string_literal: true

require 'helper'

describe Octokit::Client::CommunityProfile do
  before do
    Octokit.reset!
    @client = oauth_client
  end

  describe '.community_profile', :vcr do
    it 'returns community profile metrics for a repository' do
      community_profile = @client.community_profile('octokit/octokit.rb', accept: preview_header)
      expect(community_profile.health_percentage).not_to be_nil
      assert_requested :get, github_url('/repos/octokit/octokit.rb/community/profile')
    end
  end # .community_profile

  private

  def preview_header
    Octokit::Preview::PREVIEW_TYPES[:community_profile]
  end
end
