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

  describe '.check_token', :vcr do
    it 'checks the token is valid' do
      @app_client.check_token(@access_token, accept: Octokit::Preview::PREVIEW_TYPES[:applications_api])
      path = "/applications/#{test_github_client_id}/token"

      expect(WebMock).to have_requested(:post, github_url(path)).with(
        basic_auth: [test_github_client_id, test_github_client_secret],
      )
    end

    it 'has a .check_application_authorization alias' do
      @app_client.check_application_authorization(@access_token, accept: Octokit::Preview::PREVIEW_TYPES[:applications_api])
      path = "/applications/#{test_github_client_id}/token"

      expect(WebMock).to have_requested(:post, github_url(path)).with(
        basic_auth: [test_github_client_id, test_github_client_secret],
      )
    end
  end

  describe '.reset_token', :vcr do
    it 'resets the token' do
      @app_client.reset_token(@access_token, accept: Octokit::Preview::PREVIEW_TYPES[:applications_api])
      path = "/applications/#{test_github_client_id}/token"

      expect(WebMock).to have_requested(:patch, github_url(path)).with(
        basic_auth: [test_github_client_id, test_github_client_secret],
      )
    end

    it 'has a .reset_application_authorization alias' do
      @app_client.reset_application_authorization(@access_token, accept: Octokit::Preview::PREVIEW_TYPES[:applications_api])
      path = "/applications/#{test_github_client_id}/token"

      expect(WebMock).to have_requested(:patch, github_url(path)).with(
        basic_auth: [test_github_client_id, test_github_client_secret],
      )
    end
  end

  describe '.delete_app_token', :vcr do
    it 'deletes the token' do
      @app_client.delete_app_token(@access_token, accept: Octokit::Preview::PREVIEW_TYPES[:applications_api])
      path = "/applications/#{test_github_client_id}/token"

      expect(WebMock).to have_requested(:delete, github_url(path)).with(
        basic_auth: [test_github_client_id, test_github_client_secret],
      )
    end

    it 'has a .delete_application_authorization alias' do
      @app_client.delete_application_authorization(@access_token, accept: Octokit::Preview::PREVIEW_TYPES[:applications_api])
      path = "/applications/#{test_github_client_id}/token"

      expect(WebMock).to have_requested(:delete, github_url(path)).with(
        basic_auth: [test_github_client_id, test_github_client_secret],
      )
    end

    it 'has a .revoke_application_authorization alias' do
      @app_client.revoke_application_authorization(@access_token, accept: Octokit::Preview::PREVIEW_TYPES[:applications_api])
      path = "/applications/#{test_github_client_id}/token"

      expect(WebMock).to have_requested(:delete, github_url(path)).with(
        basic_auth: [test_github_client_id, test_github_client_secret],
      )
    end
  end

  describe '.delete_app_authorization', :vcr do
    it "revokes the app's access to the user" do
      @app_client.delete_app_authorization(@access_token, accept: Octokit::Preview::PREVIEW_TYPES[:applications_api])
      path = "/applications/#{test_github_client_id}/grant"

      expect(WebMock).to have_requested(:delete, github_url(path)).with(
        basic_auth: [test_github_client_id, test_github_client_secret],
      )
    end
  end
end
