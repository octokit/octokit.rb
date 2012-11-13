# -*- encoding: utf-8 -*-
require 'helper'

describe Octokit::Client::Issues do

  before do
    stub_get("https://api.github.com/").
      to_return(:body => fixture("v3/root.json"))
    stub_get("/repos/sferik/rails_admin").
      to_return(:body => fixture("v3/repository.json"))
    @client = Octokit::Client.new(:login => 'sferik')
  end

  describe ".issue_events" do

    it "lists events for an issue" do
      stub_get("/repos/sferik/rails_admin/issues/12").
        to_return(:body => fixture("v3/issue.json"))
      stub_get("/repos/sferik/rails_admin/issues/12/events").
        to_return(:body => fixture("v3/issue_events.json"))
      events = @client.issue_events("sferik/rails_admin", 12)
      expect(events.first.event).to eq("mentioned")
      expect(events.last.actor.login).to eq("ctshryock")
    end

    it "gets a single event" do
      stub_get("/repos/sferik/rails_admin/issues/events/3094334").
        to_return(:body => fixture("v3/issue_event.json"))
      events = @client.issue_event("sferik/rails_admin", 3094334)
      expect(events.actor.login).to eq("sferik")
      expect(events.event).to eq("closed")
    end

  end

end
