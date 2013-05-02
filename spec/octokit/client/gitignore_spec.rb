require 'helper'

describe Octokit::Client::Gitignore do

  before do
    VCR.insert_cassette 'gitignore'
  end

  after do
    VCR.eject_cassette
  end

  describe ".gitignore_templates" do
    it "returns all gitignore templates" do
      templates = Octokit.gitignore_templates
      expect(templates).to be_kind_of Array
      assert_requested :get, github_url("/gitignore/templates")
    end
  end # .gitignore_templates

  describe ".gitignore_template" do
    it "returns the ruby gitignore template" do
      template = Octokit.gitignore_template("Ruby")
      expect(template.name).to eq "Ruby"
      expect(template.source).to include "*.gem\n"
      assert_requested :get, github_url("/gitignore/templates/Ruby")
    end
  end # .gitignore_template

end
