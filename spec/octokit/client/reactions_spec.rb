require 'helper'

describe Octokit::Client::Reactions do
  before do
    Octokit.reset!
    @client = oauth_client
  end

  context "with issue and reaction", :vcr do
    before do
      @issue = @client.create_issue(@test_repo, "Migrate issues to v3")
      @reaction = @client.create_issue_reaction(@test_repo, @issue.number, "+1", accept: preview_header)
    end

    describe ".delete_reaction_legacy" do
      it "deletes the reaction" do
        @client.delete_reaction_legacy(@reaction.id, accept: preview_header)
        assert_requested :delete, github_url("/reactions/#{@reaction.id}")
      end
    end # .delete_reaction
  end # with reaction

  private

  def preview_header
    Octokit::Preview::PREVIEW_TYPES[:reactions]
  end
end
