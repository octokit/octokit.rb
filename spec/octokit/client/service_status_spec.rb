# frozen_string_literal: true

require 'helper'

describe Octokit::Client::ServiceStatus do
  before do
    Octokit.reset!
  end

  describe '.github_status_summary', :vcr do
    it 'returns the current system status summary' do
      current_status = Octokit.github_status_summary
      expect(current_status.status).not_to be_nil
      expect(current_status.components).not_to be_nil
      assert_requested :get, 'https://www.githubstatus.com/api/v2/summary.json'
    end
  end # .github_status_summary

  describe '.github_status', :vcr do
    it 'returns the current system status' do
      current_status = Octokit.github_status
      expect(current_status.status).not_to be_nil
      assert_requested :get, 'https://www.githubstatus.com/api/v2/status.json'
    end
  end # .github_status

  describe '.github_status_last_message', :vcr do
    it 'returns the last human message' do
      message = Octokit.github_status_last_message
      expect(message.status).not_to be_nil
      expect(message.description).not_to be_nil
      assert_requested :get, 'https://www.githubstatus.com/api/v2/components.json'
    end
  end # .github_status_last_message

  describe '.github_status_messages', :vcr do
    it 'returns the most recent status messages' do
      messages = Octokit.github_status_messages
      expect(messages).to be_kind_of Array
      assert_requested :get, 'https://www.githubstatus.com/api/v2/components.json'
    end
  end # .github_status_messages
end
