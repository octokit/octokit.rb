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

  context "with repository" do
    before do
      @test_repo = setup_test_repo.full_name
    end

    after do
      teardown_test_repo @test_repo
    end

    describe ".create_contents", :vcr do
      it "creates repository contents at a path", :vcr do
        response = @client.create_contents(@test_repo,
                                           "test_create.txt",
                                           "I am commit-ing",
                                           "Here be the content\n")
        expect(response.commit.sha).to match /[a-z0-9]{40}/
        assert_requested(:put, github_url("/repos/#{@test_repo}/contents/test_create.txt"))
      end
      it "creates contents from file path", :vcr do
        response = @client.create_contents(@test_repo,
                                           "test_create_path.txt",
                                           "I am commit-ing",
                                           :file => "spec/fixtures/new_file.txt")
        expect(response.commit.sha).to match /[a-z0-9]{40}/
        assert_requested(:put, github_url("/repos/#{@test_repo}/contents/test_create_path.txt"))
      end
      it "creates contents from File object", :vcr do
        file = File.new "spec/fixtures/new_file.txt", "r"
        response = @client.create_contents(@test_repo,
                                           "test_create_file.txt",
                                           "I am commit-ing",
                                           :file => file)
        expect(response.commit.sha).to match /[a-z0-9]{40}/
        assert_requested(:put, github_url("/repos/#{@test_repo}/contents/test_create_file.txt"))
      end
      it "does not add new lines", :vcr do
        file = File.new "spec/fixtures/large_file.txt", "r"
        response = @client.create_contents(@test_repo,
                                           "test_create_without_newlines.txt",
                                           "I am commit-ing",
                                           :file => file)
        assert_requested(:put, github_url("/repos/#{@test_repo}/contents/test_create_without_newlines.txt"))
        content = response.content.rels[:self].get \
          :headers => {:accept => "application/vnd.github.raw" }
        expect(content.data).to eq(File.read("spec/fixtures/large_file.txt"))
      end
    end # .create_contents

    describe ".update_contents", :vcr do
      it "updates repository contents at a path" do
        content = @client.create_contents(@test_repo,
                                           "test_update.txt",
                                           "I am commit-ing",
                                           :file => "spec/fixtures/new_file.txt")
        response = @client.update_contents(@test_repo,
                                           "test_update.txt",
                                           "I am commit-ing",
                                           content.content.sha,
                                           "Here be moar content")
        expect(response.commit.sha).to match /[a-z0-9]{40}/
        assert_requested :put,
          github_url("/repos/#{@test_repo}/contents/test_update.txt"),
          :times => 2

      end
      it "does not add new lines", :vcr do
        content = @client.create_contents(@test_repo,
                                           "test_update_without_newlines.txt",
                                           "I am commit-ing",
                                           :file => "spec/fixtures/new_file.txt")
        response = @client.update_contents(@test_repo,
                                           "test_update_without_newlines.txt",
                                           "I am commit-ing",
                                           content.content.sha,
                                           :file => "spec/fixtures/large_file.txt")

        assert_requested :put,
          github_url("/repos/#{@test_repo}/contents/test_update_without_newlines.txt"),
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
        expect(response.commit.sha).to match /[a-z0-9]{40}/
        assert_requested :delete,
          github_url("/repos/#{@test_repo}/contents/test_delete.txt")
      end
    end # .delete_contents
  end # with repository
end # Octokit::Client::Contents
