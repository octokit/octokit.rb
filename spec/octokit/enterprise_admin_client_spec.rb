# frozen_string_literal: true

require 'helper'

describe Octokit::EnterpriseAdminClient do
  describe 'module configuration' do
    it 'inherits Octokit::Client' do
      admin_client = Octokit::EnterpriseAdminClient.new
      expect admin_client.is_a? Octokit::Client
    end

    describe 'with .netrc' do
      before do
        File.chmod(0o600, File.join(fixture_path, '.netrc'))
      end

      it 'can read .netrc files' do
        Octokit.reset!
        admin_client = Octokit::EnterpriseAdminClient.new(netrc: true, netrc_file: File.join(fixture_path, '.netrc'))
        expect(admin_client.login).to eq('sferik')
        expect(admin_client.instance_variable_get(:"@password")).to eq('il0veruby')
      end

      it 'can read non-standard API endpoint creds from .netrc' do
        Octokit.reset!
        admin_client = Octokit::EnterpriseAdminClient.new(netrc: true, netrc_file: File.join(fixture_path, '.netrc'), api_endpoint: 'http://api.github.dev')
        expect(admin_client.login).to eq('defunkt')
        expect(admin_client.instance_variable_get(:"@password")).to eq('il0veruby')
      end
    end
  end
end
