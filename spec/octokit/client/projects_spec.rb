require 'helper'

describe Octokit::Client::Projects do

  describe ".projects", :vcr do
    it "returns a list of projects for a repository" do
      projects = oauth_client.projects('octokit/octokit.rb')
      expect(projects).to be_kind_of Array
      assert_requested :get, github_url("/repos/octokit/octokit.rb/projects")
    end
  end # .projects

end # Octokit::Client::Projects
