# -*- encoding: utf-8 -*-
require 'helper'

describe Octokit::Client::Refs do

  before do
    @client = Octokit::Client.new(:login => 'sferik')
  end

  describe ".refs" do

    it "should return all refs" do
      stub_get("/repos/sferik/rails_admin/git/refs/").
        to_return(:body => fixture("v3/refs.json"))
      refs = @client.refs("sferik/rails_admin")
      refs.first.ref.should == "refs/heads/actions"
    end

    it "should return all tag refs" do
      stub_get("/repos/sferik/rails_admin/git/refs/tags").
        to_return(:body => fixture("v3/refs_tags.json"))
      refs = @client.refs("sferik/rails_admin","tags")
      refs.first.ref.should == "refs/tags/v0.0.1"
    end

  end

  describe ".ref" do

    it "should return the tags/v0.0.3 ref" do
      stub_get("/repos/sferik/rails_admin/git/refs/tags/v0.0.3").
        to_return(:body => fixture("v3/ref.json"))
      ref = @client.ref("sferik/rails_admin","tags/v0.0.3")
      ref.object.type.should eq("tag")
      ref.ref.should eq("refs/tags/v0.0.3")
      ref.url.should eq("https://api.github.com/repos/sferik/rails_admin/git/refs/tags/v0.0.3")
    end

  end

  describe ".create_ref" do

    it "should create a ref" do
      stub_post("/repos/octocat/Hello-World/git/refs").
        with(:body => { "ref" => "refs/heads/master", "sha" => "827efc6d56897b048c772eb4087f854f46256132" },
             :headers => {'Content-Type'=>'application/json'}).
        to_return(:body => fixture("v3/ref_create.json"))
      ref = @client.create_ref("octocat/Hello-World","heads/master", "827efc6d56897b048c772eb4087f854f46256132")
      ref.first.ref.should eq("refs/heads/master")
    end

  end

  describe ".update_ref" do

    it "should update a ref" do
      stub_patch("/repos/octocat/Hello-World/git/refs/heads/sc/featureA").
        with(:body => { "sha" => "aa218f56b14c9653891f9e74264a383fa43fefbd", "force" => true },
             :headers => {'Content-Type'=>'application/json'}).
        to_return(:body => fixture("v3/ref_update.json"))
      refs = @client.update_ref("octocat/Hello-World","heads/sc/featureA", "aa218f56b14c9653891f9e74264a383fa43fefbd", true)
      refs.first.ref.should eq("refs/heads/sc/featureA")
      refs.first.object.sha.should eq("aa218f56b14c9653891f9e74264a383fa43fefbd")
    end
  end

  describe ".delete_ref" do

    it "should delete an existing ref" do
      stub_delete("/repos/octocat/Hello-World/git/refs/heads/feature-a").
        to_return(:status => 204)
      ref = @client.delete_ref("octocat/Hello-World", "heads/feature-a")
      ref.status.should == 204
    end

  end

end

