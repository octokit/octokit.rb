require 'helper'

describe Octokit::Client::Projects do

  describe ".projects", :vcr do
    it "returns a list of projects for a repository" do
      projects = oauth_client.projects('octokit/octokit.rb')
      expect(projects).to be_kind_of Array
      assert_requested :get, github_url("/repos/octokit/octokit.rb/projects")
    end
  end # .projects

  describe ".create_project", :vcr do
    it "returns the newly created project" do
      project = oauth_client.create_project(@test_repo, "api kpi")
      expect(project.name).to eq("api kpi")
      assert_requested :post, github_url("/repos/#{@test_repo}/projects")
    end
  end # .create_project

end # Octokit::Client::Projects
