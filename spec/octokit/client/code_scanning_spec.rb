# frozen_string_literal: true

describe Octokit::Client::CodeScanning do
  before do
    @client = oauth_client
    @sarif_id = 'fb31fa2c-095d-11ee-98fe-c609abca1772'
    @code_scanning_test_repo = 'Caja-de-Dano/active-wrapper'
  end

  describe '.list_code_scanning_alerts_for_org', :vcr do
    it 'lists code scanning alerts for an organization' do
      scanning_alerts = @client.list_code_scanning_alerts_for_org('caja-de-dano')
      expect(scanning_alerts).to be_kind_of Array
      expect(scanning_alerts.first.state).to eq('open')
      assert_requested :get, github_url('/orgs/caja-de-dano/code-scanning/alerts')
    end
  end

  describe '.list_code_scanning_alerts_for_repository', :vcr do
    it 'lists code scanning alerts for a repository' do
      scanning_alerts = @client.list_code_scanning_alerts_for_repo(@code_scanning_test_repo)
      expect(scanning_alerts).to be_kind_of Array
      assert_requested :get, github_url("/repos/#{@code_scanning_test_repo}/code-scanning/alerts")
    end
  end

  describe '.get_code_scanning_alert', :vcr do
    it 'gets a code scanning alert by alert number' do
      alert = @client.get_code_scanning_alert(@code_scanning_test_repo, 1)
      expect(alert.rule.id).to eq('py/clear-text-logging-sensitive-data')
      assert_requested :get, github_url("/repos/#{@code_scanning_test_repo}/code-scanning/alerts/1")
    end
  end

  describe '.update_code_scanning_alert', :vcr do
    it 'updates a status of a single code scanning alert' do
      alert = @client.update_code_scanning_alert(@code_scanning_test_repo, 1, 'dismissed', "won't fix", 'Test comment')
      expect(alert.state).to eq('dismissed')
      assert_requested :patch, github_url("/repos/#{@code_scanning_test_repo}/code-scanning/alerts/1")
    end
  end

  describe '.list_instances_of_code_scanning_alert', :vcr do
    it 'lists all instances of the specified code scanning alert' do
      instances = @client.list_instances_of_code_scanning_alert(@code_scanning_test_repo, 1)
      expect(instances).to be_kind_of Array
      expect(instances.first.state).to eq('open')
      assert_requested :get, github_url("/repos/#{@code_scanning_test_repo}/code-scanning/alerts/1/instances")
    end
  end

  describe '.list_code_scanning_analysis', :vcr do
    it 'lists code scanning analyses for a repository' do
      analyses = @client.list_code_scanning_analysis(@code_scanning_test_repo)
      expect(analyses).to be_kind_of Array
      assert_requested :get, github_url("/repos/#{@code_scanning_test_repo}/code-scanning/analyses")
    end
  end

  describe '.get_code_scanning_analysis', :vcr do
    it 'gets a specific code scanning analysis for a repo' do
      analysis = @client.get_code_scanning_analysis(@code_scanning_test_repo, 225_379_147)
      expect(analysis.tool.name).to eq('CodeQL')
      expect(analysis.id).to eq(225_379_147)
      assert_requested :get, github_url("/repos/#{@code_scanning_test_repo}/code-scanning/analyses/225379147")
    end
  end

  describe '.delete_code_scanning_analysis', :vcr do
    it 'deletes a code scanning analysis' do
      analysis = @client.delete_code_scanning_analysis(@code_scanning_test_repo, 225_379_147)
      expect(analysis.confirm_delete_url).to eq("#{analysis.next_analysis_url}?confirm_delete")
      assert_requested :delete, github_url("/repos/#{@code_scanning_test_repo}/code-scanning/analyses/225379147")
    end
  end

  describe '.list_codeql_database_for_repo', :vcr do
    it 'lists the codeql databases that are available in a repo' do
      databases = @client.list_codeql_database_for_repo(@code_scanning_test_repo)
      expect(databases).to be_kind_of Array
      expect(databases.first.language).to eq('python')
      assert_requested :get, github_url("/repos/#{@code_scanning_test_repo}/code-scanning/codeql/databases")
    end
  end

  describe '.get_codeql_database_for_repo', :vcr do
    it 'gets a CodeQL database for a language in a repository' do
      database = @client.get_codeql_database_for_repo(@code_scanning_test_repo, 'python')
      expect(database.language).to eq('python')
      assert_requested :get, github_url("/repos/#{@code_scanning_test_repo}/code-scanning/codeql/databases/python")
    end
  end

  describe '.get_code_scanning_default_config', :vcr do
    it 'gets the default code scanning configuration for a repository' do
      default_config = @client.get_code_scanning_default_config(@code_scanning_test_repo)
      expect(default_config.state).to eq('configured')
      expect(default_config.query_suite).to eq('default')
      expect(default_config.languages).to eq(['python'])
      assert_requested :get, github_url("/repos/#{@code_scanning_test_repo}/code-scanning/default-setup")
    end
  end

  describe '.update_code_scanning_default_config', :vcr do
    it 'updates the default code scanning configuration for a repository' do
      default_config = @client.update_code_scanning_default_config(@code_scanning_test_repo, 'configured')
      expect(default_config.run_id).to be_kind_of Integer
      expect(default_config.run_url).to eq("https://api.github.com/repos/#{@code_scanning_test_repo}/actions/runs/#{default_config.run_id}")
      assert_requested :patch, github_url("/repos/#{@code_scanning_test_repo}/code-scanning/default-setup")
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
