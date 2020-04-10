require 'helper'

describe Octokit::Client::Licenses do

  describe ".commonly_used", :vcr do
    it "returns commonly used licenses" do
      licenses = Octokit.commonly_used()
      expect(licenses).to be_kind_of Array
    end
  end

  describe ".license", :vcr do
    it "returns a particular license" do
      license = Octokit.license('mit')
      expect(license.name).to eq("MIT License")
    end
  end

  describe ".repository_license_contents", :vcr do
    it "returns a repository's license file" do
      response = Octokit.repo_license('benbalter/licensee')
      expect(response.license.key).to eql("mit")
      content = Base64.decode64 response.content
      expect(content).to match(/MIT/)
    end
  end
end # Octokit::Licenses
