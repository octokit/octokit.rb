require "helper"

describe Octokit::EnterpriseAdminClient::License do

  before do
    Octokit.reset!
    @admin_client = enterprise_admin_client
  end

  describe ".license_info", :vcr do
    it "returns information about the license" do
      license = @admin_client.license_info

      expect(license.seats_used).to be_kind_of Integer
      expect(license.kind).to be_kind_of String
      expect(license.days_until_expiration).to be_kind_of Integer
      expect(license.expire_at).to be_kind_of Time

      assert_requested :get, github_enterprise_url("enterprise/settings/license")
    end
  end # .license
end
