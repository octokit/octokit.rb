# frozen_string_literal: true

require 'helper'

describe Octokit::Client::ActionsWorkflows do
  before do
    Octokit.reset!
    @client = oauth_client
  end

  describe '.workflows', :vcr do
    it 'returns the repository workflows' do
      @client.workflows(@test_repo)

      assert_requested :get, github_url("/repos/#{@test_repo}/actions/workflows")
    end
  end # .workflows

  describe '.workflow', :vcr do
    it 'returns the repository workflows' do
      workflow_file_name = 'simple_workflow.yml'
      request = stub_get("/repos/#{@test_repo}/actions/workflows/#{workflow_file_name}")

      @client.workflow(@test_repo, workflow_file_name)

      assert_requested request
    end
  end # .workflow

  describe '.workflow_dispatch', :vcr do
    it 'creates a workflow dispatch event' do
      workflow_file_name = 'simple_workflow.yml'
      request = stub_post("/repos/#{@test_repo}/actions/workflows/#{workflow_file_name}/dispatches")

      @client.workflow_dispatch(@test_repo, workflow_file_name, 'main')
      assert_requested request
    end
  end # .workflow_dispatch
end
