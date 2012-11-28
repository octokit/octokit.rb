# -*- encoding: utf-8 -*-
require 'helper'

describe Octokit::Client::Issues do

  before do
    @client = Octokit::Client.new(:login => 'sferik')
  end

  describe ".issue_events" do

    it "lists events for an issue" do
      stub_get("/repos/pengwynn/octokit/issues/38/events").
      to_return(json_response("issue_events.json"))
      events = @client.issue_events("pengwynn/octokit", 38)
      expect(events.first.event).to eq("mentioned")
      expect(events.last.actor.login).to eq("ctshryock")
    end

    it "gets a single event" do
      stub_get("/repos/pengwynn/octokit/issues/events/3094334").
      to_return(json_response("issue_event.json"))
      events = @client.issue_event("pengwynn/octokit", 3094334)
      expect(events.actor.login).to eq("sferik")
      expect(events.event).to eq("closed")
    end

  end

end
