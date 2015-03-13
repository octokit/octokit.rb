require 'helper'

describe Octokit::Client::Licenses do
	
  describe ".licenses", :vcr do
    it "returns all licenses" do
      licenses = Octokit.licenses :accept => "application/vnd.github.drax-preview+json"
      expect(licenses).to be_kind_of Array
    end
  end

	describe ".license", :vcr do
    it "returns a particular license" do
      license = Octokit.license 'mit', :accept => "application/vnd.github.drax-preview+json"
      expect(license.name).to eq("MIT License")
  	end
  end

  describe ".license_for_repository", :vcr do
    it "returns the license for the repository" do
      repo = Octokit.license_for_repository 'benbalter/licensee', :accept => "application/vnd.github.drax-preview+json"
      expect(repo.license.key).to eq("mit")
    end
  end
end # Octokit::Licenses
