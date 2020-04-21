require 'helper'

describe Octokit::Client::ActivityFeeds do

  before do
    Octokit.reset!
  end

  describe ".feeds", :vcr do
    context "when unauthenticated" do
      it "returns the public feeds list" do
        feeds = Octokit.feeds
        expect(Octokit.user_authenticated?).to be false
        expect(feeds.rels[:timeline].href).to be
        expect(feeds.rels[:current_user_public]).to be_nil
      end
    end

    context "when authenticated with oauth token" do
      it "returns the authenticated users feeds" do
        feeds = oauth_client.feeds
        expect(oauth_client.user_authenticated?).to be true
        expect(feeds.rels[:current_user_public].href).to be
      end
    end
  end # .feeds
end
