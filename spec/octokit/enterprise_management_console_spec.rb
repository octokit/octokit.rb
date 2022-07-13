# frozen_string_literal: true

require 'helper'

describe Octokit::EnterpriseManagementConsoleClient do
  describe 'module configuration' do
    it 'inherits Octokit::Client' do
      admin_client = Octokit::EnterpriseManagementConsoleClient.new
      expect admin_client.is_a? Octokit::Client
    end
  end
end
