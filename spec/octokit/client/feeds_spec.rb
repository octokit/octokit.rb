require 'helper'

describe Octokit::Client::Feeds do

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

    # Warning: if you are creating a new cassette for this method, make sure
    # to scrub the private feed token as it is not automatically filtered.
    context "when authenticated with basic auth" do
      it "returns private feeds" do
        feeds = basic_auth_client.feeds
        expect(basic_auth_client.user_authenticated?).to be true
        expect(feeds.rels[:current_user].href).to be
        expect(feeds.rels[:current_user_actor].href).to be
      end
    end
  end # .feeds

  describe ".feed", :vcr do
    it "returns parsed feed data" do
      feed = Octokit.feed(:timeline)
      expect(feed.title.content).to eq("GitHub Public Timeline Feed")
    end
  end # .feed

end
