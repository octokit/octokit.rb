require "helper"

describe Octokit::EnterpriseAdminClient::ManagementConsole do

  before do
    Octokit.reset!
    @client = enterprise_oauth_client
  end

  describe ".config_status", :vcr do
    it "returns information about the installation" do
      config = @client.config_status

      expect(config.status).to be_kind_of String
      expect(config.progress).to be_kind_of Array
      expect(config.progress.first[:key]).to be_kind_of String
      expect(config.progress.first[:status]).to be_kind_of String

      assert_requested :get, github_enterprise_url("setup/api/configcheck?license_md5=#{test_github_enterprise_license_md5}")
    end
  end # .config_status

  describe ".settings", :vcr do
    it "returns information about the Enterprise settings" do
      settings = JSON.parse @client.settings
      expect(settings["enterprise"]).to be_kind_of Hash
      expect(settings["enterprise"]["customer"]["name"]).to be_kind_of String
      expect(settings["run_list"].first).to be_kind_of String

      assert_requested :get, github_enterprise_url("setup/api/settings?license_md5=#{test_github_enterprise_license_md5}")
    end
  end # .settings

  describe ".maintenance_status", :vcr do
    it "returns information about the Enterprise maintenance status" do
      maintenance_status = @client.maintenance_status

      expect(maintenance_status[:status]).to be_kind_of String
      expect(maintenance_status[:connection_services]).to be_kind_of Array

      assert_requested :get, github_enterprise_url("setup/api/maintenance?license_md5=#{test_github_enterprise_license_md5}")
    end
  end # .maintenance_status
end
