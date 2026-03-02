# frozen_string_literal: true

describe Octokit::Client::ActionsWorkflowRuns, :vcr do
  before do
    Octokit.reset!
    @client = oauth_client
    @run_id = 96_922_843
  end

  after do
    Octokit.reset!
  end

  describe '.workflow_runs' do
    workflow_name = 'workflow.yml'

    it 'returns runs for a workflow' do
      request = stub_get("repos/#{@test_repo}/actions/workflows/#{workflow_name}/runs")

      @client.workflow_runs(@test_repo, workflow_name)

      assert_requested request
    end

    it 'paginates the results' do
      @client.per_page = 1
      allow(@client).to receive(:paginate).and_call_original
      result = @client.workflow_runs(
        @test_repo,
        workflow_name
      )

      expect(@client).to have_received(:paginate)
      expect(result.total_count).to eq(3)
      expect(result.workflow_runs.count).to eq(1)
    end

    it 'auto-paginates the results' do
      @client.auto_paginate = true
      @client.per_page = 1
      allow(@client).to receive(:paginate).and_call_original
      result = @client.workflow_runs(
        @test_repo,
        workflow_name
      )

      expect(@client).to have_received(:paginate)
      expect(result.total_count).to eq(3)
      expect(result.workflow_runs.count).to eq(3)
    end
  end

  describe '.repository_workflow_runs' do
    it 'returns all workflow runs for repository' do
      @client.repository_workflow_runs(@test_repo)

      assert_requested :get, github_url("repos/#{@test_repo}/actions/runs")
    end

    it 'paginates the results' do
      @client.per_page = 1
      allow(@client).to receive(:paginate).and_call_original
      result = @client.repository_workflow_runs(
        @test_repo
      )

      expect(@client).to have_received(:paginate)
      expect(result.total_count).to eq(3)
      expect(result.workflow_runs.count).to eq(1)
    end

    it 'auto-paginates the results' do
      @client.auto_paginate = true
      @client.per_page = 1
      allow(@client).to receive(:paginate).and_call_original
      result = @client.repository_workflow_runs(
        @test_repo
      )

      expect(@client).to have_received(:paginate)
      expect(result.total_count).to eq(3)
      expect(result.workflow_runs.count).to eq(3)
    end
  end

  describe '.workflow_run' do
    it 'returns the requested workflow run' do
      request = stub_get("repos/#{@test_repo}/actions/runs/#{@run_id}")

      @client.workflow_run(@test_repo, @run_id)

      assert_requested request
    end
  end

  describe '.rerun_workflow_run' do
    it 'returns true if rerun request was enqueued successfully' do
      request = stub_post("repos/#{@test_repo}/actions/runs/#{@run_id}/rerun").to_return(status: 201)

      result = @client.rerun_workflow_run(@test_repo, @run_id)

      expect(result).to be true
      assert_requested request
    end

    it 'returns false if request returns unexpected status' do
      request = stub_post("repos/#{@test_repo}/actions/runs/#{@run_id}/rerun").to_return(status: 205)

      response = @client.rerun_workflow_run(@test_repo, @run_id)

      expect(response).to be false
      assert_requested request
    end
  end

  describe '.cancel_workflow_run' do
    it 'returns true if cancellation fo the workflow was successful' do
      request = stub_post("repos/#{@test_repo}/actions/runs/#{@run_id}/cancel").to_return(status: 202)

      response = @client.cancel_workflow_run(@test_repo, @run_id)

      expect(response).to be true
      assert_requested request
    end

    it 'returns false if the request returns unexpected status' do
      request = stub_post("repos/#{@test_repo}/actions/runs/#{@run_id}/cancel").to_return(status: 205)

      response = @client.cancel_workflow_run(@test_repo, @run_id)

      expect(response).to be false
      assert_requested request
    end
  end

  describe '.delete_workflow_run' do
    it 'deletes the workflow run' do
      request = stub_delete("repos/#{@test_repo}/actions/runs/#{@run_id}")

      @client.delete_workflow_run(@test_repo, @run_id)

      assert_requested request
    end
  end

  describe '.workflow_run_logs' do
    it 'returns the location of the workflow run logs' do
      request = stub_head("repos/#{@test_repo}/actions/runs/#{@run_id}/logs")

      @client.workflow_run_logs(@test_repo, @run_id)

      assert_requested request
    end
  end

  describe '.delete_workflow_run_logs' do
    it 'deletes the logs for a workflow run' do
      request = stub_delete("repos/#{@test_repo}/actions/runs/#{@run_id}/logs")

      @client.delete_workflow_run_logs(@test_repo, @run_id)

      assert_requested request
    end
  end

  describe '.workflow_run_usage' do
    it 'returns the requested workflow run usage' do
      request = stub_get("repos/#{@test_repo}/actions/runs/#{@run_id}/timing")

      @client.workflow_run_usage(@test_repo, @run_id)

      assert_requested request
    end
  end
end
