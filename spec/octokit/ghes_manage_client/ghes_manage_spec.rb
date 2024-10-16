# frozen_string_literal: true

describe Octokit::ManageGHESClient::ManageAPI do
  before do
    Octokit.reset!
    @manage_ghes = manage_ghes_client
    @license = 'spec/fixtures/github-enterprise.ghl'
  end

  describe '.maintenance_mode', :vcr do
    it 'get maintenance mode' do
      @manage_ghes.maintenance_mode
      expect(@manage_ghes.last_response.status).to eq(200)
      expect(@manage_ghes.last_response.body).to be_kind_of Array
      expect(@manage_ghes.last_response.body.first['status']).to be_kind_of String
      assert_requested :get, github_manage_ghes_url('/manage/v1/maintenance')
    end
  end # .maintenance_mode

  describe '.set_maintenance_mode', :vcr do
    it 'enable maintenance mode' do
      @manage_ghes.set_maintenance_mode(true)
      expect(@manage_ghes.last_response.status).to eq(200)
      expect(@manage_ghes.last_response.body.first['message']).to eq('maintenance mode enabled')
      assert_requested :post, github_manage_ghes_url('/manage/v1/maintenance')
    end
    it 'disable maintenance mode' do
      @manage_ghes.set_maintenance_mode(false)
      expect(@manage_ghes.last_response.status).to eq(200)
      expect(@manage_ghes.last_response.body.first['message']).to eq('maintenance mode disabled')
      assert_requested :post, github_manage_ghes_url('/manage/v1/maintenance')
    end
  end # .set_maintenance_mode

  describe '.upload_license', :vcr do
    it 'upload a new license' do
      @manage_ghes.upload_license(@license)
      expect(@manage_ghes.last_response.status).to eq(202)
      assert_requested :post, github_manage_ghes_url('/manage/v1/config/init')
    end

    it 'raises an error if the faraday-multipart gem is not installed' do
      middleware_key = :multipart
      middleware = Faraday::Request.unregister_middleware(middleware_key)

      expect { @manage_ghes.upload_license(@license) }.to raise_error Faraday::Error
    ensure
      Faraday::Request.register_middleware(middleware_key => middleware) if middleware
    end
  end # .upload_license

  describe '.start_configuration', :vcr do
    it 'start a ghe-config-apply' do
      @manage_ghes.start_configuration
      expect(@manage_ghes.last_response.status).to eq(200)
      expect(@manage_ghes.last_response.body['run_id']).to be_kind_of String
      assert_requested :post, github_manage_ghes_url('/manage/v1/config/apply')
    end
  end # .start_configuration

  describe '.config_status', :vcr do
    it 'get ghe-config-apply status' do
      @manage_ghes.config_status
      expect(@manage_ghes.last_response.status).to eq(200)
      expect(@manage_ghes.last_response.body['run_id']).to be_kind_of String
      expect(@manage_ghes.last_response.body['nodes']).to be_kind_of Array
      assert_requested :get, github_manage_ghes_url('/manage/v1/config/apply')
    end
  end # .config_status

  describe '.settings', :vcr do
    it 'get settings' do
      @manage_ghes.settings
      expect(@manage_ghes.last_response.status).to eq(200)
      expect(@manage_ghes.last_response.body).to be_kind_of Hash
      expect(@manage_ghes.last_response.body['abuse_rate_limiting']['requests_per_minute']).to be_kind_of Integer
      assert_requested :get, github_manage_ghes_url('/manage/v1/config/settings')
    end
  end # .settings

  describe '.edit_settings', :vcr do
    it 'set settings' do
      @manage_ghes.edit_settings({ 'abuse_rate_limiting' => { 'requests_per_minute' => 901 } })
      expect(@manage_ghes.last_response.status).to eq(204)
      assert_requested :put, github_manage_ghes_url('/manage/v1/config/settings')
    end
  end # .edit_settings

  describe '.authorized_keys', :vcr do
    it 'get authorized keys' do
      @manage_ghes.authorized_keys
      expect(@manage_ghes.last_response.status).to eq(200)
      expect(@manage_ghes.last_response.body).to be_kind_of Array
      expect(@manage_ghes.last_response.body.first['key']).to be_kind_of String
      assert_requested :get, github_manage_ghes_url('/manage/v1/access/ssh')
    end
  end # .authorized_keys

  describe '.add_authorized_key', :vcr do
    it 'adds a new authorized SSH keys (via a file path)' do
      key = 'spec/fixtures/fake_key.pub'
      @manage_ghes.add_authorized_key(key)

      expect(@manage_ghes.last_response.status).to eq(200)
      expect(@manage_ghes.last_response.body.first['message']).to eq('SSH key added successfully')

      assert_requested :post, github_manage_ghes_url('/manage/v1/access/ssh')
    end
  end # .add_authorized_key

  describe '.remove_authorized_key', :vcr do
    it 'delete an authorized SSH key (via a file path)' do
      key = 'spec/fixtures/fake_key.pub'
      @manage_ghes.remove_authorized_key(key)

      expect(@manage_ghes.last_response.status).to eq(200)
      expect(@manage_ghes.last_response.body.first['message']).to eq('SSH key removed successfully')

      assert_requested :delete, github_manage_ghes_url('/manage/v1/access/ssh')
    end
  end # .remove_authorized_key
end
