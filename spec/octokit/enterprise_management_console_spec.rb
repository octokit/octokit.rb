# frozen_string_literal: true

describe Octokit::EnterpriseManagementConsoleClient do
  describe 'module configuration' do
    it 'inherits Octokit::Client' do
      admin_client = Octokit::EnterpriseManagementConsoleClient.new
      expect admin_client.is_a? Octokit::Client
    end
  end
end
