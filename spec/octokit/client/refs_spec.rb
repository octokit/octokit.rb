# -*- encoding: utf-8 -*-
require 'helper'

describe Octokit::Client::Refs do

  before do
    @client = Octokit::Client.new(:login => 'sferik')
  end

  describe ".refs" do

    it "returns all refs" do
      stub_get("/repos/sferik/rails_admin/git/refs/").
        to_return(json_response("refs.json"))
      refs = @client.refs("sferik/rails_admin")
      expect(refs.first.ref).to eq("refs/heads/actions")
    end

    it "returns all tag refs" do
      stub_get("/repos/sferik/rails_admin/git/refs/tags").
        to_return(json_response("refs_tags.json"))
      refs = @client.refs("sferik/rails_admin","tags")
      expect(refs.first.ref).to eq("refs/tags/v0.0.1")
    end

  end

  describe ".ref" do

    it "returns the tags/v0.0.3 ref" do
      stub_get("/repos/sferik/rails_admin/git/refs/tags/v0.0.3").
        to_return(json_response("ref.json"))
      ref = @client.ref("sferik/rails_admin","tags/v0.0.3")
      expect(ref.object.type).to eq("tag")
      expect(ref.ref).to eq("refs/tags/v0.0.3")
      expect(ref.url).to eq("https://api.github.com/repos/sferik/rails_admin/git/refs/tags/v0.0.3")
    end

  end

  describe ".create_ref" do

    it "creates a ref" do
      stub_post("/repos/octocat/Hello-World/git/refs").
        with(:body => { "ref" => "refs/heads/master", "sha" => "827efc6d56897b048c772eb4087f854f46256132" },
             :headers => {'Content-Type'=>'application/json'}).
        to_return(json_response("ref_create.json"))
      ref = @client.create_ref("octocat/Hello-World","heads/master", "827efc6d56897b048c772eb4087f854f46256132")
      expect(ref.first.ref).to eq("refs/heads/master")
    end

  end

  describe ".update_ref" do

    it "updates a ref" do
      stub_patch("/repos/octocat/Hello-World/git/refs/heads/sc/featureA").
        with(:body => { "sha" => "aa218f56b14c9653891f9e74264a383fa43fefbd", "force" => true },
             :headers => {'Content-Type'=>'application/json'}).
        to_return(json_response("ref_update.json"))
      refs = @client.update_ref("octocat/Hello-World","heads/sc/featureA", "aa218f56b14c9653891f9e74264a383fa43fefbd", true)
      expect(refs.first.ref).to eq("refs/heads/sc/featureA")
      expect(refs.first.object.sha).to eq("aa218f56b14c9653891f9e74264a383fa43fefbd")
    end
  end

  describe ".delete_ref" do

    it "deletes an existing ref" do
      stub_delete("/repos/octocat/Hello-World/git/refs/heads/feature-a").
        to_return(:status => 204)
      result = @client.delete_ref("octocat/Hello-World", "heads/feature-a")
      expect(result).to eq(true)
    end

  end

end

