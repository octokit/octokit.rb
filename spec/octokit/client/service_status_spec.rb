require 'helper'

describe Octokit::Client::ServiceStatus do

  before do
    Octokit.reset!
  end

  describe ".github_status", :vcr do
    it "returns the current system status" do
      current_status = Octokit.github_status
      expect(current_status.status).not_to be_nil
      assert_requested :get, "https://status.github.com/api.json"
      assert_requested :get, "https://status.github.com/api/status.json"
    end
  end # .github_status

  describe ".github_status_last_message", :vcr do
    it "returns the last human message" do
      message = Octokit.github_status_last_message
      expect(message.status).not_to be_nil
      expect(message.body).not_to be_nil
      assert_requested :get, "https://status.github.com/api.json"
      assert_requested :get, "https://status.github.com/api/last-message.json"
    end
  end # .github_status_last_message

  describe ".github_status", :vcr do
    it "returns the most recent status messages" do
      messages = Octokit.github_status_messages
      expect(messages).to be_kind_of Array
      assert_requested :get, "https://status.github.com/api.json"
      assert_requested :get, "https://status.github.com/api/messages.json"
    end
  end # .github_status

end
