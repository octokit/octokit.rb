# frozen_string_literal: true

require 'helper'
require 'rbnacl'
require 'base64'

def create_box(public_key)
  b64_key = RbNaCl::PublicKey.new(Base64.decode64(public_key[:key]))
  {
    key_id: public_key[:key_id],
    box: RbNaCl::Boxes::Sealed.from_public_key(b64_key)
  }
end

describe Octokit::Client::ActionsSecrets do
  before do
    Octokit.reset!
    @client = oauth_client
    @secret = { name: 'secret_name', value: 'secret_value' }
  end

  context 'with a repo' do
    before(:each) do
      @repo = @client.create_repository('secret-repo')
    end

    after(:each) do
      begin
        @client.delete_repository(@repo.full_name) unless @repo.nil?
      rescue Octokit::NotFound
      end
    end

    describe '.get_public_key', :vcr do
      it 'get repo specific public key for secrets encryption' do
        box = create_box(@client.get_public_key(@repo.id))
        expect(box[:key_id]).not_to be_empty
      end
    end # .get_public_key
  end

  context 'with a repo without secrets' do
    before(:each) do
      @repo = @client.create_repository('secret-repo')
    end

    after(:each) do
      begin
        @client.delete_repository(@repo.full_name) unless @repo.nil?
      rescue Octokit::NotFound
      end
    end

    describe '.list_secrets', :vcr do
      it 'returns empty list of secrets' do
        secrets = @client.list_secrets(@repo.id)
        expect(secrets.total_count).to eq(0)
        expect(secrets.secrets).to be_empty
      end
    end # .list_secrets

    describe '.create_or_update_secret', :vcr do
      it 'creating secret returns 204 (even though API docs claims it should be 201)' do
        box = create_box(@client.get_public_key(@repo.id))
        encrypted = box[:box].encrypt(@secret[:value])
        @client.create_or_update_secret(
          @repo.id, @secret[:name],
          key_id: box[:key_id], encrypted_value: Base64.strict_encode64(encrypted)
        )
        expect(@client.last_response.status).to eq(204)
      end
    end # .create_or_update_secret
  end

  context 'with a repository with a secret' do
    before(:each) do
      @repo = @client.create_repository('secret-repo')
      @box = create_box(@client.get_public_key(@repo.id))
      encrypted = @box[:box].encrypt(@secret[:value])
      @client.create_or_update_secret(
        @repo.id, @secret[:name],
        key_id: @box[:key_id], encrypted_value: Base64.strict_encode64(encrypted)
      )
    end

    after(:each) do
      begin
        @client.delete_repository(@repo.full_name) unless @repo.nil?
      rescue Octokit::NotFound
      end
    end

    describe '.list_secrets', :vcr do
      it 'returns list of one secret' do
        secrets = @client.list_secrets(@repo.id)
        expect(secrets.total_count).to eq(1)
        expect(secrets.secrets[0].name).to eq(@secret[:name])
      end
    end # .list_secrets

    describe '.get_secret', :vcr do
      it 'return timestamps related to one secret' do
        received = @client.get_secret(@repo.id, @secret[:name])
        expect(received.name).to eq(@secret[:name])
      end
    end # .get_secret

    describe '.create_or_update_secret', :vcr do
      it 'updating existing secret returns 204' do
        box = create_box(@client.get_public_key(@repo.id))
        encrypted = box[:box].encrypt('new value')
        @client.create_or_update_secret(
          @repo.id, @secret[:name],
          key_id: box[:key_id], encrypted_value: Base64.strict_encode64(encrypted)
        )
        expect(@client.last_response.status).to eq(204)
      end
    end # .create_or_update_secret

    describe '.delete_secret', :vcr do
      it 'delete existing secret' do
        @client.delete_secret(@repo.id, @secret[:name])
        expect(@client.last_response.status).to eq(204)
      end
    end
  end
end
