require 'helper'

describe Octokit::Client::Statuses do
  before do
    @client = oauth_client
  end

  describe ".statuses", :vcr do
    it "lists commit statuses" do
      statuses = Octokit.statuses('octokit/octokit.rb', '7d069dedd4cb56bf57760688657abd0e6b5a28b8')
      expect(statuses).to be_kind_of Array
      assert_requested :get, github_url("/repos/octokit/octokit.rb/statuses/7d069dedd4cb56bf57760688657abd0e6b5a28b8")
    end
  end # .statuses

  context "with repository" do
    before do
      @commit_sha = @client.commits(@test_repo).first.sha
    end

    describe ".create_status", :vcr do
      it "creates status" do
        info = {
          :target_url => 'http://wynnnetherland.com'
        }
        @client.create_status(@test_repo, @commit_sha, 'success', info)
        assert_requested :post, github_url("/repos/#{@test_repo}/statuses/#{@commit_sha}")
      end
    end # .create_status
  end # with repository
end # Octokit::Client::Statuses
