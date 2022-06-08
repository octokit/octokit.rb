# frozen_string_literal: true

require 'helper'

describe Octokit::Client::Meta do
  describe '.github_meta', :vcr do
    it 'returns meta information about github' do
      github_meta = oauth_client.github_meta
      expect(github_meta.git).to be
      assert_requested :get, github_url('/meta')
    end
  end # .github_meta
end
