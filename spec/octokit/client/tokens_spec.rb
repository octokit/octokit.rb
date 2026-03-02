# frozen_string_literal: true

require 'securerandom'

describe Octokit::Client::Tokens do
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

  describe '.scopes', :vcr do
    it 'checks the scopes on the current token' do
      use_vcr_placeholder_for('dummytoken123456', 'SCOPE_AUTHORIZATION_TOKEN')

      token_client = Octokit::Client.new(access_token: 'dummytoken123456')

      expect(token_client.scopes).to be_kind_of Array
      assert_requested :get, github_url('/user')
    end

    it 'checks the scopes on a one-off token' do
      use_vcr_placeholder_for('dummytoken123456', 'ONE_OFF_SCOPE_AUTHORIZATION_TOKEN')

      Octokit.reset!

      expect(Octokit.scopes('dummytoken123456')).to be_kind_of Array
      assert_requested :get, github_url('/user')
    end
  end # .scopes
end
