require "helper"

describe Octokit::EnterpriseAdminClient::Users do

  before do
    Octokit.reset!
    @admin_client = enterprise_admin_client
  end

  describe ".promote", :vcr do
    it "promotes an ordinary user to a site administrator" do
      @admin_client.promote("pengwynn")
      assert_requested :put, github_enterprise_url("users/pengwynn/site_admin")
    end
  end # .prmote

  describe ".demote", :vcr do
    it "demotes a site administrator to an ordinary user" do
      @admin_client.demote("pengwynn")
      assert_requested :delete, github_enterprise_url("users/pengwynn/site_admin")
    end
  end # .demote

  describe ".suspend", :vcr do
    it "suspends a user" do
      @admin_client.suspend("pengwynn")
      assert_requested :put, github_enterprise_url("users/pengwynn/suspended")
    end
  end # .suspend

  describe ".unsuspend", :vcr do
    it "unsuspends a user" do
      @admin_client.unsuspend("pengwynn")
      assert_requested :delete, github_enterprise_url("users/pengwynn/suspended")
    end
  end # .unsuspend
end
