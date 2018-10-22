require 'helper'

describe Octokit::Client::CheckSuites do
  before do
    Octokit.reset!
    @jwt_client = Octokit::Client.new(bearer_token: new_jwt_token)
    use_vcr_placeholder_for(@jwt_client.bearer_token, '<JWT_BEARER_TOKEN>')

    installation_id = test_github_integration_installation

    VCR.use_cassette("Octokit_Client_Apps/with_app_installation/_create_app_installation_access_token/creates_an_access_token_for_the_installation") do

      token = @jwt_client.create_app_installation_access_token(installation_id, accept: integrations_preview_header)[:token]

      @client = Octokit::Client.new(bearer_token: token)
      use_vcr_placeholder_for(@client.bearer_token, '<INSTALLATION_BEARER_TOKEN>')
    end
  end

  after(:each) do
    Octokit.reset!
  end

  describe ".check_suite", :vcr do
    it "returns a check suite" do
      check_suite = @client.check_suite(@test_repo, 1)
      expect(check_suite.title).to eq("A new PR")
      assert_requested :get, github_url("/repos/#{@test_repo}/check_suites/#{@check_suite.id}")
    end
  end # .check_suite

  private

  def integrations_preview_header
    Octokit::Preview::PREVIEW_TYPES[:integrations]
  end

  def preview_header
    Octokit::Preview::PREVIEW_TYPES[:checks]
  end
end
