require 'helper'

describe Octokit::Client::LegacySearch do

  before do
    Octokit.reset!
    VCR.insert_cassette 'legacy_search'
  end

  after do
    Octokit.reset!
    VCR.eject_cassette
  end

  describe ".legacy_search_issues" do
    it "returns matching issues" do
      issues = Octokit.search_issues("sferik/rails_admin", "activerecord")
      expect(issues).to_not be_empty
      assert_requested :get, github_url("/legacy/issues/search/sferik/rails_admin/open/activerecord")
    end
  end # .search_issues

  describe ".legacy_search_repos" do
    it "returns matching repositories" do
      repositories = Octokit.search_repositories("One40Proof")
      expect(repositories).to_not be_empty
      assert_requested :get, github_url("/legacy/repos/search/One40Proof")
    end
  end # .legacy_search_repos

  describe ".legacy_search_users" do
    it "returns matching username" do
      users = Octokit.search_users("sferik")
      expect(users.first.username).to eq("sferik")
      assert_requested :get, github_url("/legacy/user/search/sferik")
    end
  end # .legacy_searcy_users

end
