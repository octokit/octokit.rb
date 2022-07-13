# frozen_string_literal: true

require 'helper'

describe Octokit::Client::CommitBranches do
  before do
    Octokit.reset!
    @client = Octokit::Client.new
  end

  describe '.commit_branches', :vcr do
    it 'returns a list of all branches associated with a commit' do
      branches = @client.commit_branches(
        'sferik/rails_admin',
        '77571f28ef686e5b3fac853e5f29037ff4591a08',
        accept: preview_header
      )
      expect(branches.first.name).to eq('master')
      assert_requested :get, github_url('/repos/sferik/rails_admin/commits/77571f28ef686e5b3fac853e5f29037ff4591a08/branches-where-head')
    end
  end # .commit branches

  private

  def preview_header
    Octokit::Preview::PREVIEW_TYPES[:commit_branches]
  end
end
