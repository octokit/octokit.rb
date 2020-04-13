require 'helper'

describe Octokit::Client::Projects do

  describe ".repo_projects", :vcr do
    it "returns a list of projects for a repository" do
      projects = oauth_client.repo_projects('octokit/octokit.rb', accept: preview_header)
      expect(projects).to be_kind_of Array
      assert_requested :get, github_url("/repos/octokit/octokit.rb/projects")
    end
  end # .repo_projects

  describe ".create_repo_project", :vcr do
    it "returns the newly created project" do
      project = oauth_client.create_repo_project(@test_repo, "api kpi", accept: preview_header)
      expect(project.name).to eq("api kpi")
      assert_requested :post, github_url("/repos/#{@test_repo}/projects")
    end
  end # .create_repo_project

  describe ".org_projects", :vcr do
    it "returns the projects for an organization" do
      projects = oauth_client.org_projects(test_github_org, accept: preview_header)
      expect(projects).to be_kind_of Array
      assert_requested :get, github_url("/orgs/#{test_github_org}/projects")
    end
  end # .org_project

  describe ".create_org_project", :vcr do
    it "returns the new org project" do
      project = oauth_client.create_org_project(test_github_org, "synergy", body: "do it", accept: preview_header)
      expect(project.name).to eq "synergy"
      expect(project.body).to eq "do it"
      assert_requested :post, github_url("/orgs/#{test_github_org}/projects")
      oauth_client.delete_project(project.id, accept: preview_header)
    end
  end # .create_org_project

  context "with repository" do
    context "with project" do
      before(:each) do
        @project = oauth_client.create_repo_project(@test_repo, "implement apis", accept: preview_header)
      end

      after(:each) do
        oauth_client.delete_project(@project.id, accept: preview_header)
      end

      describe ".project", :vcr do
        it "returns a project" do
          project = oauth_client.project(@project.id, accept: preview_header)
          expect(project.name).not_to be_nil
          assert_requested :get, github_url("/projects/#{@project.id}")
        end
      end # .project

      describe ".update_project", :vcr do
        it "updates the project name and body then returns the updated project" do
          name = "new name"
          body = "new body"
          project = oauth_client.update_project(@project.id, {name: name, body: body, accept: preview_header})
          expect(project.name).to eq name
          expect(project.body).to eq body
          assert_requested :patch, github_url("/projects/#{@project.id}")
        end

        it "helper methods close and reopen the project" do
          project = oauth_client.close_project(@project.id, accept: preview_header)
          expect(project.state).to eq "closed"
          project = oauth_client.reopen_project(@project.id, accept: preview_header)
          expect(project.state).to eq "open"
          assert_requested :patch, github_url("/projects/#{@project.id}"), :times => 2
        end
      end # .update_project

      describe ".delete_project", :vcr do
        it "returns the result of deleting a project" do
          oauth_client.delete_project(@project.id, accept: preview_header)
          assert_requested :delete, github_url("/projects/#{@project.id}")
        end
      end # .delete_project
    end # with project
  end # with repository

  private

  def preview_header
    Octokit::Preview::PREVIEW_TYPES[:projects]
  end
end
