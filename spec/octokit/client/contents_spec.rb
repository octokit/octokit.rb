require 'helper'
require 'tempfile'

describe Octokit::Client::Contents do

  before do
    Octokit.reset!
    @client = oauth_client
  end

  describe ".readme", :vcr do
    it "returns the default readme" do
      readme = @client.readme('octokit/octokit.rb')
      expect(readme.encoding).to eq("base64")
      expect(readme.type).to eq("file")
      assert_requested :get, github_url("/repos/octokit/octokit.rb/readme")
    end
  end # .readme

  describe ".contents", :vcr do
    it "returns the contents of a file" do
      contents = @client.contents('octokit/octokit.rb', :path => "lib/octokit.rb")
      expect(contents.encoding).to eq("base64")
      expect(contents.type).to eq("file")
      assert_requested :get, github_url("/repos/octokit/octokit.rb/contents/lib/octokit.rb")
    end
  end # .contents

  describe ".archive_link", :vcr do
    it "returns the headers of the request" do
      archive_link = @client.archive_link('octokit/octokit.rb', :ref => "master")
      expect(archive_link).to eq('https://codeload.github.com/octokit/octokit.rb/legacy.tar.gz/master')
      assert_requested :head, github_url("/repos/octokit/octokit.rb/tarball/master")
    end
  end # .archive_link

  # TODO: Make the following specs idempotent

  describe ".create_contents", :vcr do

    before(:each) do |current_spec|
      @filename = "#{current_spec.metadata[:description]}.txt"
    end

    after(:each) do
      begin
        content = @client.content(@test_repo, path: @filename)
        @client.delete_contents(@test_repo,@filename,"cleanup",content.sha)
      rescue Octokit::NotFound
        return
      end
    end

    it "creates repository contents at a path", :vcr do
      response = @client.create_contents(@test_repo,
                                         @filename,
                                         "I am commit-ing",
                                         "Here be the content\n")
      expect(response.commit.sha).to match(/[a-z0-9]{40}/)
      assert_requested(:put, github_url("/repos/#{@test_repo}/contents/#{@filename}"))
    end
    it "creates contents from file path", :vcr do
      response = @client.create_contents(@test_repo,
                                         @filename,
                                         "I am commit-ing",
                                         :file => "spec/fixtures/new_file.txt")
      expect(response.commit.sha).to match(/[a-z0-9]{40}/)
      assert_requested(:put, github_url("/repos/#{@test_repo}/contents/#{@filename}"))
    end
    it "creates contents from File object", :vcr do
      file = File.new("spec/fixtures/new_file.txt", "r")
      response = @client.create_contents(@test_repo,
                                         @filename,
                                         "I am commit-ing",
                                         :file => file)
      expect(response.commit.sha).to match(/[a-z0-9]{40}/)
      assert_requested(:put, github_url("/repos/#{@test_repo}/contents/#{@filename}"))
    end
    it "creates contents from Tempfile object", :vcr do
      tempfile = Tempfile.new("uploaded_file")
      file = File.new("spec/fixtures/new_file.txt", "r")
      tempfile.write(file.read)
      response = @client.create_contents(@test_repo,
                                         @filename,
                                         "I am commit-ing",
                                         :file => tempfile)
      expect(response.commit.sha).to match(/[a-z0-9]{40}/)
      assert_requested(:put, github_url("/repos/#{@test_repo}/contents/#{@filename}"))
      tempfile.unlink
    end
    it "does not add new lines", :vcr do
      file = File.new("spec/fixtures/large_file.txt", "r")
      response = @client.create_contents(@test_repo,
                                         @filename,
                                         "I am commit-ing",
                                         :file => file)
      assert_requested(:put, github_url("/repos/#{@test_repo}/contents/#{@filename}"))
      content = response.content.rels[:self].get \
        :headers => {:accept => "application/vnd.github.raw" }
      expect(content.data).to eq(File.read("spec/fixtures/large_file.txt"))
    end
  end # .create_contents

  describe ".update_contents", :vcr do
    before(:each) do |current_spec|
      @filename = "#{current_spec.metadata[:description]}.txt"
    end

    after(:each) do
      begin
        content = @client.content(@test_repo, path: @filename)
        @client.delete_contents(@test_repo,@filename,"cleanup",content.sha)
      rescue Octokit::NotFound
        return
      end
    end

    it "updates repository contents at a path" do
      content = @client.create_contents(@test_repo,
                                         @filename,
                                         "I am commit-ing",
                                         :file => "spec/fixtures/new_file.txt")
      response = @client.update_contents(@test_repo,
                                         @filename,
                                         "I am commit-ing",
                                         content.content.sha,
                                         "Here be moar content")
      expect(response.commit.sha).to match(/[a-z0-9]{40}/)
      assert_requested :put,
        github_url("/repos/#{@test_repo}/contents/#{@filename}"),
        :times => 2

    end
    it "does not add new lines", :vcr do
      content = @client.create_contents(@test_repo,
                                         @filename,
                                         "I am commit-ing",
                                         :file => "spec/fixtures/new_file.txt")
      response = @client.update_contents(@test_repo,
                                         @filename,
                                         "I am commit-ing",
                                         content.content.sha,
                                         :file => "spec/fixtures/large_file.txt")

      assert_requested :put,
        github_url("/repos/#{@test_repo}/contents/#{@filename}"),
        :times => 2

      content = response.content.rels[:self].get \
        :headers => {:accept => "application/vnd.github.raw" }
      expect(content.data).to eq(File.read("spec/fixtures/large_file.txt"))
    end
  end # .update_contents

  describe ".delete_contents", :vcr do
    it "deletes repository contents at a path" do
      content = @client.create_contents(@test_repo,
                                         "test_delete.txt",
                                         "I am commit-ing",
                                         "You DELETE me")
      response = @client.delete_contents(@test_repo,
                                         "test_delete.txt",
                                         "I am rm-ing",
                                         content.content.sha)
      expect(response.commit.sha).to match(/[a-z0-9]{40}/)
      assert_requested :delete,
        github_url("/repos/#{@test_repo}/contents/test_delete.txt")
    end
  end # .delete_contents

end
