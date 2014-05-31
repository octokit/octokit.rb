require "helper"

describe Octokit::EnterpriseAdminClient::License do

  before do
    Octokit.reset!
    @client = enterprise_oauth_client
  end

  describe ".license", :vcr do
    it "returns information about the license" do
      license = @client.license

      expect(license.seats).to be_kind_of Fixnum
      expect(license.seats_used).to be_kind_of Fixnum
      expect(license.seats_available).to be_kind_of Fixnum
      # expect(license.kind).to be_kind_of String
      expect(license.days_until_expiration).to be_kind_of Fixnum
      expect(license.expire_at).to be_kind_of Time

      assert_requested :get, github_enterprise_url("api/v3/enterprise/settings/license")
    end
  end # .license
end
