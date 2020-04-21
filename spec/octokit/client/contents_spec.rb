require 'helper'

describe Octokit::Client::ReposContents do

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
      contents = @client.contents('octokit/octokit.rb', "lib/octokit.rb")
      expect(contents.encoding).to eq("base64")
      expect(contents.type).to eq("file")
      assert_requested :get, github_url("/repos/octokit/octokit.rb/contents/lib/octokit.rb")
    end
  end # .contents

  describe ".create_file", :vcr do
    it "creates repository file at a path", :vcr do
      response = @client.create_file(@test_repo,
                                     "test_create.txt",
                                     "I am commit-ing",
                                     "Here be the content\n")
      expect(response.commit.sha).to match(/[a-z0-9]{40}/)
      assert_requested(:put, github_url("/repos/#{@test_repo}/contents/test_create.txt"))
      response = @client.delete_file(@test_repo,
                                     "test_create.txt",
                                     "I am rm-ing",
                                     response.content.sha)
    end
  end # .create_contents

  describe ".update_file", :vcr do
    it "updates repository file at a path" do
      content = @client.create_file(@test_repo,
                                    "test_update.txt",
                                    "I am commit-ing",
                                    "spec/fixtures/new_file.txt")
      response = @client.update_file(@test_repo,
                                     "test_update.txt",
                                     "I am commit-ing",
                                     "Here be moar content",
                                     :sha => content.content.sha)
      expect(response.commit.sha).to match(/[a-z0-9]{40}/)
      assert_requested :put,
        github_url("/repos/#{@test_repo}/contents/test_update.txt"),
        :times => 2

        response = @client.delete_file(@test_repo,
                                       "test_update.txt",
                                       "I am rm-ing",
                                       response.content.sha)
    end
  end # .update_contents

  describe ".delete_file", :vcr do
    it "deletes repository file at a path" do
      content = @client.create_file(@test_repo,
                                    "test_delete.txt",
                                    "I am commit-ing",
                                    "You DELETE me")
      response = @client.delete_file(@test_repo,
                                     "test_delete.txt",
                                     "I am rm-ing",
                                     content.content.sha)
      expect(response.commit.sha).to match(/[a-z0-9]{40}/)
      assert_requested :delete,
        github_url("/repos/#{@test_repo}/contents/test_delete.txt")
    end
  end # .delete_file
end
