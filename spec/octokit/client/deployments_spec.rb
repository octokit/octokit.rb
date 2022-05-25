require 'helper'

describe Octokit::Client::ReposDeployments do

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

  context "with ref", :vcr do
    before(:each) do
      commits = @client.commits(@test_repo)
      @first_sha = commits.first.sha

      @branch_name = "testing/deployment"
      @ref = @client.create_ref(@test_repo, "heads/#{@branch_name}", @first_sha)
    end

    after(:each) do
      begin
        @client.delete_ref(@test_repo, "heads/#{@branch_name}")
      rescue Octokit::UnprocessableEntity
      end
    end

    describe ".create_deployment" do
      it "creates a deployment" do
        deployment = @client.create_deployment(@test_repo, @branch_name)
        expect(deployment.sha).to eq(@ref.object.sha)
        expect(deployment.creator.login).to eq(test_github_login)
        assert_requested :post, github_url("/repos/#{@test_repo}/deployments")
      end

      it "creates a deployment with a payload" do
        opts = {:payload => {:environment => "production"}}
        deployment = @client.create_deployment(@test_repo, @branch_name, opts)
        expect(deployment.sha).to eq(@ref.object.sha)
        expect(deployment.creator.login).to eq(test_github_login)
        expect(deployment.payload.to_hash).to eq(opts[:payload])
        assert_requested :post, github_url("/repos/#{@test_repo}/deployments")
      end
    end # .create_deployment

    context "with deployment" do
      before(:each) do
        @deployment = @client.create_deployment(@test_repo, @branch_name)
        @deployment_url = "https://api.github.com/repos/#{@test_repo}/deployments/#{@deployment.id}"
      end

      describe ".deployment" do
        it "gets a single deployment" do
          deployment = @client.deployment(@test_repo, @deployment.id)
          expect(deployment).to be_kind_of Sawyer::Resource
          assert_requested :get, github_url("/repos/#{@test_repo}/deployments/#{@deployment.id}")
        end
      end # .deployment

      describe ".delete_deployment" do
        it "deletes a deployment" do
          result = @client.delete_deployment(@test_repo, @deployment.id)
          expect(result).to be_truthy
          assert_requested :post, github_url("/repos/#{@test_repo}/deployments")
        end
      end

      describe ".deployment_statuses" do
        it "lists deployment statuses" do
          statuses = @client.deployment_statuses(@test_repo, @deployment.id)
          expect(statuses).to be_kind_of Array
          assert_requested :get, github_url("#{@deployment_url}/statuses")
        end
      end # .deployment_statuses

      describe ".create_deployment_status" do
        it "creates a deployment status" do
          status = @client.create_deployment_status(@test_repo, @deployment.id, "SUCCESS", :log_url => "http://wynn.fm", :accept => "application/vnd.github.ant-man-preview+json")
          expect(status.creator.login).to eq(test_github_login)
          expect(status.state).to eq("success")
          expect(status.rels[:log].href).to eq("http://wynn.fm")
          assert_requested :post, github_url("#{@deployment_url}/statuses")
        end
      end # .create_deployment_status

      context "with deployment status" do
        before(:each) do
          @status = @client.create_deployment_status(@test_repo, @deployment.id, "SUCCESS", :log_url => "http://wynn.fm", :accept => "application/vnd.github.ant-man-preview+json")
        end

        describe ".deployment_status" do
          it "gets a single deployment status" do
            status = @client.deployment_status(@test_repo, @deployment.id, @status.id,:accept => "application/vnd.github.ant-man-preview+json")
            expect(status).to be_kind_of Sawyer::Resource
            assert_requested :get, github_url("/repos/#{@test_repo}/deployments/#{@deployment.id}/statuses/#{status.id}")
          end
        end # .deployment_status
      end
    end # with deployment
  end # with ref
end
