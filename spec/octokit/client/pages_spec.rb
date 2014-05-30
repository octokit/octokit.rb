require 'helper'

describe Octokit::Client::Pages do

  before do
    Octokit.reset!
    @client = oauth_client
  end

  describe ".pages", :vcr do
    it "lists page information" do
      pages = @client.pages("github/developer.github.com")
      expect(pages.cname).to eq("developer.github.com")
      assert_requested :get, github_url("/repos/github/developer.github.com/pages")
    end
  end # .pages

  describe ".list_pages_builds", :vcr do
    it "lists information about all the page builds" do
      builds = @client.pages_builds("github/developer.github.com")
      expect(builds).to be_kind_of Array
      latest_build = builds.first
      expect(latest_build.status).to eq("built")
      assert_requested :get, github_url("/repos/github/developer.github.com/pages/builds")
    end
  end # .list_pages_builds

  describe ".latest_pages_build", :vcr do
    it "lists information about the latest page build" do
      latest_build = @client.latest_pages_build("github/developer.github.com")
      expect(latest_build.status).to eq("built")
      assert_requested :get, github_url("/repos/github/developer.github.com/pages/builds/latest")
    end
  end # .latest_pages_build
end
