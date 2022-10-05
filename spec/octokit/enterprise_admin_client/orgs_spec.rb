# frozen_string_literal: true

require 'helper'

describe Octokit::EnterpriseAdminClient::Orgs do
  before do
    Octokit.reset!
    @admin_client = enterprise_admin_client
  end

  describe '.create_organization', :vcr do
    it 'creates a new organization' do
      @admin_client.create_organization('SuchAGreatOrg', 'gjtorikian')
      expect(@admin_client.last_response.status).to eq(201)
      assert_requested :post, github_enterprise_url('admin/organizations')
    end
  end # .create_organization
end
