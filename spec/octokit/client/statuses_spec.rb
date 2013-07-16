require 'helper'

describe Octokit::Client::Statuses do

  before do
    Octokit.reset!
    @client = oauth_client
  end

  describe ".statuses", :vcr do
    it "lists commit statuses" do
      statuses = Octokit.statuses('octokit/octokit.rb', '7d069dedd4cb56bf57760688657abd0e6b5a28b8')
      expect(statuses).to be_kind_of Array
      assert_requested :get, github_url("/repos/octokit/octokit.rb/statuses/7d069dedd4cb56bf57760688657abd0e6b5a28b8")
    end
  end # .statuses

  describe ".create_status", :vcr do
    it "creates status" do
      info = {
        :target_url => 'http://wynnnetherland.com'
      }
      @client.create_status("api-playground/api-sandbox", '78c9dcae41c7c5f81b012d15d06d843623a4988a', 'success', info)
      assert_requested :post, github_url("/repos/api-playground/api-sandbox/statuses/78c9dcae41c7c5f81b012d15d06d843623a4988a")
    end
  end # .create_status

end
