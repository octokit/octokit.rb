require 'helper'

describe Octokit::Client::Events do

  before do
    Octokit.reset!
    @client = oauth_client
  end

  describe ".public_events", :vcr do
    it "returns all public events" do
      public_events = @client.public_events
      expect(public_events).to be_kind_of Array
      assert_requested :get, github_url("/events")
    end

    context 'when use manual pagination' do
      it "returns all public events" do
        client = oauth_client
        client.auto_paginate = true
        data = []
        first_page_data = client.public_events do |_, next_page|
          data += next_page.data
        end
        data = first_page_data + data
        expect(data).to be_kind_of Array
        expect(data.size).not_to be_zero
      end
    end
  end # .public_events

  describe ".user_events", :vcr do
    it "returns all user events" do
      user_events = @client.user_events('sferik')
      expect(user_events).to be_kind_of Array
      assert_requested :get, github_url("/users/sferik/events")
    end

    context 'when use manual pagination' do
      it "returns all user events" do
        client = oauth_client
        client.auto_paginate = true
        data = []
        first_page_data = client.user_events('sferik') do |_, next_page|
          data += next_page.data
        end
        data = first_page_data + data
        expect(data).to be_kind_of Array
        expect(data.size).not_to be_zero
      end
    end
  end # .user_events

  describe ".user_public_events", :vcr do
    it "returns public events performed by a user" do
      user_public_events = @client.user_public_events("sferik")
      expect(user_public_events).to be_kind_of Array
      assert_requested :get, github_url("/users/sferik/events/public")
    end

    context 'when use manual pagination' do
      it "returns public events performed by a user" do
        client = oauth_client
        client.auto_paginate = true
        data = []
        first_page_data = client.user_public_events("sferik") do |_, next_page|
          data += next_page.data
        end
        data = first_page_data + data
        expect(data).to be_kind_of Array
        expect(data.size).not_to be_zero
      end
    end
  end # .user_public_events

  describe ".received_events", :vcr do
    it "returns all user received events" do
      received_events = @client.received_events("api-padawan")
      expect(received_events).to be_kind_of Array
      assert_requested :get, github_url("/users/api-padawan/received_events")
    end

    context 'when use manual pagination' do
      it "returns all user received events"do
        client = oauth_client
        client.auto_paginate = true
        data = []
        first_page_data = client.received_events("api-padawan") do |_, next_page|
          data += next_page.data
        end
        data = first_page_data + data
        expect(data).to be_kind_of Array
        expect(data.size).not_to be_zero
      end
    end
  end # .received_events

  describe ".received_public_events", :vcr do
    it "returns public user received events" do
      received_public_events = @client.received_public_events("api-padawan")
      expect(received_public_events).to be_kind_of Array
      assert_requested :get, github_url("/users/api-padawan/received_events/public")
    end

    context 'when use manual pagination' do
      it "returns public user received events" do
        client = oauth_client
        client.auto_paginate = true
        data = []
        first_page_data = client.received_public_events("api-padawan") do |_, next_page|
          data += next_page.data
        end
        data = first_page_data + data
        expect(data).to be_kind_of Array
        expect(data.size).not_to be_zero
      end
    end
  end # .received_public_events

  describe ".repository_events", :vcr do
    it "returns events for a repository" do
      repo_events = @client.repository_events("sferik/rails_admin")
      expect(repo_events).to be_kind_of Array
      assert_requested :get, github_url('/repos/sferik/rails_admin/events')
    end

    context 'when use manual pagination' do
      it "returns events for a repository" do
        client = oauth_client
        client.auto_paginate = true
        data = []
        first_page_data = client.repository_events("sferik/rails_admin") do |_, next_page|
          data += next_page.data
        end
        data = first_page_data + data
        expect(data).to be_kind_of Array
        expect(data.size).not_to be_zero
      end
    end
  end # .repository_events

  describe ".repository_network_events", :vcr do
    it "returns events for a repository's network" do
      repo_network_events = @client.repository_network_events("sferik/rails_admin")
      expect(repo_network_events).to be_kind_of Array
      assert_requested :get, github_url('/networks/sferik/rails_admin/events')
    end

    context 'when use manual pagination' do
      it "returns events for a repository's network" do
        client = oauth_client
        client.auto_paginate = true
        data = []
        first_page_data = client.repository_network_events("sferik/rails_admin") do |_, next_page|
          data += next_page.data
        end
        data = first_page_data + data
        expect(data).to be_kind_of Array
        expect(data.size).not_to be_zero
      end
    end
  end # .repository_network_events

  describe ".organization_events", :vcr do
    it "returns all events for an organization" do
      client = oauth_client
      org_events = client.organization_events("github")
      expect(org_events).to be_kind_of Array
      assert_requested :get, github_url("/users/#{test_github_login}/events/orgs/github")
    end

    context 'when use manual pagination' do
      it "returns all events for an organization" do
        client = oauth_client
        client.auto_paginate = true
        data = []
        first_page_data = client.organization_events("github") do |_, next_page|
          data += next_page.data
        end
        data = first_page_data + data
        expect(data).to be_kind_of Array
        expect(data.size).not_to be_zero
      end
    end
  end # .organization_events

  describe ".organization_public_events", :vcr do
    it "returns an organization's public events" do
      org_public_events = @client.organization_public_events("github")
      expect(org_public_events).to be_kind_of Array
      assert_requested :get, github_url("/orgs/github/events")
    end

    context 'when use manual pagination' do
      it "returns an organization's public events" do
        client = oauth_client
        client.auto_paginate = true
        data = []
        first_page_data = client.organization_public_events("github") do |_, next_page|
          data += next_page.data
        end
        data = first_page_data + data
        expect(data).to be_kind_of Array
        expect(data.size).not_to be_zero
      end
    end
  end # .organization_public_events

  describe ".repo_issue_events", :vcr do
    it "lists issue events for a repository" do
      issue_events = @client.repo_issue_events("octokit/octokit.rb")
      expect(issue_events).to be_kind_of Array
      assert_requested :get, github_url("/repos/octokit/octokit.rb/issues/events")
    end

    context 'when use manual pagination' do
      it "lists issue events for a repository" do
        client = oauth_client
        client.auto_paginate = true
        data = []
        first_page_data = client.repo_issue_events("octokit/octokit.rb") do |_, next_page|
          data += next_page.data
        end
        data = first_page_data + data
        expect(data).to be_kind_of Array
        expect(data.size).not_to be_zero
      end
    end
  end # .repo_issue_events

  describe ".issue_events", :vcr do
    it "lists issue events for a repository" do
      issue_events = @client.issue_events("octokit/octokit.rb", 4)
      expect(issue_events).to be_kind_of Array
      assert_requested :get, github_url("/repos/octokit/octokit.rb/issues/4/events")
    end

    context 'when use manual pagination' do
      it "lists issue events for a repository" do
        client = oauth_client
        client.auto_paginate = true
        data = []
        first_page_data = client.issue_events("octokit/octokit.rb", 4) do |_, next_page|
          data += next_page.data
        end
        data = first_page_data + data
        expect(data).to be_kind_of Array
      end
    end
  end # .issue_events

  describe ".issue_event", :vcr do
    it "lists issue events for a repository" do
      # TODO: Remove and use hypermedia
      @client.issue_event("octokit/octokit.rb", 37786228)
      assert_requested :get, github_url("/repos/octokit/octokit.rb/issues/events/37786228")
    end
  end # .issue_events
end
