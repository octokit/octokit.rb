# -*- encoding: utf-8 -*-
require 'helper'

describe Octokit::Client::Issues do

  before do
    @client = Octokit::Client.new(:login => 'sferik')
  end

  describe ".issue_events" do

    it "should list events for an issue" do
      stub_get("/repos/pengwynn/octokit/issues/38/events").
      to_return(:body => fixture("v3/issue_events.json"))
      events = @client.issue_events("pengwynn/octokit", 38)
      events.first.event.should == "mentioned"
      events.last.actor.login.should == "ctshryock"
    end

    it "should get a single event" do
      stub_get("/repos/pengwynn/octokit/issues/events/3094334").
      to_return(:body => fixture("v3/issue_event.json"))
      events = @client.issue_event("pengwynn/octokit", 3094334)
      events.actor.login.should == "sferik"
      events.event.should == "closed"
    end

  end

end
