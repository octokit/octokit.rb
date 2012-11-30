# -*- encoding: utf-8 -*-
require 'helper'

describe Octokit::Client::Gitignore do

  before do
    @client = Octokit::Client.new
  end

  describe ".gitignore_templates" do
    it "returns all gitignore templates" do
      stub_get("/gitignore/templates").
        to_return(json_response("gitignore_templates.json"))
      templates = @client.gitignore_templates
      expect(templates.first).to eq("Actionscript")
    end
  end

  describe ".gitignore_template" do
    it "returns the ruby gitignore template" do
      stub_get("/gitignore/templates/Ruby").
        to_return(json_response("gitignore_template_ruby.json"))
      template = @client.gitignore_template("Ruby")
      expect(template.name).to eq("Ruby")
      expect(template.source).to include("*.gem\n")
    end
  end

end
