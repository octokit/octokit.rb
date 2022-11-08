# frozen_string_literal: true

require 'helper'

describe Octokit::Client::Deployments do
  before do
    Octokit.reset!
    @client = oauth_client
  end

  after do
    Octokit.reset!
  end

  describe '.deployments', :vcr do
    it 'lists deployments' do
      deployments = @client.deployments(@test_repo)
      expect(deployments).to be_kind_of Array
      assert_requested :get, github_url("/repos/#{@test_repo}/deployments")
    end
  end # .deployments

  context 'with ref', :vcr do
    before(:each) do
      commits = @client.commits(@test_repo)
      @first_sha = commits.first.sha

      @branch_name = 'testing/deployment'
      @ref = @client.create_ref(@test_repo, "heads/#{@branch_name}", @first_sha)
    end

    after(:each) do
      begin
        @client.delete_ref(@test_repo, "heads/#{@branch_name}")
      rescue Octokit::UnprocessableEntity
      end
    end

    describe '.create_deployment' do
      it 'creates a deployment' do
        deployment = @client.create_deployment(@test_repo, @branch_name)
        expect(deployment.sha).to eq(@ref.object.sha)
        expect(deployment.creator.login).to eq(test_github_login)
        assert_requested :post, github_url("/repos/#{@test_repo}/deployments")
      end

      it 'creates a deployment with a payload' do
        opts = { payload: { environment: 'production' } }
        deployment = @client.create_deployment(@test_repo, @branch_name, opts)
        expect(deployment.sha).to eq(@ref.object.sha)
        expect(deployment.creator.login).to eq(test_github_login)
        expect(deployment.payload.to_hash).to eq(opts[:payload])
        assert_requested :post, github_url("/repos/#{@test_repo}/deployments")
      end
    end # .create_deployment

    context 'with deployment' do
      before(:each) do
        @deployment = @client.create_deployment(@test_repo, @branch_name)
        @deployment_url = "https://api.github.com/repos/#{@test_repo}/deployments/#{@deployment.id}"
      end

      describe '.deployment' do
        it 'gets a single deployment' do
          deployment = @client.deployment(@test_repo, @deployment.id)
          expect(deployment).to be_kind_of Sawyer::Resource
          assert_requested :get, github_url("/repos/#{@test_repo}/deployments/#{@deployment.id}")
        end
      end # .deployment

      describe '.delete_deployment' do
        it 'deletes a single deployment' do
          response = @client.delete_deployment(@test_repo, @deployment.id)
          expect(response.empty?).to be true
          assert_requested :delete, github_url("/repos/#{@test_repo}/deployments/#{@deployment.id}")
        end
      end # .delete_deployment

      describe '.deployment_statuses' do
        it 'lists deployment statuses' do
          statuses = @client.deployment_statuses(@deployment_url)
          expect(statuses).to be_kind_of Array
          assert_requested :get, github_url(@deployment_url)
          assert_requested :get, github_url("#{@deployment_url}/statuses")
        end
      end # .deployment_statuses

      describe '.create_deployment_status' do
        it 'creates a deployment status' do
          status = @client.create_deployment_status(@deployment_url, 'SUCCESS', target_url: 'http://wynn.fm')
          expect(status.creator.login).to eq(test_github_login)
          expect(status.state).to eq('success')
          expect(status.rels[:target].href).to eq('http://wynn.fm')
          assert_requested :get, github_url(@deployment_url)
          assert_requested :post, github_url("#{@deployment_url}/statuses")
        end
      end # .create_deployment_status
    end # with deployment
  end # with ref
end
