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
  end # .license
end
