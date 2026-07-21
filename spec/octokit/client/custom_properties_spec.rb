# frozen_string_literal: true

describe Octokit::Client::CustomProperties do
  before do
    Octokit.reset!
    @client = oauth_client
  end

  after do
    Octokit.reset!
  end

  describe '.get_repo_custom_properties' do
    before do
      VCR.turn_off!
      stub_request(:get, github_url("/repos/#{@test_repo}/properties/values"))
        .to_return(
          status: 200,
          body: [{ property_name: 'environment', value: 'production' }].to_json,
          headers: { content_type: 'application/json' }
        )
    end

    after do
      VCR.turn_on!
    end

    it 'returns custom property values for a repository' do
      properties = @client.get_repo_custom_properties(@test_repo)
      expect(properties).to be_kind_of Array
      assert_requested :get, github_url("/repos/#{@test_repo}/properties/values")
    end
  end # .get_repo_custom_properties

  describe '.update_repo_custom_properties' do
    before do
      VCR.turn_off!
      stub_request(:patch, github_url("/repos/#{@test_repo}/properties/values"))
        .to_return(status: 204, body: nil)
    end

    after do
      VCR.turn_on!
    end

    it 'updates custom property values for a repository' do
      properties = [{ property_name: 'environment', value: 'production' }]
      @client.update_repo_custom_properties(@test_repo, properties)
      assert_requested :patch, github_url("/repos/#{@test_repo}/properties/values")
    end
  end # .update_repo_custom_properties
end
