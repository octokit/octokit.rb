# frozen_string_literal: true

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

    it 'paginates the results' do
      @client.per_page = 1
      allow(@client).to receive(:paginate).and_call_original
      result = @client.repository_artifacts(@test_repo)

      expect(@client).to have_received(:paginate)
      expect(result.total_count).to eq(3)
      expect(result.artifacts.count).to eq(1)
    end

    it 'auto-paginates the results' do
      @client.auto_paginate = true
      @client.per_page = 1
      allow(@client).to receive(:paginate).and_call_original
      result = @client.repository_artifacts(@test_repo)

      expect(@client).to have_received(:paginate)
      expect(result.total_count).to eq(3)
      expect(result.artifacts.count).to eq(3)
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
