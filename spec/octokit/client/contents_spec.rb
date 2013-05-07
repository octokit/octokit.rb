# -*- encoding: utf-8 -*-
require 'helper'

describe Octokit::Client::Contents do

  before do
    @client = Octokit::Client.new(:login => 'sferik')
  end

  describe ".readme" do

    it "returns the default readme" do
      stub_get("/repos/pengwynn/octokit/readme").
        to_return(json_response("readme.json"))
      readme = @client.readme('pengwynn/octokit')
      expect(readme.encoding).to eq("base64")
      expect(readme.type).to eq("file")
    end

  end

  describe ".contents" do

    it "returns the contents of a file" do
      stub_get("/repos/pengwynn/octokit/contents/lib/octokit.rb").
        to_return(json_response("contents.json"))
      contents = @client.contents('pengwynn/octokit', :path => "lib/octokit.rb")
      expect(contents.path).to eq("lib/octokit.rb")
      expect(contents.name).to eq("lib/octokit.rb")
      expect(contents.encoding).to eq("base64")
      expect(contents.type).to eq("file")
    end

  end

  describe ".archive_link" do

    it "returns the headers of the request" do
      stub_head("/repos/pengwynn/octokit/tarball/master").
        to_return(:status => 302, :body => '', :headers =>
          { 'location' => "https://nodeload.github.com/repos/pengwynn/octokit/tarball/"})
      stub_head("https://nodeload.github.com/repos/pengwynn/octokit/tarball/").
        to_return(:status => 200)

      archive_link = @client.archive_link('pengwynn/octokit', :ref => "master")
      expect(archive_link).to eq("https://nodeload.github.com/repos/pengwynn/octokit/tarball/")
    end

  end

  describe ".create_contents" do
    it "creates repository contents at a path" do
      stub_put("/repos/pengwynn/api-sandbox/contents/foo/bar/baz.txt").
        with({:body => {:message => "I am commit-ing", :content => "SGVyZSBiZSB0aGUgY29udGVudA==\n"}}).
        to_return(json_response("create_content.json"))

      response = @client.create_contents("pengwynn/api-sandbox",
                                         "foo/bar/baz.txt",
                                         "I am commit-ing",
                                         "Here be the content")
      expect(response.commit.sha).to eq '4810b8a0d076f20169bd2acca6501112f4d93e7d'
    end
    it "creates contents from file path" do
      stub_put("/repos/pengwynn/api-sandbox/contents/foo/bar/baz.txt").
        with({:body => {:message => "I am commit-ing", :content => "SGVyZSBiZSB0aGUgY29udGVudAo=\n"}}).
        to_return(json_response("create_content.json"))

      response = @client.create_contents("pengwynn/api-sandbox",
                                         "foo/bar/baz.txt",
                                         "I am commit-ing",
                                         :file => "spec/fixtures/new_file.txt")
      expect(response.commit.sha).to eq '4810b8a0d076f20169bd2acca6501112f4d93e7d'
    end
    it "creates contents from File object" do
      stub_put("/repos/pengwynn/api-sandbox/contents/foo/bar/baz.txt").
        with({:body => {:message => "I am commit-ing", :content => "SGVyZSBiZSB0aGUgY29udGVudAo=\n"}}).
        to_return(json_response("create_content.json"))

      file = File.new "spec/fixtures/new_file.txt", "r"
      response = @client.create_contents("pengwynn/api-sandbox",
                                         "foo/bar/baz.txt",
                                         "I am commit-ing",
                                         :file => file)
      expect(response.commit.sha).to eq '4810b8a0d076f20169bd2acca6501112f4d93e7d'
    end
  end

  describe ".update_contents" do
    it "updates repository contents at a path" do
      stub_put("/repos/pengwynn/api-sandbox/contents/foo/bar/baz.txt").
        with({:body => {
                :sha => "4d149b826e7305659006eb64cfecd3be68d0f2f0",
                :message => "I am commit-ing",
                :content => "SGVyZSBiZSBtb2FyIGNvbnRlbnQ=\n"
        }}).
        to_return(json_response("update_content.json"))

      response = @client.update_contents("pengwynn/api-sandbox",
                                         "foo/bar/baz.txt",
                                         "I am commit-ing",
                                         "4d149b826e7305659006eb64cfecd3be68d0f2f0",
                                         "Here be moar content")
      expect(response.commit.sha).to eq '15ab9bfe8985e69d64e3d06b2eaf252cfbf43a6e'
    end
    it "updates repository contents with a file path" do
      stub_put("/repos/pengwynn/api-sandbox/contents/foo/bar/baz.txt").
        with({:body => {
                :sha => "4d149b826e7305659006eb64cfecd3be68d0f2f0",
                :message => "I am commit-ing",
                :content => "SGVyZSBiZSBtb2FyIGNvbnRlbnQK\n"
        }}).
        to_return(json_response("update_content.json"))

      response = @client.update_contents("pengwynn/api-sandbox",
                                         "foo/bar/baz.txt",
                                         "I am commit-ing",
                                         "4d149b826e7305659006eb64cfecd3be68d0f2f0",
                                         :file => "spec/fixtures/updated_file.txt")
      expect(response.commit.sha).to eq '15ab9bfe8985e69d64e3d06b2eaf252cfbf43a6e'
    end
    it "updates repository contents with a File object" do
      stub_put("/repos/pengwynn/api-sandbox/contents/foo/bar/baz.txt").
        with({:body => {
                :sha => "4d149b826e7305659006eb64cfecd3be68d0f2f0",
                :message => "I am commit-ing",
                :content => "SGVyZSBiZSBtb2FyIGNvbnRlbnQK\n"
        }}).
        to_return(json_response("update_content.json"))

      file = File.new "spec/fixtures/updated_file.txt", "r"
      response = @client.update_contents("pengwynn/api-sandbox",
                                         "foo/bar/baz.txt",
                                         "I am commit-ing",
                                         "4d149b826e7305659006eb64cfecd3be68d0f2f0",
                                         :file => file)
      expect(response.commit.sha).to eq '15ab9bfe8985e69d64e3d06b2eaf252cfbf43a6e'
    end
  end

  describe ".delete_contents" do
    it "deletes repository contents at a path" do
      stub_delete("/repos/pengwynn/api-sandbox/contents/foo/bar/baz.txt").
        with({:query => {
                :sha => "4d149b826e7305659006eb64cfecd3be68d0f2f0",
                :message => "I am rm-ing"
        }}).
        to_return(json_response("delete_content.json"))

      response = @client.delete_contents("pengwynn/api-sandbox",
                                         "foo/bar/baz.txt",
                                         "I am rm-ing",
                                         "4d149b826e7305659006eb64cfecd3be68d0f2f0")
      expect(response.commit.sha).to eq '960a747b2f5c3837184b84e1f8cae7ef1a765e2f'
    end
  end
end
