# frozen_string_literal: true

describe Octokit::Client::Licenses do
  describe '.licenses', :vcr do
    it 'returns all licenses' do
      licenses = Octokit.licenses
      expect(licenses).to be_kind_of Array
    end
  end

  describe '.license', :vcr do
    it 'returns a particular license' do
      license = Octokit.license 'mit'
      expect(license.name).to eq('MIT License')
    end
  end

  describe '.repository_license_contents', :vcr do
    it "returns a repository's license file" do
      response = Octokit.repository_license_contents 'benbalter/licensee'
      expect(response.license.key).to eql('mit')
      content = Base64.decode64 response.content
      expect(content).to match(/MIT/)
    end
  end
end # Octokit::Licenses
