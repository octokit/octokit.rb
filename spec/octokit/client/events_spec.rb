require 'helper'

describe Octokit::Client::Events do

  before do
    Octokit.reset!
    @client = oauth_client
  end

  describe ".public_events", :vcr do
    it "returns all public events" do
      events = @client.public_events
      expect(events).to be_kind_of Array
      assert_requested :get, github_url("/events")
    end
  end # .public_events

  describe ".user_events", :vcr do
    it "returns all user events" do
      events = @client.user_events('sferik')
      expect(events).to be_kind_of Array
      assert_requested :get, github_url("/users/sferik/events")
    end
  end # .user_events

  describe ".user_public_events", :vcr do
    it "returns public events performed by a user" do
      events = @client.user_public_events("sferik")
      expect(events).to be_kind_of Array
      assert_requested :get, github_url("/users/sferik/events/public")
    end
  end # .user_public_events

  describe ".repo_events", :vcr do
    it "returns events for a repository" do
      events = @client.repo_events("sferik/rails_admin")
      expect(events).to be_kind_of Array
      assert_requested :get, github_url('/repos/sferik/rails_admin/events')
    end
  end # .repo_events

  describe ".user_org_events", :vcr do
    it "returns all events for an organization" do
      client = oauth_client
      events = client.user_org_events(test_github_login, "github")
      expect(events).to be_kind_of Array
      assert_requested :get, github_url("/users/#{test_github_login}/events/orgs/github")
    end
  end # .user_org_events

  describe ".public_org_events", :vcr do
    it "returns an organization's public events" do
      events = @client.public_org_events("github")
      expect(events).to be_kind_of Array
      assert_requested :get, github_url("/orgs/github/events")
    end
  end # .public_org_events

  describe ".issue_event", :vcr do
    it "lists issue events for a repository" do
      # TODO: Remove and use hypermedia
      @client.issue_event("octokit/octokit.rb", 37786228)
      assert_requested :get, github_url("/repos/octokit/octokit.rb/issues/events/37786228")
    end
  end # .issue_events

  describe ".issues_events", :vcr do
    it "lists issue events for a repository" do
      issue_events = @client.issues_events("octokit/octokit.rb")
      expect(issue_events).to be_kind_of Array
      assert_requested :get, github_url("/repos/octokit/octokit.rb/issues/events")
    end
  end # .issues_events

  describe ".issue_events", :vcr do
    it "lists issue events for a repository" do
      issue_events = @client.issue_events("octokit/octokit.rb", 4)
      expect(issue_events).to be_kind_of Array
      assert_requested :get, github_url("/repos/octokit/octokit.rb/issues/4/events")
    end
  end # .issue_events
end
