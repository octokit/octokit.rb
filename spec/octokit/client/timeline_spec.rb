require 'helper'

describe Octokit::Client::Timeline do

  before do
    Octokit.reset!
    @client = oauth_client
    @test_login = test_github_login
  end

  after do
    Octokit.reset!
  end

  context "with issue", :vcr do
    before(:each) do
      @issue = @client.create_issue(@test_repo, "Timeline Events")
    end

    describe ".timeline_events", :vcr do
      it "returns an issue timeline" do
        timeline = @client.timeline_events(@test_repo, @issue.number, accept: preview_header)
        expect(timeline).to be_kind_of Array
        assert_requested :get, github_url("/repos/#{@test_repo}/issues/#{@issue.number}/timeline")
      end
    end # .issue_timeline
  end # with issue

  private

  def preview_header
    Octokit::Preview::PREVIEW_TYPES[:timeline_events]
  end
end
