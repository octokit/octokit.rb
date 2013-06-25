require 'helper'

describe Octokit::Client::Meta do

  describe ".github_meta", :vcr do
    it "returns meta information about github" do
      client = oauth_client
      github_meta = client.github_meta
      expect(github_meta.git).to include "207.97.227.239/32"
      assert_requested :get, github_url("/meta")
    end
  end # .github_meta

end
