# frozen_string_literal: true

describe Octokit::Client::ActionsWorkflowJobs, :vcr do
  before do
    Octokit.reset!
    @client = oauth_client
    @run_id = 3_163_227_438
    @attempt_number = 1
    @job_id = 69_548_127
  end

  after do
    Octokit.reset!
  end

  describe '.workflow_run_job' do
    it 'returns job for a workflow run' do
      request = stub_get("repos/#{@test_repo}/actions/jobs/#{@job_id}")

      @client.workflow_run_job(@test_repo, @job_id)

      assert_requested request
    end
  end

  describe '.workflow_run_job_logs' do
    it 'returns job logs for a workflow run' do
      request = stub_head("repos/#{@test_repo}/actions/jobs/#{@job_id}/logs")

      @client.workflow_run_job_logs(@test_repo, @job_id)

      assert_requested request
    end
  end

  describe '.workflow_run_attempt_jobs' do
    it 'returns jobs for a workflow run attempt' do
      request = stub_get("repos/#{@test_repo}/actions/runs/#{@run_id}/attempts/#{@attempt_number}/jobs")

      @client.workflow_run_attempt_jobs(@test_repo, @run_id, @attempt_number)

      assert_requested request
    end

    it 'paginates the results' do
      @client.per_page = 1
      allow(@client).to receive(:paginate).and_call_original
      result = @client.workflow_run_attempt_jobs(@test_repo, @run_id, @attempt_number)

      expect(@client).to have_received(:paginate)
      expect(result.total_count).to eq(2)
      expect(result.jobs.count).to eq(1)
    end

    it 'auto-paginates the results' do
      @client.auto_paginate = true
      @client.per_page = 1
      allow(@client).to receive(:paginate).and_call_original
      result = @client.workflow_run_attempt_jobs(@test_repo, @run_id, @attempt_number)

      expect(@client).to have_received(:paginate)
      expect(result.total_count).to eq(2)
      expect(result.jobs.count).to eq(2)
    end
  end

  describe '.workflow_run_jobs' do
    it 'returns jobs for a workflow run' do
      request = stub_get("repos/#{@test_repo}/actions/runs/#{@run_id}/jobs")

      @client.workflow_run_jobs(@test_repo, @run_id)

      assert_requested request
    end

    it 'paginates the results' do
      @client.per_page = 1
      allow(@client).to receive(:paginate).and_call_original
      result = @client.workflow_run_attempt_jobs(@test_repo, @run_id, @attempt_number)

      expect(@client).to have_received(:paginate)
      expect(result.total_count).to eq(2)
      expect(result.jobs.count).to eq(1)
    end

    it 'auto-paginates the results' do
      @client.auto_paginate = true
      @client.per_page = 1
      allow(@client).to receive(:paginate).and_call_original
      result = @client.workflow_run_attempt_jobs(@test_repo, @run_id, @attempt_number)

      expect(@client).to have_received(:paginate)
      expect(result.total_count).to eq(2)
      expect(result.jobs.count).to eq(2)
    end
  end
end
