# frozen_string_literal: true

describe Octokit::Client::Environments do
  before do
    Octokit.reset!
    @client = oauth_client
    @environment_name = 'octokit-environment'
  end

  after do
    Octokit.reset!
  end

  describe '.environment', :vcr do
    before(:each) do
      @client.create_or_update_environment(@test_repo, @environment_name)
    end

    it 'returns the environment', :vcr do
      environment = @client.environment(@test_repo, @environment_name)
      expect(environment).to be_kind_of Sawyer::Resource
      assert_requested :get, github_url("/repos/#{@test_repo}/environments/#{@environment_name}")
    end
  end # .environment

  describe '.environments', :vcr do
    before(:each) do
      @client.create_or_update_environment(@test_repo, @environment_name)
    end

    after(:each) do
      @client.delete_environment(@test_repo, @environment_name)
    end

    it 'lists environments' do
      environments = @client.environments(@test_repo)
      expect(environments).to be_kind_of Sawyer::Resource
      assert_requested :get, github_url("/repos/#{@test_repo}/environments")
    end
  end # .environments

  describe '.create_or_update_environment', :vcr do
    after(:each) do
      @client.delete_environment(@test_repo, @environment_name)
    end

    context 'when creating' do
      context 'without options' do
        it 'creates an environment' do
          environment = @client.create_or_update_environment(@test_repo, @environment_name)
          expect(environment.name).to eq(@environment_name)
          assert_requested :put, github_url("/repos/#{@test_repo}/environments/#{@environment_name}")
        end
      end # without options

      context 'with options' do
        it 'creates an environment' do
          options = {
            deployment_branch_policy: {
              protected_branches: true,
              custom_branch_policies: false
            }
          }
          environment = @client.create_or_update_environment(@test_repo, @environment_name, options)
          expect(environment.name).to eq(@environment_name)
          expect(environment.deployment_branch_policy.to_h).to eq({ protected_branches: true, custom_branch_policies: false })
          assert_requested :put, github_url("/repos/#{@test_repo}/environments/#{@environment_name}")
        end
      end # with options
    end # when creating

    context 'when updating' do
      it 'updates the environment' do
        options = {
          deployment_branch_policy: {
            protected_branches: true,
            custom_branch_policies: false
          }
        }

        @client.create_or_update_environment(@test_repo, @environment_name, options)

        updated_options = {
          deployment_branch_policy: {
            protected_branches: false,
            custom_branch_policies: true
          }
        }
        environment = @client.create_or_update_environment(@test_repo, @environment_name, updated_options)
        expect(environment.deployment_branch_policy.to_h).to eq({ protected_branches: false, custom_branch_policies: true })
        assert_requested :put, github_url("/repos/#{@test_repo}/environments/#{@environment_name}"), times: 2
      end
    end # when updating
  end # .create_or_update_environment

  describe '.delete_environment', :vcr do
    before(:each) do
      @client.create_or_update_environment(@test_repo, @environment_name)
    end

    it 'deletes the environment' do
      response = @client.delete_environment(@test_repo, @environment_name)
      expect(response.empty?).to be true
      assert_requested :delete, github_url("/repos/#{@test_repo}/environments/#{@environment_name}")
    end
  end # .delete_environment
end
