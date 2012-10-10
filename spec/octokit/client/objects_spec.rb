# -*- encoding: utf-8 -*-
require 'helper'

describe Octokit::Client::Objects do

  before do
    @client = Octokit::Client.new(:login => 'sferik')
  end

  describe ".tree" do

    it "returns a tree" do
      stub_get("https://api.github.com/repos/sferik/rails_admin/git/trees/3cdfabd973bc3caac209cba903cfdb3bf6636bcd").
        to_return(:body => fixture("v3/tree.json"))
      result = @client.tree("sferik/rails_admin", "3cdfabd973bc3caac209cba903cfdb3bf6636bcd")
      expect(result.sha).to eq("3cdfabd973bc3caac209cba903cfdb3bf6636bcd")
      expect(result.tree.first.path).to eq(".gitignore")
    end

  end

  describe ".create_tree" do

    it "creates a tree" do
      stub_post("/repos/octocat/Hello-World/git/trees").
        with(:body => { :tree => [ { :path => "file.rb", "mode" => "100644", "type" => "blob", "sha" => "44b4fc6d56897b048c772eb4087f854f46256132" } ] },
             :headers => { "Content-Type" => "application/json" }).
        to_return(:body => fixture("v3/tree_create.json"))
      response = @client.create_tree("octocat/Hello-World", [ { "path" => "file.rb", "mode" => "100644", "type" => "blob", "sha" => "44b4fc6d56897b048c772eb4087f854f46256132" } ])
      expect(response.sha).to eq("cd8274d15fa3ae2ab983129fb037999f264ba9a7")
      expect(response.tree.size).to eq(1)
      expect(response.tree.first.sha).to eq("7c258a9869f33c1e1e1f74fbb32f07c86cb5a75b")
    end

  end

  describe ".blob" do

    it "returns a blob" do
      stub_get("https://api.github.com/repos/sferik/rails_admin/git/blobs/94616fa57520ac8147522c7cf9f03d555595c5ea").
        to_return(:body => fixture("v3/blob.json"))
      blob = @client.blob("sferik/rails_admin", "94616fa57520ac8147522c7cf9f03d555595c5ea")
      expect(blob.sha).to eq("94616fa57520ac8147522c7cf9f03d555595c5ea")
    end

  end

  describe ".create_blob" do

    it "creates a blob" do
      stub_post("/repos/octocat/Hello-World/git/blobs").
        with(:body => { :content => "content", :encoding => "utf-8" },
             :headers => { "Content-Type" => "application/json" }).
        to_return(:body => fixture("v3/blob_create.json"))
      blob = @client.create_blob("octocat/Hello-World", "content")
      expect(blob).to eq("3a0f86fb8db8eea7ccbb9a95f325ddbedfb25e15")
    end

  end

end
