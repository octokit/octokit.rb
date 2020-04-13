require 'helper'

describe Octokit::Client::Collaborators do

  context "with org project" do
    before(:each) do
      project = oauth_client.create_org_project(test_github_org, "org test project", accept: preview_header)
      @project_id = project.id
      @user = "hmharvey"
    end

    after(:each) do
      project = oauth_client.delete_project(@project_id, accept: preview_header)
    end

    describe ".project_collaborators", :vcr do
      it "returns a list of projects collaborators" do
        collaborators = oauth_client.project_collaborators(@project_id, accept: preview_header)
        expect(collaborators).to be_kind_of Array
        assert_requested :get, github_url("/projects/#{@project_id}/collaborators")
      end
    end # .project_collaborators

    describe ".add_project_collaborator", :vcr do
      it "adds a project collaborator" do
        result = oauth_client.add_project_collaborator(@project_id, @user, accept: preview_header)
        expect(result).to eq true
        assert_requested :put, github_url("/projects/#{@project_id}/collaborators/#{@user}")
      end
    end # .add_project_collaborator

    context "with collaborator" do
      before(:each) do
        result = oauth_client.add_project_collaborator(@project_id, @user, accept: preview_header)
      end

      describe ".remove_project_collaborator", :vcr do
        it "removes a project collaborator" do
          result = oauth_client.remove_project_collaborator(@project_id, @user, accept: preview_header)
          expect(result).to eq true
          assert_requested :put, github_url("/projects/#{@project_id}/collaborators/#{@user}")
        end
      end # .remove_project_collaborator

      describe ".user_permission_level", :vcr do
        it "returns a user's permission level" do
          result = oauth_client.user_permission_level(@project_id, @user, accept: preview_header)
          expect(result.permission).to be_kind_of String
          assert_requested :get, github_url("/projects/#{@project_id}/collaborators/#{@user}/permission")
        end
      end # .user_permission_level
    end # with collaborator
  end # with org project

  private

  def preview_header
    Octokit::Preview::PREVIEW_TYPES[:projects]
  end
end
