# -*- encoding: utf-8 -*-
require 'helper'

describe Octokit::Client::Events do
  before do
    @client = Octokit::Client.new(:login => 'sferik')
  end

  describe ".public_events" do
    it "should return all public events" do
      stub_get("/events").
        to_return(:body => fixture("v3/public_events.json"))
      public_events = @client.public_events
      public_events.first.id.should == '1513284759'
    end
  end

  describe ".user_events" do
    it "should return all user events" do
      stub_get("/users/sferik/events").
        to_return(:body => fixture("v3/user_events.json"))
      user_events = @client.user_events('sferik')
      user_events.first.id.should == '1525888969'
    end
  end

  describe ".received_events" do
    it "should return all user received events" do
      stub_get("/users/sferik/received_events").
        to_return(:body => fixture("v3/user_events.json"))
      received_events = @client.received_events('sferik')
      received_events.first.type.should == 'PushEvent'
    end
  end

  describe ".repository_events" do
    it "should return events for a repository" do
      stub_get("/repos/sferik/rails_admin/events").
        to_return(:body => fixture("v3/repo_events.json"))
      repo_events = @client.repository_events("sferik/rails_admin")
      repo_events.first.type.should == "IssuesEvent"
    end
    
  end
end
