# frozen_string_literal: true

describe Octokit::ManageGHESClient do
  describe 'module configuration' do
    it 'inherits Octokit::Client' do
      manage_ghes = Octokit::ManageGHESClient.new
      expect manage_ghes.is_a? Octokit::Client
    end
  end
end
