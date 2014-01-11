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
      deployments = @client.deployments("api-playground/api-sandbox")
      expect(deployments).to be_kind_of Array
      assert_requested :get, github_url("/repos/api-playground/api-sandbox/deployments")
    end
  end # .deployments

  describe ".create_deployment", :vcr do
    before do
      @sha = "1a638fea888b4f3fc19272a6b256a37556548b2e"
      status = @client.create_status("api-playground/api-sandbox", @sha, "success")
    end

    it "creates a deployment" do
      deployment = @client.create_deployment("api-playground/api-sandbox", "branch-to-deploy")
      expect(deployment.sha).to eq(@sha)
      expect(deployment.creator.login).to eq(test_github_login)
      assert_requested :post, github_url("/repos/api-playground/api-sandbox/deployments")
    end

    it "creates a deployment with a payload" do
      opts = {:payload => {:environment => "production"}}
      deployment = @client.create_deployment("api-playground/api-sandbox", "branch-to-deploy", opts)
      expect(deployment.sha).to eq(@sha)
      expect(deployment.creator.login).to eq(test_github_login)
      expect(deployment.payload).to eq(opts[:payload])
      assert_requested :post, github_url("/repos/api-playground/api-sandbox/deployments")
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
