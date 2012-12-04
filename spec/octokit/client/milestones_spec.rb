# -*- encoding: utf-8 -*-
require 'helper'

describe Octokit::Client::Milestones do

  before do
    @client = Octokit::Client.new(:login => 'sferik')
  end

  describe ".list_milestones" do

    it "lists milestones belonging to repository" do
      stub_get("/repos/pengwynn/octokit/milestones").
        to_return(json_response('milestones.json'))
      milestones = @client.list_milestones("pengwynn/octokit")
      expect(milestones.first.description).to eq("Add support for API v3")
    end

  end

  describe ".milestone" do

    it "gets a single milestone belonging to repository" do
      stub_get("/repos/pengwynn/octokit/milestones/1").
        to_return(json_response('milestone.json'))
      milestones = @client.milestone("pengwynn/octokit", 1)
      expect(milestones.description).to eq("Add support for API v3")
    end

  end

  describe ".create_milestone" do

    it "creates a single milestone" do
      stub_post("/repos/pengwynn/octokit/milestones").
        with(:body => '{"title":"0.7.0"}').
        to_return(json_response('milestone.json'))
      milestone = @client.create_milestone("pengwynn/octokit", "0.7.0")
      expect(milestone.title).to eq("0.7.0")
    end

  end

  describe ".update_milestone" do

    it "updates a milestone" do
      stub_post("/repos/pengwynn/octokit/milestones/1").
        with(:body => {"description" => "Add support for API v3"}).
        to_return(json_response('milestone.json'))
      milestone = @client.update_milestone("pengwynn/octokit", 1, {:description => "Add support for API v3"})
      expect(milestone.description).to eq("Add support for API v3")
    end

  end

  describe ".delete_milestone" do

    it "deletes a milestone from a repository" do
      stub_delete("/repos/pengwynn/octokit/milestones/2").
        to_return(:status => 204, :body => "", :headers => {})
      result = @client.delete_milestone("pengwynn/octokit", 2)
      expect(result).to eq(true)
    end

  end

end
