# frozen_string_literal: true

require 'helper'

describe Octokit::Client::CommitPulls do
  before do
    Octokit.reset!
    @client = Octokit::Client.new
  end

  describe '.commit_pulls', :vcr do
    it 'returns a list of all pull requests associated with a commit' do
      pulls = @client.commit_pulls(
        'sferik/rails_admin',
        'eddb53155d9bc4db70a0669627e3154e250b2b9a',
        accept: preview_header
      )
      expect(pulls.first.head.sha).not_to be_nil
      assert_requested :get, github_url('/repos/sferik/rails_admin/commits/eddb53155d9bc4db70a0669627e3154e250b2b9a/pulls')
    end
  end # .commit pulls

  private

  def preview_header
    Octokit::Preview::PREVIEW_TYPES[:commit_pulls]
  end
end
