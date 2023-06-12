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
end
