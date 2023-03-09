# frozen_string_literal: true

describe Octokit::Client::CommunityProfile do
  before do
    Octokit.reset!
    @client = oauth_client
  end

  describe '.community_profile', :vcr do
    it 'returns community profile metrics for a repository' do
      community_profile = @client.community_profile('octokit/octokit.rb')
      expect(community_profile.health_percentage).not_to be_nil
      assert_requested :get, github_url('/repos/octokit/octokit.rb/community/profile')
    end
  end # .community_profile
end
