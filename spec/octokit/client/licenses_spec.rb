# frozen_string_literal: true

require 'helper'

describe Octokit::Client::Licenses do
  describe '.licenses', :vcr do
    it 'returns all licenses' do
      licenses = Octokit.licenses accept: 'application/vnd.github.drax-preview+json'
      expect(licenses).to be_kind_of Array
    end
  end

  describe '.license', :vcr do
    it 'returns a particular license' do
      license = Octokit.license 'mit', accept: 'application/vnd.github.drax-preview+json'
      expect(license.name).to eq('MIT License')
    end
  end

  describe '.repository_license_contents', :vcr do
    it "returns a repository's license file" do
      options = { accept: 'application/vnd.github.drax-preview+json' }
      response = Octokit.repository_license_contents 'benbalter/licensee', options
      expect(response.license.key).to eql('mit')
      content = Base64.decode64 response.content
      expect(content).to match(/MIT/)
    end
  end
end # Octokit::Licenses
