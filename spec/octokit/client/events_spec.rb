# -*- encoding: utf-8 -*-
require 'helper'

describe Octokit::Client::Events do
  before do
    @client = Octokit::Client.new(:login => 'sferik')
  end

  describe ".public_events" do
    it "returns all public events" do
      stub_get("/events").
        to_return json_response("public_events.json")
      public_events = @client.public_events
      expect(public_events.first.id).to eq('1513284759')
    end
  end

  describe ".user_events" do
    it "returns all user events" do
      stub_get("/users/sferik/events").
        to_return json_response("user_events.json")
      user_events = @client.user_events('sferik')
      expect(user_events.first.id).to eq('1525888969')
    end
  end

  describe ".user_public_events" do
    it "returns public events performed by a GitHubber" do
      stub_get("/users/sferik/events/public").
        to_return json_response("user_performed_public_events.json")
      user_public_events = @client.user_public_events("sferik")
      expect(user_public_events.first.id).to eq("1652715007")
    end
  end

  describe ".received_events" do
    it "returns all user received events" do
      stub_get("/users/sferik/received_events").
        to_return json_response("user_events.json")
      received_events = @client.received_events('sferik')
      expect(received_events.first.type).to eq('PushEvent')
    end
  end

  describe ".received_public_events" do
    it "returns public user received events" do
      stub_get("/users/sferik/received_events/public").
        to_return json_response("user_public_events.json")
      received_public_events = @client.received_public_events("sferik")
      expect(received_public_events.first.id).to eq("1652756065")
    end
  end

  describe ".repository_events" do
    it "returns events for a repository" do
      stub_get("/repos/sferik/rails_admin/events").
        to_return json_response("repo_events.json")
      repo_events = @client.repository_events("sferik/rails_admin")
      expect(repo_events.first.type).to eq("IssuesEvent")
    end
  end

  describe ".repository_network_events" do
    it "returns events for a repository's network" do
      stub_get("/networks/sferik/rails_admin/events").
        to_return json_response("repository_network_events.json")
      repo_network_events = @client.repository_network_events("sferik/rails_admin")
      expect(repo_network_events.first.id).to eq("1651989733")
    end
  end

  describe ".organization_events" do
    it "returns all events for an organization" do
      stub_get("/users/sferik/events/orgs/lostisland").
        to_return json_response("organization_events.json")
      org_events = @client.organization_events("lostisland")
      expect(org_events.first.id).to eq("1652750175")
    end
  end

  describe ".organization_public_events" do
    it "returns an organization's public events" do
      stub_get("/orgs/github/events").
        to_return json_response("organization_public_events.json")
      org_public_events = @client.organization_public_events("github")
      expect(org_public_events.first.id).to eq("1652750175")
    end
  end

end
