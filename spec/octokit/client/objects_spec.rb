require File.expand_path('../../../helper', __FILE__)

describe Octokit::Client::Objects do

  before do
    @client = Octokit::Client.new(:login => 'sferik')
  end

  describe ".tree" do

    it "should return a tree" do
      stub_get("tree/show/sferik/rails_admin/3cdfabd973bc3caac209cba903cfdb3bf6636bcd").
        to_return(:body => fixture("tree.json"))
      tree = @client.tree("sferik/rails_admin", "3cdfabd973bc3caac209cba903cfdb3bf6636bcd")
      tree.first.name.should == ".gitignore"
    end

  end

  describe ".blob" do

    it "should return a blob" do
      stub_get("blob/show/sferik/rails_admin/3cdfabd973bc3caac209cba903cfdb3bf6636bcd/README.mkd").
        to_return(:body => fixture("blob.json"))
      blob = @client.blob("sferik/rails_admin", "3cdfabd973bc3caac209cba903cfdb3bf6636bcd", "README.mkd")
      blob.name.should == "README.mkd"
    end

  end

  describe ".blobs" do

    it "should return blobs" do
      stub_get("blob/all/sferik/rails_admin/3cdfabd973bc3caac209cba903cfdb3bf6636bcd").
        to_return(:body => fixture("blobs.json"))
      blobs = @client.blobs("sferik/rails_admin", "3cdfabd973bc3caac209cba903cfdb3bf6636bcd")
      blobs[".gitignore"].should == "5efe0eb47a773fa6ea84a0bf190ee218b6a31ead"
    end

  end

  describe ".blob_metadata" do

    it "should return blob metadata" do
      stub_get("blob/full/sferik/rails_admin/3cdfabd973bc3caac209cba903cfdb3bf6636bcd").
        to_return(:body => fixture("blob_metadata.json"))
      blob_metadata = @client.blob_metadata("sferik/rails_admin", "3cdfabd973bc3caac209cba903cfdb3bf6636bcd")
      blob_metadata.first.name.should == ".gitignore"
    end

  end

  describe ".tree_metadata" do

    it "should return tree metadata" do
      stub_get("tree/full/sferik/rails_admin/3cdfabd973bc3caac209cba903cfdb3bf6636bcd").
        to_return(:body => fixture("tree_metadata.json"))
      tree_metadata = @client.tree_metadata("sferik/rails_admin", "3cdfabd973bc3caac209cba903cfdb3bf6636bcd")
      tree_metadata.first.name.should == ".gitignore"
    end

  end

  describe ".raw" do

    it "should return raw data" do
      pending "TODO: This shouldn't get parsed as JSON"
      stub_get("blob/show/sferik/rails_admin/3cdfabd973bc3caac209cba903cfdb3bf6636bcd").
        to_return(:body => fixture("raw.txt"))
      raw = @client.raw("sferik/rails_admin", "3cdfabd973bc3caac209cba903cfdb3bf6636bcd")
    end

  end

end
