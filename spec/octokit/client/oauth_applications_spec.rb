# frozen_string_literal: true

require 'helper'
require 'securerandom'

# Right now until we come up with a better way we have to make these tokens
# by hand because the Authorizations API is going away.
#
# See https://developer.github.com/changes/2019-11-05-deprecated-passwords-and-authorizations-api/
describe Octokit::Client::OauthApplications do
  before do
    Octokit.reset!

    @app_client = Octokit::Client.new(
      client_id: test_github_client_id,
      client_secret: test_github_client_secret
    )

    @access_token = test_github_oauth_token
  end

  after do
    Octokit.reset!
  end

  describe '.check_token' do
    it 'checks the token is valid', :vcr do
      @app_client.check_token(@access_token, accept: Octokit::Preview::PREVIEW_TYPES[:applications_api])
      path = "/applications/#{test_github_client_id}/token"

      expect(WebMock).to have_requested(:post, github_url(path)).with(
        basic_auth: [test_github_client_id, test_github_client_secret]
      )
    end

    it 'has a .check_application_authorization alias', :vcr do
      @app_client.check_application_authorization(@access_token, accept: Octokit::Preview::PREVIEW_TYPES[:applications_api])
      path = "/applications/#{test_github_client_id}/token"

      expect(WebMock).to have_requested(:post, github_url(path)).with(
        basic_auth: [test_github_client_id, test_github_client_secret]
      )
    end

    it 'works in Enterprise mode' do
      api_endpoint  = 'https://gh-enterprise.com/api/v3'
      client_id     = 'abcde12345fghij67890'
      client_secret = 'abcdabcdabcdabcdabcdabcdabcdabcdabcdabcd'
      token         = '25f94a2a5c7fbaf499c665bc73d67c1c87e496da8985131633ee0a95819db2e8'

      path = File.join(api_endpoint, "/applications/#{client_id}/token")

      client = Octokit::Client.new(
        client_id: client_id,
        client_secret: client_secret,
        api_endpoint: api_endpoint
      )

      request = stub_request(:post, path).with(basic_auth: [client_id, client_secret])
      client.check_token(token, accept: Octokit::Preview::PREVIEW_TYPES[:applications_api])

      assert_requested request
    end
  end # .check_token

  describe '.reset_token' do
    it 'resets the token', :vcr do
      @app_client.reset_token(@access_token, accept: Octokit::Preview::PREVIEW_TYPES[:applications_api])
      path = "/applications/#{test_github_client_id}/token"

      expect(WebMock).to have_requested(:patch, github_url(path)).with(
        basic_auth: [test_github_client_id, test_github_client_secret]
      )
    end

    it 'has a .reset_application_authorization alias', :vcr do
      @app_client.reset_application_authorization(@access_token, accept: Octokit::Preview::PREVIEW_TYPES[:applications_api])
      path = "/applications/#{test_github_client_id}/token"

      expect(WebMock).to have_requested(:patch, github_url(path)).with(
        basic_auth: [test_github_client_id, test_github_client_secret]
      )
    end

    it 'works in Enterprise mode' do
      api_endpoint  = 'https://gh-enterprise.com/api/v3'
      client_id     = 'abcde12345fghij67890'
      client_secret = 'abcdabcdabcdabcdabcdabcdabcdabcdabcdabcd'
      token         = '25f94a2a5c7fbaf499c665bc73d67c1c87e496da8985131633ee0a95819db2e8'

      path = File.join(api_endpoint, "/applications/#{client_id}/token")

      client = Octokit::Client.new(
        client_id: client_id,
        client_secret: client_secret,
        api_endpoint: api_endpoint
      )

      request = stub_request(:patch, path).with(basic_auth: [client_id, client_secret])
      client.reset_token(token, accept: Octokit::Preview::PREVIEW_TYPES[:applications_api])

      assert_requested request
    end
  end # .reset_token

  describe '.delete_app_token' do
    it 'deletes the token', :vcr do
      @app_client.delete_app_token(@access_token, accept: Octokit::Preview::PREVIEW_TYPES[:applications_api])
      path = "/applications/#{test_github_client_id}/token"

      expect(WebMock).to have_requested(:delete, github_url(path)).with(
        basic_auth: [test_github_client_id, test_github_client_secret]
      )
    end

    it 'has a .delete_application_authorization alias', :vcr do
      @app_client.delete_application_authorization(@access_token, accept: Octokit::Preview::PREVIEW_TYPES[:applications_api])
      path = "/applications/#{test_github_client_id}/token"

      expect(WebMock).to have_requested(:delete, github_url(path)).with(
        basic_auth: [test_github_client_id, test_github_client_secret]
      )
    end

    it 'has a .revoke_application_authorization alias', :vcr do
      @app_client.revoke_application_authorization(@access_token, accept: Octokit::Preview::PREVIEW_TYPES[:applications_api])
      path = "/applications/#{test_github_client_id}/token"

      expect(WebMock).to have_requested(:delete, github_url(path)).with(
        basic_auth: [test_github_client_id, test_github_client_secret]
      )
    end

    it 'works in Enterprise mode' do
      api_endpoint  = 'https://gh-enterprise.com/api/v3'
      client_id     = 'abcde12345fghij67890'
      client_secret = 'abcdabcdabcdabcdabcdabcdabcdabcdabcdabcd'
      token         = '25f94a2a5c7fbaf499c665bc73d67c1c87e496da8985131633ee0a95819db2e8'

      path = File.join(api_endpoint, "/applications/#{client_id}/token")

      client = Octokit::Client.new(
        client_id: client_id,
        client_secret: client_secret,
        api_endpoint: api_endpoint
      )

      request = stub_request(:delete, path).with(basic_auth: [client_id, client_secret])
      client.delete_app_token(token, accept: Octokit::Preview::PREVIEW_TYPES[:applications_api])

      assert_requested request
    end
  end # .delete_app_token

  describe '.delete_app_authorization', :vcr do
    it "revokes the app's access to the user" do
      @app_client.delete_app_authorization(@access_token, accept: Octokit::Preview::PREVIEW_TYPES[:applications_api])
      path = "/applications/#{test_github_client_id}/grant"

      expect(WebMock).to have_requested(:delete, github_url(path)).with(
        basic_auth: [test_github_client_id, test_github_client_secret]
      )
    end
  end
end
