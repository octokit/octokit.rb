require 'helper'

describe Octokit::Client::Deployments do

  before do
    Octokit.reset!
    @client = oauth_client
  end

  after do
    Octokit.reset!
  end

  describe ".deployments", :vcr do
    it "lists deployments" do
      deployments = @client.deployments(@test_repo)
      expect(deployments).to be_kind_of Array
      assert_requested :get, github_url("/repos/#{@test_repo}/deployments")
    end
  end # .deployments

  describe ".create_deployment", :vcr do
    before do
      @sha = "626ee940f85663dadf245210aaf8ded281fd4cd6"
      status = @client.create_status(@test_repo, @sha, "success")
    end

    it "creates a deployment" do
      deployment = @client.create_deployment(@test_repo, "branch-to-deploy")
      expect(deployment.sha).to eq(@sha)
      expect(deployment.creator.login).to eq(test_github_login)
      assert_requested :post, github_url("/repos/#{@test_repo}/deployments")
    end

    it "creates a deployment with a payload" do
      opts = {:payload => {:environment => "production"}}
      deployment = @client.create_deployment(@test_repo, "branch-to-deploy", opts)
      expect(deployment.sha).to eq(@sha)
      expect(deployment.creator.login).to eq(test_github_login)
      expect(deployment.payload.to_hash).to eq(opts[:payload])
      assert_requested :post, github_url("/repos/#{@test_repo}/deployments")
    end
  end # .create_deployment

  describe ".deployment_statuses", :vcr do
    it "lists deployment statuses" do
      deployment_url = "https://api.github.com/repos/api-playground/api-sandbox/deployments/137"
      statuses = @client.deployment_statuses(deployment_url)
      expect(statuses).to be_kind_of Array
      assert_requested :get, github_url(deployment_url)
      assert_requested :get, github_url("#{deployment_url}/statuses")
    end
  end # .deployment_statuses

  describe ".create_deployment_status", :vcr do
    it "creates a deployment status" do
      deployment_url = "https://api.github.com/repos/api-playground/api-sandbox/deployments/137"
      status = @client.create_deployment_status(deployment_url, "SUCCESS", :target_url => "http://wynn.fm")
      expect(status.creator.login).to eq(test_github_login)
      expect(status.state).to eq("success")
      expect(status.rels[:target].href).to eq("http://wynn.fm")
      assert_requested :get, github_url(deployment_url)
      assert_requested :post, github_url("#{deployment_url}/statuses")
    end
  end # .create_deployment_status

end
