# -*- encoding: utf-8 -*-
require 'helper'

describe Octokit::Client::Objects do

  before do
    @client = Octokit::Client.new(:login => 'sferik')
  end

  describe ".tree" do

    it "should return a tree" do
      stub_get("https://api.github.com/repos/sferik/rails_admin/git/trees/3cdfabd973bc3caac209cba903cfdb3bf6636bcd").
        to_return(:body => fixture("v3/tree.json"))
      result = @client.tree("sferik/rails_admin", "3cdfabd973bc3caac209cba903cfdb3bf6636bcd")
      result.sha.should == "3cdfabd973bc3caac209cba903cfdb3bf6636bcd"
      result.tree.first.path.should == ".gitignore"
    end

  end

  describe ".blob" do

    it "should return a blob" do
      stub_get("https://api.github.com/repos/sferik/rails_admin/git/blobs/94616fa57520ac8147522c7cf9f03d555595c5ea").
        to_return(:body => fixture("v3/blob.json"))
      blob = @client.blob("sferik/rails_admin", "94616fa57520ac8147522c7cf9f03d555595c5ea")
      blob.sha.should == "94616fa57520ac8147522c7cf9f03d555595c5ea"
    end

  end

  describe ".blobs" do

    it "should return blobs" do
      stub_get("https://github.com/api/v2/json/blob/all/sferik/rails_admin/3cdfabd973bc3caac209cba903cfdb3bf6636bcd").
        to_return(:body => fixture("v2/blobs.json"))
      blobs = @client.blobs("sferik/rails_admin", "3cdfabd973bc3caac209cba903cfdb3bf6636bcd")
      blobs[".gitignore"].should == "5efe0eb47a773fa6ea84a0bf190ee218b6a31ead"
    end

  end

  describe ".blob_metadata" do

    it "should return blob metadata" do
      stub_get("https://github.com/api/v2/json/blob/full/sferik/rails_admin/3cdfabd973bc3caac209cba903cfdb3bf6636bcd").
        to_return(:body => fixture("v2/blob_metadata.json"))
      blob_metadata = @client.blob_metadata("sferik/rails_admin", "3cdfabd973bc3caac209cba903cfdb3bf6636bcd")
      blob_metadata.first.name.should == ".gitignore"
    end

  end

  describe ".tree_metadata" do

    it "should return tree metadata" do
      stub_get("https://github.com/api/v2/json/tree/full/sferik/rails_admin/3cdfabd973bc3caac209cba903cfdb3bf6636bcd").
        to_return(:body => fixture("v2/tree_metadata.json"))
      tree_metadata = @client.tree_metadata("sferik/rails_admin", "3cdfabd973bc3caac209cba903cfdb3bf6636bcd")
      tree_metadata.first.name.should == ".gitignore"
    end

  end

  describe ".raw" do

    it "should return raw data" do
      stub_get("https://github.com/api/v2/json/blob/show/sferik/rails_admin/3cdfabd973bc3caac209cba903cfdb3bf6636bcd").
        to_return(:body => fixture("v2/raw.txt"))
      raw = @client.raw("sferik/rails_admin", "3cdfabd973bc3caac209cba903cfdb3bf6636bcd")
      lambda {
        MultiJson.load(raw)
      }.should raise_error
    end

  end

end
