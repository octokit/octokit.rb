# -*- encoding: utf-8 -*-
require 'helper'

describe Octokit::Client::PubSubHubbub::ServiceHooks do

  let(:client) { Octokit::Client.new(:oauth_token => 'myfaketoken') }

  describe "subscribe_service_hook" do
    let(:subscribe_request_body) {
      {
        :"hub.callback" => 'github://Travis?token=travistoken',
        :"hub.mode" => 'subscribe',
        :"hub.topic" => 'https://github.com/joshk/completeness-fu/events/push'
      }
    }
    it "subscribes to pull events on specified topic" do
      stub_post("/hub").
        with(subscribe_request_body).
        to_return(:status => 204)

      expect(client.subscribe_service_hook("joshk/completeness-fu", "Travis", { :token => 'travistoken' })).to eq(true)
      assert_requested :post, "https://api.github.com/hub", :body => subscribe_request_body, :times => 1,
        :headers => {'Content-type' => 'application/x-www-form-urlencoded'}

    end
  end

  describe "unsubscribe_service_hook" do
    let(:unsubscribe_request_body) {
      {
        :"hub.callback" => 'github://Travis',
        :"hub.mode" => 'unsubscribe',
        :"hub.topic" => 'https://github.com/joshk/completeness-fu/events/push'
      }
    }

    it "unsubscribes to stop receiving events on specified topic" do
      stub_post("/hub").
        with(unsubscribe_request_body).
        to_return(:status => 204)

      expect(client.unsubscribe_service_hook("joshk/completeness-fu", "Travis")).to eq(true)
      assert_requested :post, "https://api.github.com/hub", :body => unsubscribe_request_body, :times => 1,
        :headers => {'Content-type' => 'application/x-www-form-urlencoded'}
    end
  end
end

