require 'helper'

describe Octokit::Client::PubSubHubbub do

  before do
    Octokit.reset!
    @client = oauth_client
  end

  describe ".subscribe", :vcr do
    it "subscribes to pull events" do
      subscribe_request_body = {
        :"hub.callback" => 'github://Travis?token=travistoken',
        :"hub.mode" => 'subscribe',
        :"hub.topic" => 'https://github.com/api-playground/api-sandbox/events/push'
      }

      result = @client.subscribe("https://github.com/api-playground/api-sandbox/events/push", "github://Travis?token=travistoken")
      assert_requested :post, github_url("/hub"), :body => subscribe_request_body, :times => 1,
        :headers => {'Content-type' => 'application/x-www-form-urlencoded'}
      expect(result).to be_true
    end
    it "raises an error when topic is not recognized" do
      subscribe_request_body = {
        :"hub.callback" => 'github://Travis?token=travistoken',
        :"hub.mode" => 'subscribe',
        :"hub.topic" => 'https://github.com/joshk/not_existing_project/events/push'
      }
      expect {
        @client.subscribe("https://github.com/joshk/not_existing_project/events/push", "github://Travis?token=travistoken")
      }.to raise_error Octokit::UnprocessableEntity
      assert_requested :post, github_url("/hub"), :body => subscribe_request_body, :times => 1,
        :headers => {'Content-type' => 'application/x-www-form-urlencoded'}
    end
  end # .subscribe

  describe ".unsubscribe", :vcr do
    it "unsubscribes from pull events" do
      unsubscribe_request_body = {
        :"hub.callback" => 'github://Travis?token=travistoken',
        :"hub.mode" => 'unsubscribe',
        :"hub.topic" => 'https://github.com/api-playground/api-sandbox/events/push'
      }

      result = @client.unsubscribe("https://github.com/api-playground/api-sandbox/events/push", "github://Travis?token=travistoken")
      assert_requested :post, github_url("/hub"), :body => unsubscribe_request_body, :times => 1,
        :headers => {'Content-type' => 'application/x-www-form-urlencoded'}
      expect(result).to be_true
    end
  end # .unsubscribe

  describe ".subscribe_service_hook", :vcr do
    it "subscribes to pull events on specified topic" do
      subscribe_request_body = {
        :"hub.callback" => 'github://Travis?token=travistoken',
        :"hub.mode" => 'subscribe',
        :"hub.topic" => 'https://github.com/api-playground/api-sandbox/events/push'
      }
      expect(@client.subscribe_service_hook("api-playground/api-sandbox", "Travis", { :token => 'travistoken' })).to eq(true)
      assert_requested :post, github_url("/hub"), :body => subscribe_request_body, :times => 1,
        :headers => {'Content-type' => 'application/x-www-form-urlencoded'}
    end
    it "encodes URL parameters" do
      irc_request_body = {
        :"hub.callback" => 'github://irc?server=chat.freenode.org&room=%23myproject',
        :"hub.mode" => 'subscribe',
        :"hub.topic" => 'https://github.com/joshk/completeness-fu/events/push'
      }
      stub_post("/hub").
        with(irc_request_body).
        to_return(:status => 204)
      expect(@client.subscribe_service_hook("joshk/completeness-fu", "irc", { :server => "chat.freenode.org", :room => "#myproject"})).to eql(true)
      assert_requested :post, "https://api.github.com/hub", :body => irc_request_body, :times => 1
    end
  end # .subscribe_service_hook

  describe "unsubscribe_service_hook", :vcr do
    it "unsubscribes to stop receiving events on specified topic" do
      unsubscribe_request_body = {
        :"hub.callback" => 'github://Travis',
        :"hub.mode" => 'unsubscribe',
        :"hub.topic" => 'https://github.com/api-playground/api-sandbox/events/push'
      }
      expect(@client.unsubscribe_service_hook("api-playground/api-sandbox", "Travis")).to eq(true)
      assert_requested :post, github_url("/hub"), :body => unsubscribe_request_body, :times => 1,
        :headers => {'Content-type' => 'application/x-www-form-urlencoded'}
    end
  end
end
