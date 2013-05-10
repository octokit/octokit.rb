require 'helper'

describe Octokit::Client::Contents do

  before do
    Octokit.reset!
    VCR.insert_cassette 'contents', :match_requests_on => [:uri, :method, :query, :body]
    @client = basic_auth_client
  end

  after do
    VCR.eject_cassette
  end

  describe ".readme" do
    it "returns the default readme" do
      readme = Octokit.readme('pengwynn/octokit')
      expect(readme.encoding).to eq "base64"
      expect(readme.type).to eq "file"
      assert_requested :get, github_url("/repos/pengwynn/octokit/readme")
    end
  end # .readme

  describe ".contents" do
    it "returns the contents of a file" do
      contents = Octokit.contents('pengwynn/octokit', :path => "lib/octokit.rb")
      expect(contents.encoding).to eq "base64"
      expect(contents.type).to eq "file"
      assert_requested :get, github_url("/repos/pengwynn/octokit/contents/lib/octokit.rb")
    end
  end # .contents

  describe ".archive_link" do
    it "returns the headers of the request" do
      archive_link = Octokit.archive_link('pengwynn/octokit', :ref => "master")
      expect(archive_link).to eq 'https://codeload.github.com/pengwynn/octokit/legacy.tar.gz/master'
      assert_requested :head, github_url("/repos/pengwynn/octokit/tarball/master")
    end
  end # .archive_link

  describe ".create_contents" do
    it "creates repository contents at a path" do
      response = @client.create_contents("api-playground/api-sandbox",
                                         "foo/bar/baz.txt",
                                         "I am commit-ing",
                                         "Here be the content\n")
      expect(response.commit.sha).to match /[a-z0-9]{40}/
      assert_requested(:put, basic_github_url("/repos/api-playground/api-sandbox/contents/foo/bar/baz.txt"))
    end
    it "creates contents from file path" do
      response = @client.create_contents("api-playground/api-sandbox",
                                         "foo/bar/baz.txt",
                                         "I am commit-ing",
                                         :file => "spec/fixtures/new_file.txt")
      expect(response.commit.sha).to match /[a-z0-9]{40}/
      assert_requested(:put, basic_github_url("/repos/api-playground/api-sandbox/contents/foo/bar/baz.txt"))
    end
    it "creates contents from File object" do
      file = File.new "spec/fixtures/new_file.txt", "r"
      response = @client.create_contents("api-playground/api-sandbox",
                                         "foo/bar/baz.txt",
                                         "I am commit-ing",
                                         :file => file)
      expect(response.commit.sha).to match /[a-z0-9]{40}/
      assert_requested(:put, basic_github_url("/repos/api-playground/api-sandbox/contents/foo/bar/baz.txt"))
    end
  end # .create_contents

  describe ".update_contents" do
    it "updates repository contents at a path" do
      content = @client.contents("api-playground/api-sandbox", :path => "foo/bar/baz.txt")
      response = @client.update_contents("api-playground/api-sandbox",
                                         "foo/bar/baz.txt",
                                         "I am commit-ing",
                                         content.sha,
                                         "Here be moar content")
      expect(response.commit.sha).to match /[a-z0-9]{40}/
      assert_requested :put,
        basic_github_url("/repos/api-playground/api-sandbox/contents/foo/bar/baz.txt")

      # cleanup so we can re-run these tests with blank cassettes
      @client.delete_contents \
        "api-playground/api-sandbox",
        "foo/bar/baz.txt",
        "I am rm-ing",
        response.content.sha
    end
  end # .update_contents

  describe ".delete_contents" do
    it "deletes repository contents at a path" do
      content = @client.create_contents("api-playground/api-sandbox",
                                         "to.delete.txt",
                                         "I am commit-ing",
                                         "You DELETE me")
      response = @client.delete_contents("api-playground/api-sandbox",
                                         "to.delete.txt",
                                         "I am rm-ing",
                                         content.content.sha)
      expect(response.commit.sha).to match /[a-z0-9]{40}/
      assert_requested :delete,
        basic_github_url("/repos/api-playground/api-sandbox/contents/to.delete.txt")
    end
  end # .delete_contents

end
