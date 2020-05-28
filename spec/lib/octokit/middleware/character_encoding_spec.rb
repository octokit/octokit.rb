# frozen_string_literal: true

require 'helper'

describe Octokit::Middleware::CharacterEncoding do
  before do
    stack = Faraday::RackBuilder.new do |builder|
      builder.use Octokit::Middleware::CharacterEncoding
      builder.use Octokit::Response::RaiseError
      builder.adapter Faraday.default_adapter
    end

    Octokit.middleware = stack
    @client = Octokit::Client.new
  end

  describe 'base64', :vcr do
    it 'decodes the base64 content and replaces it in the response body' do
      options = { accept: 'application/vnd.github.drax-preview+json' }

      response = @client.repository_license_contents('licensee/licensee', options)
      content  = response.content

      expect(response.license.key).to eql('mit')
      expect(content).to match(/MIT/)
    end
  end

  describe 'charset', :vcr do
    it 'enforces UTF-8 encoding if set as the header' do
      contents = @client.contents('github/scripts-to-rule-them-all', 'script/bootstrap', ref: '504fdf48ca50e80860d139641ff065134c0290fc', accept: 'application/vnd.github.V3.raw')
      expect(contents.encoding).to eq(Encoding::UTF_8)
    end
  end
end
