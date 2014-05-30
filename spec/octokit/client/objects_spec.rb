require 'helper'

describe Octokit::Client::Objects do

  before do
    Octokit.reset!
    @client = oauth_client
  end

  describe ".tree", :vcr do
    it "gets a tree" do
      result = @client.tree("sferik/rails_admin", "3cdfabd973bc3caac209cba903cfdb3bf6636bcd")
      expect(result.sha).to eq("3cdfabd973bc3caac209cba903cfdb3bf6636bcd")
      expect(result.tree.first.path).to eq(".gitignore")
      assert_requested :get, github_url("/repos/sferik/rails_admin/git/trees/3cdfabd973bc3caac209cba903cfdb3bf6636bcd")
    end
    it "gets a tree recursively" do
      result = @client.tree("sferik/rails_admin", "3cdfabd973bc3caac209cba903cfdb3bf6636bcd", :recursive => true)
      expect(result.sha).to eq("3cdfabd973bc3caac209cba903cfdb3bf6636bcd")
      expect(result.tree.first.path).to eq(".gitignore")
      assert_requested :get, github_url("/repos/sferik/rails_admin/git/trees/3cdfabd973bc3caac209cba903cfdb3bf6636bcd?recursive=true")
    end
  end # .tree

  describe ".create_tree", :vcr do
    it "creates a tree" do
      @client.create_tree(@test_repo, [ { "path" => "wynning.rb", "mode" => "100644", "type" => "blob", :content => "require 'fun'"} ])
      assert_requested :post, github_url("/repos/#{@test_repo}/git/trees")
    end
  end # .create_tree

  describe ".blob", :vcr do
    it "returns a blob" do
      blob = @client.blob("sferik/rails_admin", "94616fa57520ac8147522c7cf9f03d555595c5ea")
      expect(blob.sha).to eq("94616fa57520ac8147522c7cf9f03d555595c5ea")
      assert_requested :get, github_url("/repos/sferik/rails_admin/git/blobs/94616fa57520ac8147522c7cf9f03d555595c5ea")
    end
  end # .blob

  describe ".create_blob", :vcr do
    it "creates a blob" do
      @client.create_blob(@test_repo, "content")
      assert_requested :post, github_url("/repos/#{@test_repo}/git/blobs")
    end
  end # .create_blob

  describe ".tag", :vcr do
    it "returns a tag" do
      @client.tag("octokit/octokit.rb", "23aad20633f4d2981b1c7209a800db3014774e96")
      assert_requested :get, github_url("/repos/octokit/octokit.rb/git/tags/23aad20633f4d2981b1c7209a800db3014774e96")
    end
  end # .tag

  describe ".create_tag", :vcr do
    it "creates a tag" do
      sha = @client.commits(@test_repo).last.sha
      tag = @client.create_tag(
        @test_repo,
        "v9000.0.0",
        "Version 9000\n",
        sha,
        "commit",
        "Wynn Netherland",
        "wynn.netherland@gmail.com",
        "2012-06-03T17:03:11-07:00"
      )
      expect(tag.tag).to eq("v9000.0.0")
      assert_requested :post, github_url("/repos/#{@test_repo}/git/tags")
    end
  end # .create_tag

end
