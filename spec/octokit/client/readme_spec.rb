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
end
