# frozen_string_literal: true

describe Octokit::Client::CodeScanning do
  before do
    @client = oauth_client
    @sarif_id = 'fb31fa2c-095d-11ee-98fe-c609abca1772'
  end

  describe '.upload_sarif_data', :vcr do
    it 'uploads a SARIF file' do
      commit_sha = @client.commits(@test_repo).first.sha
      sarif_upload = @client.upload_sarif_data(@test_repo, 'spec/fixtures/rubocop.sarif', commit_sha, 'refs/heads/main')
      expect(sarif_upload.id).to eq(@sarif_id)
      expect(sarif_upload.url).to eq("https://api.github.com/repos/#{@test_repo}/code-scanning/sarifs/#{@sarif_id}")
      assert_requested :post, github_url("/repos/#{@test_repo}/code-scanning/sarifs")
    end
  end

  describe '.get_sarif_upload_information', :vcr do
    it 'gets a SARIF upload information' do
      sarif_upload = @client.get_sarif_upload_information(@test_repo, @sarif_id)
      expect(sarif_upload.processing_status).to eq('complete')
      expect(sarif_upload.analyses_url).to eq("https://api.github.com/repos/#{@test_repo}/code-scanning/analyses?sarif_id=#{@sarif_id}")
      assert_requested :get, github_url("/repos/#{@test_repo}/code-scanning/sarifs/#{@sarif_id}")
    end
  end
end
