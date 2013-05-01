require File.expand_path('../../../spec_helper.rb', __FILE__)

describe Octokit::Client::PubSubHubbub do

  before do
    Octokit.reset!
    VCR.insert_cassette 'pubsubhubbub'
    @client = basic_auth_client
  end

  after do
    Octokit.reset!
    VCR.eject_cassette
  end


  describe ".subscribe" do
    it "subscribes to pull events" do
      skip
      subscribe_request_body = {
        :"hub.callback" => 'github://Travis?token=travistoken',
        :"hub.mode" => 'subscribe',
        :"hub.topic" => 'https://github.com/joshk/completeness-fu/events/push'
      }

      @client.subscribe("https://github.com/joshk/completeness-fu/events/push", "github://Travis?token=travistoken")
      assert_requested :post, "https://api.github.com/hub", :body => subscribe_request_body, :times => 1,
        :headers => {'Content-type' => 'application/x-www-form-urlencoded'}
    end
    it "raises an error when topic is not recognized" do
      skip
      subscribe_request_body = {
        :"hub.callback" => 'github://Travis?token=travistoken',
        :"hub.mode" => 'subscribe',
        :"hub.topic" => 'https://github.com/joshk/not_existing_project/events/push'
      }
      assert_raises {
        @client.subscribe("https://github.com/joshk/not_existing_project/events/push", "github://Travis?token=travistoken")
      }
      assert_requested :post, "https://api.github.com/hub", :body => subscribe_request_body, :times => 1,
        :headers => {'Content-type' => 'application/x-www-form-urlencoded'}
    end
  end # .subscribe

  describe ".unsubscribe" do
    it "unsubscribes from pull events" do
      skip
      unsubscribe_request_body = {
        :"hub.callback" => 'github://Travis?token=travistoken',
        :"hub.mode" => 'unsubscribe',
        :"hub.topic" => 'https://github.com/joshk/completeness-fu/events/push'
      }

      client.unsubscribe("https://github.com/joshk/completeness-fu/events/push", "github://Travis?token=travistoken")
      assert_requested :post, "https://api.github.com/hub", :body => unsubscribe_request_body, :times => 1,
        :headers => {'Content-type' => 'application/x-www-form-urlencoded'}
    end
  end # .unsubscribe

end
