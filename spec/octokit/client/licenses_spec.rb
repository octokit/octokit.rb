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
end # Octokit::Licenses
