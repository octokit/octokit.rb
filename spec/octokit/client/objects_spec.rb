# -*- encoding: utf-8 -*-
require 'helper'

describe Octokit::Client::Objects do

  before do
    @client = Octokit::Client.new(:login => 'sferik')
  end

  describe ".tree" do

    it "returns a tree" do
      stub_get("https://api.github.com/repos/sferik/rails_admin/git/trees/3cdfabd973bc3caac209cba903cfdb3bf6636bcd").
        to_return(json_response("tree.json"))
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
        to_return(json_response("tree_create.json"))
      response = @client.create_tree("octocat/Hello-World", [ { "path" => "file.rb", "mode" => "100644", "type" => "blob", "sha" => "44b4fc6d56897b048c772eb4087f854f46256132" } ])
      expect(response.sha).to eq("cd8274d15fa3ae2ab983129fb037999f264ba9a7")
      expect(response.tree.size).to eq(1)
      expect(response.tree.first.sha).to eq("7c258a9869f33c1e1e1f74fbb32f07c86cb5a75b")
    end

  end

  describe ".blob" do

    it "returns a blob" do
      stub_get("https://api.github.com/repos/sferik/rails_admin/git/blobs/94616fa57520ac8147522c7cf9f03d555595c5ea").
        to_return(json_response("blob.json"))
      blob = @client.blob("sferik/rails_admin", "94616fa57520ac8147522c7cf9f03d555595c5ea")
      expect(blob.sha).to eq("94616fa57520ac8147522c7cf9f03d555595c5ea")
    end

  end

  describe ".create_blob" do

    it "creates a blob" do
      stub_post("/repos/octocat/Hello-World/git/blobs").
        with(:body => { :content => "content", :encoding => "utf-8" },
             :headers => { "Content-Type" => "application/json" }).
        to_return(json_response("blob_create.json"))
      blob = @client.create_blob("octocat/Hello-World", "content")
      expect(blob).to eq("3a0f86fb8db8eea7ccbb9a95f325ddbedfb25e15")
    end

  end

  describe ".tag" do

    it "returns a tag" do
      stub_get("/repos/pengwynn/octokit/git/tags/23aad20633f4d2981b1c7209a800db3014774e96").
        to_return(json_response("tag.json"))
      tag = @client.tag("pengwynn/octokit", "23aad20633f4d2981b1c7209a800db3014774e96")
      expect(tag.sha).to eq("23aad20633f4d2981b1c7209a800db3014774e96")
      expect(tag.message).to eq("Version 1.4.0\n")
      expect(tag.tag).to eq("v1.4.0")
    end

  end

  describe ".create_tag" do

    it "creates a tag" do
      stub_post("/repos/pengwynn/octokit/git/tags").
        with(:body => {
                :tag => "v9000.0.0",
                :message => "Version 9000\n",
                :object => "f4cdf6eb734f32343ce3f27670c17b35f54fd82e",
                :type => "commit",
                :tagger => {
                  :name => "Wynn Netherland",
                  :email => "wynn.netherland@gmail.com",
                  :date => "2012-06-03T17:03:11-07:00"
                }
              },
            :headers => { "Content-Type" => "application/json" }).
              to_return(json_response("tag_create.json"))
      tag = @client.create_tag(
        "pengwynn/octokit",
        "v9000.0.0",
        "Version 9000\n",
        "f4cdf6eb734f32343ce3f27670c17b35f54fd82e",
        "commit",
        "Wynn Netherland",
        "wynn.netherland@gmail.com",
        "2012-06-03T17:03:11-07:00"
      )
      expect(tag.tag).to eq("v9000.0.0")
      expect(tag.message).to eq("Version 9000\n")
      expect(tag.sha).to eq("23aad20633f4d2981b1c7209a800db3014774e96")
    end

  end


end
