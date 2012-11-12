# -*- encoding: utf-8 -*-
require 'helper'

describe Octokit::Client::Milestones do

  before do
    stub_get("https://api.github.com/").
      to_return(:body => fixture("v3/root.json"))
    stub_get("/repos/sferik/rails_admin").
      to_return(:body => fixture("v3/repository.json"))
    @client = Octokit::Client.new(:login => 'sferik')
  end

  describe ".list_milestones" do

    it "lists milestones belonging to repository" do
      stub_get("/repos/sferik/rails_admin/milestones").
        to_return(:status => 200, :body => fixture('v3/milestones.json'))
      milestones = @client.list_milestones("sferik/rails_admin")
      expect(milestones.first.description).to eq("Add support for API v3")
    end

  end

  describe ".milestone" do

    it "gets a single milestone belonging to repository" do
      stub_get("/repos/sferik/rails_admin/milestones/1").
        to_return(:status => 200, :body => fixture('v3/milestone.json'))
      milestones = @client.milestone("sferik/rails_admin", 1)
      expect(milestones.description).to eq("Add support for API v3")
    end

  end

  describe ".create_milestone" do

    it "creates a single milestone" do
      stub_post("/repos/sferik/rails_admin/milestones").
        with(:body => '{"title":"0.7.0"}', :headers => {'Content-Type'=>'application/json'}).
        to_return(:status => 201, :body => fixture('v3/milestone.json'))
      milestone = @client.create_milestone("sferik/rails_admin", "0.7.0")
      expect(milestone.title).to eq("0.7.0")
    end

  end

  describe ".update_milestone" do

    it "updates a milestone" do
      stub_put("/repos/sferik/rails_admin/milestones/1").
        with(:body => {"description" => "Add support for API v3"}, :headers => {'Accept'=>'*/*', 'Content-Type'=>'application/json'}).
        to_return(:status => 200, :body => fixture('v3/milestone.json'))
      milestone = @client.update_milestone("sferik/rails_admin", 1, {:description => "Add support for API v3"})
      expect(milestone.description).to eq("Add support for API v3")
    end

  end

  describe ".delete_milestone" do

    it "deletes a milestone from a repository" do
      stub_delete("/repos/sferik/rails_admin/milestones/2").
        to_return(:status => 204, :body => "", :headers => {})
      result = @client.delete_milestone("sferik/rails_admin", 2)
      expect(result).to be_true
    end

  end

end
