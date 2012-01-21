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

  describe ".repository_events" do
    it "should return events for a repository" do
      stub_get("/repos/sferik/rails_admin/events").
        to_return(:body => fixture("v3/repo_events.json"))
      repo_events = @client.repository_events("sferik/rails_admin")
      repo_events.first.type.should == "IssuesEvent"
    end
    
  end
end
