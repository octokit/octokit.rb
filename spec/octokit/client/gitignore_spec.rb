# frozen_string_literal: true

require 'helper'

describe Octokit::Client::Gitignore do
  before do
    @client = oauth_client
  end

  describe '.gitignore_templates', :vcr do
    it 'returns all gitignore templates' do
      templates = @client.gitignore_templates
      expect(templates).to be_kind_of Array
      assert_requested :get, github_url('/gitignore/templates')
    end
  end # .gitignore_templates

  describe '.gitignore_template', :vcr do
    it 'returns the ruby gitignore template' do
      template = @client.gitignore_template('Ruby')
      expect(template.name).to eq('Ruby')
      expect(template.source).to include("*.gem\n")
      assert_requested :get, github_url('/gitignore/templates/Ruby')
    end
  end # .gitignore_template
end
