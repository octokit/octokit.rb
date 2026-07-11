# frozen_string_literal: true

require 'rbnacl'
require 'base64'

def create_agent_box(public_key)
  b64_key = RbNaCl::PublicKey.new(Base64.decode64(public_key[:key]))
  {
    key_id: public_key[:key_id],
    box: RbNaCl::Boxes::Sealed.from_public_key(b64_key)
  }
end

describe Octokit::Client::AgentSecrets do
  before do
    Octokit.reset!
    @client = oauth_client
    @secrets = [{ name: 'secret_name', value: 'secret_value' }, { name: 'secret_name2', value: 'secret_value2' }]
  end

  context 'with a repo' do
    before(:each) do
      @repo = @client.create_repository('secret-repo')
    end

    after(:each) do
      @client.delete_repository(@repo.full_name) unless @repo.nil?
    rescue Octokit::NotFound
    end

    describe '.get_agent_public_key', :vcr do
      it 'get repo specific public key for secrets encryption' do
        box = create_agent_box(@client.get_agent_public_key(@repo.id))
        expect(box[:key_id]).not_to be_empty
      end
    end # .get_agent_public_key
  end

  context 'with a repo without secrets' do
    before(:each) do
      @repo = @client.create_repository('secret-repo')
    end

    after(:each) do
      @client.delete_repository(@repo.full_name) unless @repo.nil?
    rescue Octokit::NotFound
    end

    describe '.list_agent_secrets', :vcr do
      it 'returns empty list of secrets' do
        secrets = @client.list_agent_secrets(@repo.id)
        expect(secrets.total_count).to eq(0)
        expect(secrets.secrets).to be_empty
      end
    end # .list_agent_secrets

    describe '.list_agent_organization_secrets', :vcr do
      it 'returns empty list of org secrets visible to repo' do
        secrets = @client.list_agent_organization_secrets(@repo.id)
        expect(secrets.total_count).to eq(0)
        expect(secrets.secrets).to be_empty
      end
    end # .list_agent_organization_secrets

    describe '.create_or_update_agent_secret', :vcr do
      it 'creating secret returns 201' do
        box = create_agent_box(@client.get_agent_public_key(@repo.id))
        encrypted = box[:box].encrypt(@secrets.first[:value])
        @client.create_or_update_agent_secret(
          @repo.id, @secrets.first[:name],
          key_id: box[:key_id], encrypted_value: Base64.strict_encode64(encrypted)
        )
        expect(@client.last_response.status).to eq(201)
      end
    end # .create_or_update_agent_secret
  end

  context 'with a repository with a secret' do
    before(:each) do
      @repo = @client.create_repository('secret-repo')
      @box = create_agent_box(@client.get_agent_public_key(@repo.id))
      @secrets.each do |secret|
        encrypted = @box[:box].encrypt(secret[:value])
        @client.create_or_update_agent_secret(
          @repo.id, secret[:name],
          key_id: @box[:key_id], encrypted_value: Base64.strict_encode64(encrypted)
        )
      end
    end

    after(:each) do
      @client.delete_repository(@repo.full_name) unless @repo.nil?
    rescue Octokit::NotFound
    end

    describe '.list_agent_secrets', :vcr do
      it 'returns list of two secrets' do
        secrets = @client.list_agent_secrets(@repo.id)
        expect(secrets.total_count).to eq(2)
        expect(secrets.secrets[0].name).to eq(@secrets.first[:name].upcase)
      end

      it 'paginates the results' do
        @client.per_page = 1
        allow(@client).to receive(:paginate).and_call_original
        secrets = @client.list_agent_secrets(@repo.id)

        expect(@client).to have_received(:paginate)
        expect(secrets.total_count).to eq(2)
        expect(secrets.secrets.count).to eq(1)
      end

      it 'auto-paginates the results' do
        @client.auto_paginate = true
        @client.per_page = 1
        allow(@client).to receive(:paginate).and_call_original
        secrets = @client.list_agent_secrets(@repo.id)

        expect(@client).to have_received(:paginate)
        expect(secrets.total_count).to eq(2)
        expect(secrets.secrets.count).to eq(2)
      end
    end # .list_agent_secrets

    describe '.get_agent_secret', :vcr do
      it 'return timestamps related to one secret' do
        received = @client.get_agent_secret(@repo.id, @secrets.first[:name])
        expect(received.name).to eq(@secrets.first[:name].upcase)
      end
    end # .get_agent_secret

    describe '.create_or_update_agent_secret', :vcr do
      it 'updating existing secret returns 204' do
        box = create_agent_box(@client.get_agent_public_key(@repo.id))
        encrypted = box[:box].encrypt('new value')
        @client.create_or_update_agent_secret(
          @repo.id, @secrets.first[:name],
          key_id: box[:key_id], encrypted_value: Base64.strict_encode64(encrypted)
        )
        expect(@client.last_response.status).to eq(204)
      end
    end # .create_or_update_agent_secret

    describe '.delete_agent_secret', :vcr do
      it 'delete existing secret' do
        @client.delete_agent_secret(@repo.id, @secrets.first[:name])
        expect(@client.last_response.status).to eq(204)
      end
    end # .delete_agent_secret
  end

  context 'with an org' do
    describe '.get_org_agent_public_key', :vcr do
      it 'get org specific public key for secrets encryption' do
        box = create_agent_box(@client.get_org_agent_public_key(test_github_org))
        expect(box[:key_id]).not_to be_empty
      end
    end # .get_org_agent_public_key
  end

  context 'with an org without secrets' do
    describe '.list_org_agent_secrets', :vcr do
      it 'returns empty list of secrets' do
        secrets = @client.list_org_agent_secrets(test_github_org)
        expect(secrets.total_count).to eq(0)
        expect(secrets.secrets).to be_empty
      end
    end # .list_org_agent_secrets

    describe '.create_or_update_org_agent_secret', :vcr do
      it 'creating secret returns 201' do
        @box = create_agent_box(@client.get_org_agent_public_key(test_github_org))
        encrypted = @box[:box].encrypt(@secrets.first[:value])
        @client.create_or_update_org_agent_secret(
          test_github_org, @secrets.first[:name],
          key_id: @box[:key_id],
          encrypted_value: Base64.strict_encode64(encrypted),
          visibility: 'private'
        )
        expect(@client.last_response.status).to eq(201)
      end
    end # .create_or_update_org_agent_secret
  end

  context 'with an org with a secret' do
    before(:each) do
      @box = create_agent_box(@client.get_org_agent_public_key(test_github_org))
      @secrets.each do |secret|
        encrypted = @box[:box].encrypt(secret[:value])
        @client.create_or_update_org_agent_secret(
          test_github_org, secret[:name],
          key_id: @box[:key_id],
          encrypted_value: Base64.strict_encode64(encrypted),
          visibility: 'private'
        )
      end
    end

    describe '.list_org_agent_secrets', :vcr do
      it 'returns list of two secrets' do
        secrets = @client.list_org_agent_secrets(test_github_org)
        expect(secrets.total_count).to eq(2)
        expect(secrets.secrets[0].name).to eq(@secrets.first[:name].upcase)
      end

      it 'paginates the results' do
        @client.per_page = 1
        allow(@client).to receive(:paginate).and_call_original
        secrets = @client.list_org_agent_secrets(test_github_org)

        expect(@client).to have_received(:paginate)
        expect(secrets.total_count).to eq(2)
        expect(secrets.secrets.count).to eq(1)
      end

      it 'auto-paginates the results' do
        @client.auto_paginate = true
        @client.per_page = 1
        allow(@client).to receive(:paginate).and_call_original
        secrets = @client.list_org_agent_secrets(test_github_org)

        expect(@client).to have_received(:paginate)
        expect(secrets.total_count).to eq(2)
        expect(secrets.secrets.count).to eq(2)
      end
    end # .list_org_agent_secrets

    describe '.get_org_agent_secret', :vcr do
      it 'return timestamps related to one secret' do
        received = @client.get_org_agent_secret(test_github_org, @secrets.first[:name])
        expect(received.name).to eq(@secrets.first[:name].upcase)
      end
    end # .get_org_agent_secret

    describe '.create_or_update_org_agent_secret', :vcr do
      it 'updating existing secret returns 204' do
        box = create_agent_box(@client.get_org_agent_public_key(test_github_org))
        encrypted = box[:box].encrypt('new value')
        @client.create_or_update_org_agent_secret(
          test_github_org, @secrets.first[:name],
          key_id: @box[:key_id],
          encrypted_value: Base64.strict_encode64(encrypted),
          visibility: 'private'
        )
        expect(@client.last_response.status).to eq(204)
      end
    end # .create_or_update_org_agent_secret

    describe '.delete_org_agent_secret', :vcr do
      it 'delete existing secret' do
        @client.delete_org_agent_secret(test_github_org, @secrets.first[:name])
        expect(@client.last_response.status).to eq(204)
      end
    end # .delete_org_agent_secret
  end

  context 'with an org with a selected secret' do
    before(:each) do
      @box = create_agent_box(@client.get_org_agent_public_key(test_github_org))
      encrypted = @box[:box].encrypt(@secrets.first[:value])
      @client.create_or_update_org_agent_secret(
        test_github_org, @secrets.first[:name],
        key_id: @box[:key_id],
        encrypted_value: Base64.strict_encode64(encrypted),
        visibility: 'selected',
        selected_repository_ids: [test_github_repository_id]
      )
    end

    describe '.list_org_agent_secret_repositories', :vcr do
      it 'returns list of repositories for a secret' do
        repos = @client.list_org_agent_secret_repositories(test_github_org, @secrets.first[:name])
        expect(repos.total_count).to eq(1)
      end
    end # .list_org_agent_secret_repositories

    describe '.set_org_agent_secret_repositories', :vcr do
      it 'sets selected repositories for a secret' do
        @client.set_org_agent_secret_repositories(test_github_org, @secrets.first[:name], [test_github_repository_id])
        expect(@client.last_response.status).to eq(204)
      end
    end # .set_org_agent_secret_repositories

    describe '.add_org_agent_secret_repository', :vcr do
      it 'adds a repository to a secret' do
        @client.add_org_agent_secret_repository(test_github_org, @secrets.first[:name], test_github_repository_id)
        expect(@client.last_response.status).to eq(204)
      end
    end # .add_org_agent_secret_repository

    describe '.remove_org_agent_secret_repository', :vcr do
      it 'removes a repository from a secret' do
        @client.remove_org_agent_secret_repository(test_github_org, @secrets.first[:name], test_github_repository_id)
        expect(@client.last_response.status).to eq(204)
      end
    end # .remove_org_agent_secret_repository
  end
end
