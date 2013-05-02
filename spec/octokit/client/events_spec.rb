require 'helper'

describe Octokit::Client::Events do
  before do
    Octokit.reset!
    VCR.insert_cassette 'events'
  end

  after do
    Octokit.reset!
    VCR.eject_cassette
  end

  describe ".public_events" do
    it "returns all public events" do
      public_events = Octokit.public_events
      expect(public_events).to be_kind_of Array
      assert_requested :get, github_url("/events")
    end
  end # .public_events

  describe ".user_events" do
    it "returns all user events" do
      user_events = Octokit.user_events('sferik')
      expect(user_events).to be_kind_of Array
      assert_requested :get, github_url("/users/sferik/events")
    end
  end # .user_events

  describe ".user_public_events" do
    it "returns public events performed by a user" do
      user_public_events = Octokit.user_public_events("sferik")
      expect(user_public_events).to be_kind_of Array
      assert_requested :get, github_url("/users/sferik/events/public")
    end
  end # .user_public_events

  describe ".received_events" do
    it "returns all user received events" do
      received_events = Octokit.received_events("api-padawan")
      expect(received_events).to be_kind_of Array
      assert_requested :get, github_url("/users/api-padawan/received_events")
    end
  end # .received_events

  describe ".received_public_events" do
    it "returns public user received events" do
      received_public_events = Octokit.received_public_events("api-padawan")
      expect(received_public_events).to be_kind_of Array
      assert_requested :get, github_url("/users/api-padawan/received_events/public")
    end
  end # .received_public_events

  describe ".repository_events" do
    it "returns events for a repository" do
      repo_events = Octokit.repository_events("sferik/rails_admin")
      expect(repo_events).to be_kind_of Array
      assert_requested :get, github_url('/repos/sferik/rails_admin/events')
    end
  end # .repository_events

  describe ".repository_network_events" do
    it "returns events for a repository's network" do
      repo_network_events = Octokit.repository_network_events("sferik/rails_admin")
      expect(repo_network_events).to be_kind_of Array
      assert_requested :get, github_url('/networks/sferik/rails_admin/events')
    end
  end # .repository_network_events

  describe ".organization_events" do
    it "returns all events for an organization" do
      client = basic_auth_client
      org_events = client.organization_events("github")
      expect(org_events).to be_kind_of Array
      assert_requested :get, basic_github_url("/users/api-padawan/events/orgs/github")
    end
  end # .organization_events

  describe ".organization_public_events" do
    it "returns an organization's public events" do
      org_public_events = Octokit.organization_public_events("github")
      expect(org_public_events).to be_kind_of Array
      assert_requested :get, github_url("/orgs/github/events")
    end
  end # .organization_public_events

  describe ".repo_issue_events" do
    it "lists issue events for a repository" do
      issue_events = Octokit.repo_issue_events("pengwynn/octokit")
      expect(issue_events).to be_kind_of Array
      assert_requested :get, github_url("/repos/pengwynn/octokit/issues/events")
    end
  end # .repo_issue_events

  describe ".issue_events" do
    it "lists issue events for a repository" do
      issue_events = Octokit.issue_events("pengwynn/octokit", 4)
      expect(issue_events).to be_kind_of Array
      assert_requested :get, github_url("/repos/pengwynn/octokit/issues/4/events")
    end
  end # .issue_events

  describe ".issue_event" do
    it "lists issue events for a repository" do
      # TODO: Remove and use hypermedia
      issue_events = Octokit.issue_event("pengwynn/octokit", 37786228)
      assert_requested :get, github_url("/repos/pengwynn/octokit/issues/events/37786228")
    end
  end # .issue_events
end
