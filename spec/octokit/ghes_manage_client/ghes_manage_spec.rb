# frozen_string_literal: true

describe Octokit::ManageGHESClient::ManageAPI do
  before do
    Octokit.reset!
    @manage_ghes = manage_ghes_client
  end

  describe '.maintenance_mode', :vcr do
    it 'get maintenance mode' do
      @manage_ghes.maintenance_mode
      expect(@manage_ghes.last_response.status).to eq(200)
      assert_requested :get, github_manage_ghes_url('/manage/v1/maintenance')
    end
  end # .maintenance_mode

  describe '.set_maintenance_mode', :vcr do
    it 'enable maintenance mode' do
      @manage_ghes.set_maintenance_mode(true)
      expect(@manage_ghes.last_response.status).to eq(200)
      expect(@manage_ghes.last_response.body[0]['message']).to eq('maintenance mode enabled')
      assert_requested :post, github_manage_ghes_url('/manage/v1/maintenance')
    end
    it 'disable maintenance mode' do
      @manage_ghes.set_maintenance_mode(false)
      expect(@manage_ghes.last_response.status).to eq(200)
      expect(@manage_ghes.last_response.body[0]['message']).to eq('maintenance mode disabled')
      assert_requested :post, github_manage_ghes_url('/manage/v1/maintenance')
    end
  end # .set_maintenance_mode
end
