# frozen_string_literal: true

require 'helper'

describe Octokit::Client::ActionsArtifacts, :vcr do
  before do
    Octokit.reset!
    @client = oauth_client
    @workflow_run_id = 3_049_298_023
    @artifact_id = 362_518_594
  end

  after do
    Octokit.reset!
  end

  describe '.repository_artifacts' do
    it 'returns all artifacts for a repository' do
      repository_artifacts = @client.repository_artifacts(@test_repo)

      assert_requested :get, github_url("repos/#{@test_repo}/actions/artifacts")
      expect(repository_artifacts).to be_kind_of Sawyer::Resource
    end
  end

  describe '.workflow_run_artifacts' do
    it 'returns all artifacts for a workflow run' do
      workflow_run_artifacts = @client.workflow_run_artifacts(@test_repo, @workflow_run_id)

      assert_requested :get, github_url("repos/#{@test_repo}/actions/runs/#{@workflow_run_id}/artifacts")
      expect(workflow_run_artifacts).to be_kind_of Sawyer::Resource
    end
  end

  describe '.artifact' do
    it 'returns the requested artifact' do
      artifact = @client.artifact(@test_repo, @artifact_id)

      assert_requested :get, github_url("repos/#{@test_repo}/actions/artifacts/#{@artifact_id}")
      expect(artifact).to be_kind_of Sawyer::Resource
    end
  end

  describe '.artifact_download_url' do
    it 'returns the location of artifact .zip archive' do
      url = @client.artifact_download_url(@test_repo, @artifact_id)

      assert_requested :head, github_url("repos/#{@test_repo}/actions/artifacts/#{@artifact_id}/zip")
      expect(url).to be_kind_of String
    end
  end

  describe '.delete_artifact' do
    it 'deletes the artifact' do
      status = @client.delete_artifact(@test_repo, @artifact_id)

      assert_requested :delete, github_url("repos/#{@test_repo}/actions/artifacts/#{@artifact_id}")
      expect(status).to be(true)
    end
  end
end
