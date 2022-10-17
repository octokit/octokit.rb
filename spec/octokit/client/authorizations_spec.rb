# frozen_string_literal: true

require 'helper'
require 'securerandom'

describe Octokit::Client::Authorizations do
  before do
    Octokit.reset!
    @client = basic_auth_client

    @app_client = Octokit::Client.new \
      client_id: test_github_client_id,
      client_secret: test_github_client_secret
  end

  after do
    Octokit.reset!
  end

  def note
    "Note #{SecureRandom.hex(20)}"
  end

  describe '.create_authorization', :vcr do
    context 'without :idempotent => true' do
      it 'creates an API authorization' do
        authorization = @client.create_authorization(note: note)
        expect(authorization.app.name).not_to be_nil
        expect(WebMock).to have_requested(:post, github_url('/authorizations')).with(
          basic_auth: [
            test_github_login,
            test_github_password
          ]
        )
      end

      it 'creates a new API authorization each time' do
        first_authorization = @client.create_authorization(note: note)
        second_authorization = @client.create_authorization(note: note)
        expect(first_authorization.id).not_to eq(second_authorization.id)
      end

      it 'creates a new authorization with options' do
        info = {
          note: note,
          scope: ['gist']
        }
        authorization = @client.create_authorization info
        expect(authorization.scopes).to be_kind_of Array
        expect(WebMock).to have_requested(:post, github_url('/authorizations')).with(
          basic_auth: [
            test_github_login,
            test_github_password
          ]
        )
      end
    end

    context 'with :idempotent => true' do
      it 'creates a new authorization with options' do
        authorization = @client.create_authorization(
          idempotent: true,
          client_id: test_github_client_id,
          client_secret: test_github_client_secret,
          scopes: %w[gist]
        )

        expect(authorization.scopes).to be_kind_of Array
        expect(WebMock).to have_requested(:put, github_url("/authorizations/clients/#{test_github_client_id}")).with(
          basic_auth: [
            test_github_login,
            test_github_password
          ]
        )
      end

      it 'creates a new authorization with fingerprint' do
        path = "/authorizations/clients/#{test_github_client_id}/jklmnop12345678"

        @client.create_authorization(
          idempotent: true,
          client_id: test_github_client_id,
          client_secret: test_github_client_secret,
          scopes: %w[gist],
          fingerprint: 'jklmnop12345678'
        )

        expect(WebMock).to have_requested(:put, github_url(path)).with(
          basic_auth: [
            test_github_login,
            test_github_password
          ]
        )
      end

      it 'returns an existing API authorization if one already exists' do
        options = {
          idempotent: true,
          client_id: test_github_client_id,
          client_secret: test_github_client_secret
        }

        first_authorization  = @client.create_authorization(options)
        second_authorization = @client.create_authorization(options)

        expect(first_authorization.id).to eql second_authorization.id
      end
    end
  end # .create_authorization

  describe '.scopes', :vcr do
    it 'checks the scopes on the current token' do
      authorization = @client.create_authorization(note: note)
      use_vcr_placeholder_for(authorization.token, 'SCOPE_AUTHORIZATION_TOKEN')

      token_client = Octokit::Client.new(access_token: authorization.token)

      expect(token_client.scopes).to be_kind_of Array
      assert_requested :get, github_url('/user')
    end

    it 'checks the scopes on a one-off token' do
      authorization = @client.create_authorization(note: note)
      use_vcr_placeholder_for(authorization.token, 'ONE_OFF_SCOPE_AUTHORIZATION_TOKEN')

      Octokit.reset!

      expect(Octokit.scopes(authorization.token)).to be_kind_of Array
      assert_requested :get, github_url('/user')
    end
  end # .scopes
end
