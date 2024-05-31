# frozen_string_literal: true

describe Octokit::Client::CodeScanning do
  before do
    @client = oauth_client
    @sarif_id = 'fb31fa2c-095d-11ee-98fe-c609abca1772'
    @test_repo = "caja-de-dano/active-wrapper"
  end

  describe '.list_code_scanning_alerts_for_org', :vcr do
    it 'lists code scanning alerts for an organization' do
      scanning_alerts = @client.list_code_scanning_alerts_for_org("caja-de-dano")
      assert_requested :get, github_url("/orgs/caja-de-dano/code-scanning/alerts")
    end
  end

  describe '.list_code_scanning_alerts_for_repository', :vcr do
    it 'lists code scanning alerts for a repository' do
      scanning_alerts = @client.list_code_scanning_alerts_for_repository("caja-de-dano/active-wrapper")
      assert_requested :get, github_url("/repos/caja-de-dano/active-wrapper/code-scanning/alerts")
    end
  end

  describe '.get_code_scanning_alert', :vcr do
    it 'gets a code scanning alert by alert number' do
      alert = @client.get_code_scanning_alert("caja-de-dano/active-wrapper", 1)
      expect(alert["rule"]["id"]).to eq('py/clear-text-logging-sensitive-data')
      assert_requested :get, github_url("/repos/caja-de-dano/active-wrapper/code-scanning/alerts/1")
    end
  end

  describe '.update_code_scanning_alert', :vcr do
    it 'updates a status of a single code scanning alert' do
      alert = @client.update_code_scanning_alert(@test_repo, 1, 'dismissed', "won't fix", 'Test comment')
      expect(alert["state"]).to eq('dismissed')
      assert_requested :patch, github_url("/repos/#{@test_repo}/code-scanning/alerts/1")
    end
  end

  describe '.list_instances_of_code_scanning_alert', :vcr do
    it 'lists all instances of the specified code scanning alert' do
      instances = @client.list_instances_of_code_scanning_alert(@test_repo, 1)
      assert_requested :get, github_url("/repos/#{@test_repo}/code-scanning/alerts/1/instances")
    end
  end

  describe '.list_code_scanning_analysis', :vcr do
    it 'lists code scanning analyses for a repository' do
      analyses = @client.list_code_scanning_analysis(@test_repo)
      assert_requested :get, github_url("/repos/#{@test_repo}/code-scanning/analyses")
    end
  end

  describe '.get_code_scanning_analysis', :vcr do
    it 'gets a specific code scanning analysis for a repo' do
      analysis = @client.get_code_scanning_analysis(@test_repo, 220148743)
      expect(analysis.id).to eq(220148743)
      assert_requested :get, github_url("/repos/#{@test_repo}/code-scanning/analyses/220148743")
    end
  end

  describe '.delete_code_scanning_analysis', :vcr do
    it 'deletes a code scanning analysis' do
      analysis = @client.delete_code_scanning_analysis(@test_repo, 223527352)
      #expect(analysis.id).to eq(223527352)
      assert_requested :delete, github_url("/repos/#{@test_repo}/code-scanning/analyses/223527352")
    end
  end

  describe '.list_codeql_database_for_repo', :vcr do
    it 'lists the codeql databases that are available in a repo' do
      databases = @client.list_codeql_database_for_repo(@test_repo)
      assert_requested :get, github_url("/repos/#{@test_repo}/code-scanning/codeql/databases")
    end
  end

  describe '.get_codeql_database_for_repo', :vcr do
    it 'gets a CodeQL database for a language in a repository' do
      database = @client.get_codeql_database_for_repo(@test_repo, 'python')
      expect(database.id).to eq('python')
      assert_requested :get, github_url("/repos/#{@test_repo}/code-scanning/codeql/databases/python")
    end
  end

  #describe '.create_codeql_variant_analysis', :vcr do
    #it 'creates a new CodeQL variant analysis' do
      #analysis = @client.create_codeql_variant_analysis(@test_repo, 'ruby', 'main')
      #expect(analysis.status).to eq('queued')
      #assert_requested :post, github_url("/repos/#{@test_repo}/code-scanning/codeql/queries")
    #end
  #end

  #describe '.get_codeql_variant_analysis_summary', :vcr do
    #it 'gets the summary of a CodeQL variant analysis' do
      #analysis_summary = @client.get_codeql_variant_analysis_summary(@test_repo, 'ruby', 'main')
      #expect(analysis_summary.status).to eq('queued')
      #assert_requested :get, github_url("/repos/#{@test_repo}/code-scanning/codeql/queries/ruby/main")
    #end
  #end

  #describe '.get_codeql_variant_analysis_status', :vcr do
    #it 'gets the analysis status of a repo in a CodeQL variant' do
      #analysis_status = @client.get_codeql_variant_analysis_status(@test_repo, 'ruby', 'main')
      #expect(analysis_status.status).to eq('queued')
      #assert_requested :get, github_url("/repos/#{@test_repo}/code-scanning/codeql/queries/ruby/main/status")
    #end
  #end

  describe '.get_code_scanning_default_config', :vcr do
    it 'gets the default code scanning configuration for a repository' do
      default_config = @client.get_code_scanning_default_config(@test_repo)
      expect(default_config.state).to eq("configured")
      assert_requested :get, github_url("/repos/#{@test_repo}/code-scanning/default-setup")
    end
  end

  describe '.update_code_scanning_default_config', :vcr do
    it 'updates the default code scanning configuration for a repository' do
      default_config = @client.update_code_scanning_default_config(@test_repo, "not-configured")
      #expect(default_config.analysis_enabled).to eq(false)
      assert_requested :patch, github_url("/repos/#{@test_repo}/code-scanning/default-setup")
    end
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
