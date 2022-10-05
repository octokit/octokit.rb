# frozen_string_literal: true

require 'helper'

describe Octokit::EnterpriseManagementConsoleClient::ManagementConsole do
  before do
    Octokit.reset!
    @enterprise_management_console_client = enterprise_management_console_client
    @license = 'spec/fixtures/github-enterprise.ghl'
    @api_key = test_github_enterprise_management_console_password
  end

  describe '.upload_license', :vcr do
    it 'uploads a license for the Enterprise installation' do
      @enterprise_management_console_client.upload_license(@license)
      expect(@enterprise_management_console_client.last_response.status).to eq(202)
      assert_requested :post, github_management_console_url('setup/api/start')
    end
  end # .upload_license

  describe '.start_configuration', :vcr do
    it 'starts a configuration process for the Enterprise installation' do
      @enterprise_management_console_client.start_configuration
      expect(@enterprise_management_console_client.last_response.status).to eq(202)
      assert_requested :post, github_management_console_url("setup/api/configure?api_key=#{@api_key}")
    end
  end # .start_configuration

  describe '.upgrade', :vcr do
    it 'upgrades the Enterprise installation' do
      @enterprise_management_console_client.upgrade(@license)

      expect(@enterprise_management_console_client.last_response.status).to eq(202)
      assert_requested :post, github_management_console_url('setup/api/upgrade')
    end
  end # .upgrade

  describe '.config_status', :vcr do
    it 'returns information about the installation' do
      config = @enterprise_management_console_client.config_status

      expect(config.status).to be_kind_of String
      expect(config.progress).to be_kind_of Array
      expect(config.progress.first[:key]).to be_kind_of String
      expect(config.progress.first[:status]).to be_kind_of String

      assert_requested :get, github_management_console_url("setup/api/configcheck?api_key=#{@api_key}")
    end
  end # .config_status

  describe '.settings', :vcr do
    it 'returns information about the Enterprise settings' do
      settings = @enterprise_management_console_client.settings.to_hash

      expect(settings[:enterprise][:configuration_id]).to be_kind_of Numeric
      expect(settings[:enterprise][:customer][:name]).to be_kind_of String
      expect(settings[:run_list].first).to be_kind_of String

      expect(@enterprise_management_console_client.last_response.status).to eq(200)
      assert_requested :get, github_management_console_url("setup/api/settings?api_key=#{@api_key}")
    end
  end # .settings

  describe '.edit_settings', :vcr do
    it 'edits the Enterprise settings' do
      settings = { enterprise: { customer: { name: 'Jean-Luc Picard' } } }
      @enterprise_management_console_client.edit_settings settings

      expect(@enterprise_management_console_client.last_response.status).to eq(204)
      assert_requested :put, github_management_console_url("setup/api/settings?api_key=#{@api_key}&settings=%7B%22enterprise%22:%7B%22customer%22:%7B%22name%22:%22Jean-Luc%20Picard%22%7D%7D%7D")
    end
  end # .edit_settings

  describe '.maintenance_status', :vcr do
    it 'returns information about the Enterprise maintenance status' do
      maintenance_status = @enterprise_management_console_client.maintenance_status

      expect(maintenance_status[:status]).to be_kind_of String
      expect(maintenance_status[:connection_services]).to be_kind_of Array

      assert_requested :get, github_management_console_url("setup/api/maintenance?api_key=#{@api_key}")
    end
  end # .maintenance_status

  describe '.set_maintenance_status', :vcr do
    it 'enables the Enterprise maintenance mode' do
      maintenance = { enabled: true, when: 'now' }
      maintenance_status = @enterprise_management_console_client.set_maintenance_status(maintenance)

      expect(maintenance_status[:status]).to match('on')

      assert_requested :post, github_management_console_url("setup/api/maintenance?api_key=#{@api_key}&maintenance=%7B%22enabled%22:true,%22when%22:%22now%22%7D")
    end
  end # .set_maintenance_status

  describe '.authorized_keys', :vcr do
    it 'gets the authorized SSH keys ' do
      authorized_keys = @enterprise_management_console_client.authorized_keys

      expect(authorized_keys).to be_kind_of Array
      expect(authorized_keys.first['key']).to be_kind_of String
      expect(authorized_keys.first['pretty-print']).to be_kind_of String

      assert_requested :get, github_management_console_url("setup/api/settings/authorized-keys?api_key=#{@api_key}")
    end
  end # .authorized_keys

  describe '.add_authorized_key', :vcr do
    it 'adds a new authorized SSH keys (via a file path)' do
      key = 'spec/fixtures/fake_key.pub'
      authorized_keys = @enterprise_management_console_client.add_authorized_key(key)

      expect(authorized_keys).to be_kind_of Array
      expect(authorized_keys.length).to match(2)
      expect(authorized_keys.first['key']).to be_kind_of String
      expect(authorized_keys.first['pretty-print']).to be_kind_of String

      assert_requested :post, github_management_console_url("setup/api/settings/authorized-keys?authorized_key=ssh-rsa%20AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA&api_key=#{@api_key}")
    end

    it 'adds a new authorized SSH keys (via a File handler)' do
      key = File.new('spec/fixtures/fake_key2.pub', 'r')
      authorized_keys = @enterprise_management_console_client.add_authorized_key(key)

      expect(authorized_keys).to be_kind_of Array
      expect(authorized_keys.length).to match(2)
      expect(authorized_keys.first['key']).to be_kind_of String
      expect(authorized_keys.first['pretty-print']).to be_kind_of String

      assert_requested :post, github_management_console_url("setup/api/settings/authorized-keys?api_key=#{@api_key}&authorized_key=ssh-rsa%20AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA")
    end

    it 'adds a new authorized SSH keys (via a string contents)' do
      key = 'ssh-rsa AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA'
      authorized_keys = @enterprise_management_console_client.add_authorized_key(key)

      expect(authorized_keys).to be_kind_of Array
      expect(authorized_keys.length).to match(3)
      expect(authorized_keys.first['key']).to be_kind_of String
      expect(authorized_keys.first['pretty-print']).to be_kind_of String

      assert_requested :post, github_management_console_url("setup/api/settings/authorized-keys?api_key=#{@api_key}&authorized_key=ssh-rsa%20AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA")
    end
  end # .add_authorized_key

  describe '.remove_authorized_key', :vcr do
    it 'removes a new authorized SSH keys (via a file path)' do
      key = 'spec/fixtures/fake_key.pub'
      authorized_keys = @enterprise_management_console_client.remove_authorized_key(key)

      expect(authorized_keys).to be_kind_of Array
      expect(authorized_keys.length).to match(3)
      expect(authorized_keys.first['key']).to be_kind_of String
      expect(authorized_keys.first['pretty-print']).to be_kind_of String

      assert_requested :delete, github_management_console_url("setup/api/settings/authorized-keys?authorized_key=ssh-rsa%20AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA&api_key=#{@api_key}")
    end

    it 'removes a new authorized SSH keys (via a File handler)' do
      key = File.new('spec/fixtures/fake_key2.pub', 'r')
      authorized_keys = @enterprise_management_console_client.remove_authorized_key(key)

      expect(authorized_keys).to be_kind_of Array
      expect(authorized_keys.length).to match(2)
      expect(authorized_keys.first['key']).to be_kind_of String
      expect(authorized_keys.first['pretty-print']).to be_kind_of String

      assert_requested :delete, github_management_console_url("setup/api/settings/authorized-keys?authorized_key=ssh-rsa%20AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA&api_key=#{@api_key}")
    end

    it 'removes a new authorized SSH keys (via a string contents)' do
      key = 'ssh-rsa AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA'
      authorized_keys = @enterprise_management_console_client.remove_authorized_key(key)

      expect(authorized_keys).to be_kind_of Array
      expect(authorized_keys.length).to match(2)
      expect(authorized_keys.first['key']).to be_kind_of String
      expect(authorized_keys.first['pretty-print']).to be_kind_of String

      assert_requested :delete, github_management_console_url("setup/api/settings/authorized-keys?authorized_key=ssh-rsa%20AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA&api_key=#{@api_key}")
    end
  end # .remove_authorized_key
end
