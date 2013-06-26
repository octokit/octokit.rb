require 'helper'

describe Octokit::Client::Contents do

  before do
    Octokit.reset!
    @client = oauth_client
  end

  describe ".readme", :vcr do
    it "returns the default readme" do
      readme = @client.readme('octokit/octokit.rb')
      expect(readme.encoding).to eq "base64"
      expect(readme.type).to eq "file"
      assert_requested :get, github_url("/repos/octokit/octokit.rb/readme")
    end
  end # .readme

  describe ".contents", :vcr do
    it "returns the contents of a file" do
      contents = @client.contents('octokit/octokit.rb', :path => "lib/octokit.rb")
      expect(contents.encoding).to eq "base64"
      expect(contents.type).to eq "file"
      assert_requested :get, github_url("/repos/octokit/octokit.rb/contents/lib/octokit.rb")
    end
  end # .contents

  describe ".archive_link", :vcr do
    it "returns the headers of the request" do
      archive_link = @client.archive_link('octokit/octokit.rb', :ref => "master")
      expect(archive_link).to eq 'https://codeload.github.com/octokit/octokit.rb/legacy.tar.gz/master'
      assert_requested :head, github_url("/repos/octokit/octokit.rb/tarball/master")
    end
  end # .archive_link

  # TODO: Make the following specs idempotent

  describe ".create_contents", :vcr do
    it "creates repository contents at a path", :vcr do
      response = @client.create_contents("api-playground/api-sandbox",
                                         "test_create.txt",
                                         "I am commit-ing",
                                         "Here be the content\n")
      expect(response.commit.sha).to match /[a-z0-9]{40}/
      assert_requested(:put, github_url("/repos/api-playground/api-sandbox/contents/test_create.txt"))
    end
    it "creates contents from file path", :vcr do
      response = @client.create_contents("api-playground/api-sandbox",
                                         "test_create_path.txt",
                                         "I am commit-ing",
                                         :file => "spec/fixtures/new_file.txt")
      expect(response.commit.sha).to match /[a-z0-9]{40}/
      assert_requested(:put, github_url("/repos/api-playground/api-sandbox/contents/test_create_path.txt"))
    end
    it "creates contents from File object", :vcr do
      file = File.new "spec/fixtures/new_file.txt", "r"
      response = @client.create_contents("api-playground/api-sandbox",
                                         "test_create_file.txt",
                                         "I am commit-ing",
                                         :file => file)
      expect(response.commit.sha).to match /[a-z0-9]{40}/
      assert_requested(:put, github_url("/repos/api-playground/api-sandbox/contents/test_create_file.txt"))
    end
  end # .create_contents

  describe ".update_contents", :vcr do
    it "updates repository contents at a path" do
      content = @client.create_contents("api-playground/api-sandbox",
                                         "test_update.txt",
                                         "I am commit-ing",
                                         :file => "spec/fixtures/new_file.txt")
      response = @client.update_contents("api-playground/api-sandbox",
                                         "test_update.txt",
                                         "I am commit-ing",
                                         content.content.sha,
                                         "Here be moar content")
      expect(response.commit.sha).to match /[a-z0-9]{40}/
      assert_requested :put,
        github_url("/repos/api-playground/api-sandbox/contents/test_update.txt"),
        :times => 2

    end
  end # .update_contents

  describe ".delete_contents", :vcr do
    it "deletes repository contents at a path" do
      content = @client.create_contents("api-playground/api-sandbox",
                                         "test_delete.txt",
                                         "I am commit-ing",
                                         "You DELETE me")
      response = @client.delete_contents("api-playground/api-sandbox",
                                         "test_delete.txt",
                                         "I am rm-ing",
                                         content.content.sha)
      expect(response.commit.sha).to match /[a-z0-9]{40}/
      assert_requested :delete,
        github_url("/repos/api-playground/api-sandbox/contents/test_delete.txt")
    end
  end # .delete_contents

  describe ".create_contents" do
    it "creates repository contents at a path" do
      stub_put("/repos/pengwynn/api-sandbox/contents/foo/bar/baz.txt").
        with({:body => {:message => "I am commit-ing", :content => "SGVyZSBiZSB0aGUgY29udGVudA=="}}).
        to_return(json_response("create_content.json"))

      response = @client.create_contents("pengwynn/api-sandbox",
                                         "foo/bar/baz.txt",
                                         "I am commit-ing",
                                         "Here be the content")
      expect(response.commit.sha).to eq '4810b8a0d076f20169bd2acca6501112f4d93e7d'
    end
    it "creates contents from file path" do
      stub_put("/repos/pengwynn/api-sandbox/contents/foo/bar/baz.txt").
        with({:body => {:message => "I am commit-ing", :content => "SGVyZSBiZSB0aGUgY29udGVudAo="}}).
        to_return(json_response("create_content.json"))

      response = @client.create_contents("pengwynn/api-sandbox",
                                         "foo/bar/baz.txt",
                                         "I am commit-ing",
                                         :file => "spec/fixtures/new_file.txt")
      expect(response.commit.sha).to eq '4810b8a0d076f20169bd2acca6501112f4d93e7d'
    end
    it "creates contents from File object" do
      stub_put("/repos/pengwynn/api-sandbox/contents/foo/bar/baz.txt").
        with({:body => {:message => "I am commit-ing", :content => "SGVyZSBiZSB0aGUgY29udGVudAo="}}).
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
                :content => "SGVyZSBiZSBtb2FyIGNvbnRlbnQ="
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
                :content => "SGVyZSBiZSBtb2FyIGNvbnRlbnQK"
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
                :content => "SGVyZSBiZSBtb2FyIGNvbnRlbnQK"
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
