# frozen_string_literal: true

require 'helper'

describe Octokit::Client::ActionsArtifacts, :vcr do
  before do
    Octokit.reset!
    @client = oauth_client
    @workflow_run_id = 123
    @artifact_id = 456
  end

  after do
    Octokit.reset!
  end

  describe '.repository_artifacts' do
    it 'returns all artifacts for a repository' do
      request = stub_get("repos/#{@test_repo}/actions/artifacts")

      @client.repository_artifacts(@test_repo)

      assert_requested request
    end
  end

  describe '.workflow_run_artifacts' do
    it 'returns all artifacts for a workflow run' do
      request = stub_get("repos/#{@test_repo}/actions/runs/#{@workflow_run_id}/artifacts")

      @client.workflow_run_artifacts(@test_repo, @workflow_run_id)

      assert_requested request
    end
  end

  describe '.artifact' do
    it 'returns the requested artifact' do
      request = stub_get("repos/#{@test_repo}/actions/artifacts/#{@artifact_id}")

      @client.artifact(@test_repo, @artifact_id)

      assert_requested request
    end
  end

  describe '.artifact_download_url' do
    it 'returns the location of artifact .zip archive' do
      request = stub_head("repos/#{@test_repo}/actions/artifacts/#{@artifact_id}/zip")

      @client.artifact_download_url(@test_repo, @artifact_id)

      assert_requested request
    end
  end

  describe '.delete_artifact' do
    it 'deletes the artifact' do
      request = stub_delete("repos/#{@test_repo}/actions/artifacts/#{@artifact_id}")

      @client.delete_artifact(@test_repo, @artifact_id)

      assert_requested request
    end
  end
end
