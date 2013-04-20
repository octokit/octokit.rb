require File.expand_path('../../../spec_helper.rb', __FILE__)

describe Octokit::Client::ServiceStatus do

  before do
    Octokit.reset!
    VCR.turn_on!
    VCR.insert_cassette "github_status"
  end

  after do
    VCR.eject_cassette
  end

  describe ".github_status" do
    it "returns the current system status" do
      current_status = Octokit.github_status
      assert current_status.status
      assert_requested :get, "https://status.github.com/api.json"
      assert_requested :get, "https://status.github.com/api/status.json"
    end
  end # .github_status

  describe ".github_status_last_message" do
    it "returns the last human message" do
      message = Octokit.github_status_last_message
      assert message.status
      assert message.body
      assert_requested :get, "https://status.github.com/api.json"
      assert_requested :get, "https://status.github.com/api/last-message.json"
    end
  end # .github_status_last_message

  describe ".github_status" do
    it "returns the most recent status messages" do
      messages = Octokit.github_status_messages
      assert messages.must_be_kind_of Array
      assert_requested :get, "https://status.github.com/api.json"
      assert_requested :get, "https://status.github.com/api/messages.json"
    end
  end # .github_status

end
