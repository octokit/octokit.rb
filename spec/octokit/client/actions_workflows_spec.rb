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
      workflow_file_name = "simple_workflow.yml"
      request = stub_get("/repos/#{@test_repo}/actions/workflows/#{workflow_file_name}")

      @client.workflow(@test_repo, workflow_file_name)

      assert_requested request
    end
  end # .workflow
end
