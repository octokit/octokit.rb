require "helper"

describe Octokit::EnterpriseAdminClient::Orgs do

  before do
    Octokit.reset!
    @admin_client = enterprise_admin_client
  end

  describe ".orgs", :vcr do
    it "creates a new organization" do
      @admin_client.create_organization({:login => 'SuchAGreatOrg', :admin => 'gjtorikian'})
      expect(@admin_client.last_response.status).to eq(201)
      assert_requested :post, github_enterprise_url("admin/organizations")
    end
  end # .orgs
end
