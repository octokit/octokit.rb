# frozen_string_literal: true

require 'helper'

describe Octokit::Client::ActionsWorkflowJobs, :vcr do
  before do
    Octokit.reset!
    @client = oauth_client
    @run_id = 96_922_843
    @attempt_number = 1
  end

  after do
    Octokit.reset!
  end

  describe '.workflow_run_attempt_jobs' do
    it 'returns jobs for a workflow run attempt' do
      request = stub_get("repos/#{@test_repo}/actions/runs/#{@run_id}/attempts/#{@attempt_number}/jobs")

      @client.workflow_run_attempt_jobs(@test_repo, @run_id, @attempt_number)

      assert_requested request
    end
  end

  describe '.workflow_run_jobs' do
    it 'returns jobs for a workflow run' do
      request = stub_get("repos/#{@test_repo}/actions/runs/#{@run_id}/jobs")

      @client.workflow_run_jobs(@test_repo, @run_id)

      assert_requested request
    end
  end
end
