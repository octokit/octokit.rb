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

  describe '.authorizations', :vcr do
    it 'lists existing authorizations' do
      authorizations = @client.authorizations
      expect(authorizations).to be_kind_of Array
      expect(WebMock).to have_requested(:get, github_url('/authorizations')).with(
        basic_auth: [
          test_github_login,
          test_github_password
        ]
      )
    end
  end # .authorizations

  describe '.authorization', :vcr do
    it 'returns a single authorization' do
      authorization = @client.create_authorization(note: note)
      @client.authorization(authorization['id'])

      expect(WebMock).to have_requested(:get, github_url("/authorizations/#{authorization.id}")).with(
        basic_auth: [
          test_github_login,
          test_github_password
        ]
      )
    end
  end # .authorization

  describe '.update_authorization', :vcr do
    it 'updates and existing authorization' do
      authorization = @client.create_authorization(note: note)
      updated       = @client.update_authorization(authorization.id, add_scopes: ['repo:status'])

      expect(updated.scopes).to include('repo:status')
      expect(WebMock).to have_requested(:patch, github_url("/authorizations/#{authorization.id}")).with(
        basic_auth: [
          test_github_login,
          test_github_password
        ]
      )
    end
  end # .update_authorization

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

  describe '.delete_authorization', :vcr do
    it 'deletes an existing authorization' do
      authorization = @client.create_authorization(note: note)
      result        = @client.delete_authorization(authorization.id)

      expect(result).to be_truthy
      expect(WebMock).to have_requested(:delete, github_url("/authorizations/#{authorization.id}")).with(
        basic_auth: [
          test_github_login,
          test_github_password
        ]
      )
    end
  end # .delete_authorization

  describe '.authorize_url' do
    context 'with preconfigured client credentials' do
      it 'returns the authorize_url' do
        Octokit.configure do |c|
          c.client_id = 'id_here'
          c.client_secret = 'secret_here'
        end

        url = Octokit.authorize_url
        expect(url).to eq('https://github.com/login/oauth/authorize?client_id=id_here')
      end
    end

    context 'with passed client credentials' do
      it 'returns the authorize_url' do
        url = Octokit.authorize_url('id_here')
        expect(url).to eq('https://github.com/login/oauth/authorize?client_id=id_here')
      end
    end
    it 'requires client_id and client_secret' do
      Octokit.reset!
      expect do
        Octokit.authorize_url
      end.to raise_error Octokit::ApplicationCredentialsRequired
    end
    context 'with passed options hash' do
      it 'appends options hash as query params' do
        url = Octokit.authorize_url('id_here', redirect_uri: 'git.io', scope: 'user')
        expect(url).to eq('https://github.com/login/oauth/authorize?client_id=id_here&redirect_uri=git.io&scope=user')
      end
      it 'escapes values before adding to query params' do
        uri = Octokit.authorize_url('id_here', redirect_uri: 'http://git.io')
        expect(uri).to eq('https://github.com/login/oauth/authorize?client_id=id_here&redirect_uri=http%3A%2F%2Fgit.io')
        scope = Octokit.authorize_url('id_here', scope: 'repo:status')
        expect(scope).to eq('https://github.com/login/oauth/authorize?client_id=id_here&scope=repo%3Astatus')
      end
    end
  end # .authorize_url

  describe '.revoke_all_application_authorizations' do
    before do
      allow(@app_client).to receive(:octokit_warn)
    end

    it 'returns false' do
      path = "/applications/#{test_github_client_id}/tokens"

      stub_request(:delete, github_url(path)).with(
        basic_auth: [
          test_github_client_id,
          test_github_client_secret
        ]
      ).to_return(status: 204)

      result = @app_client.revoke_all_application_authorizations
      expect(result).not_to be

      expect(@app_client).to have_received(:octokit_warn)
        .with('Deprecated: If you need to revoke all tokens for your application, you can do so via the settings page for your application.')
    end
  end # .revoke_all_application_authorizations

  def preview_header
    Octokit::Preview::PREVIEW_TYPES[:applications_api]
  end
end
