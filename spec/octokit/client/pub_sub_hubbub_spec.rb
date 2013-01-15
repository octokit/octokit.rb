# -*- encoding: utf-8 -*-
require 'helper'

describe Octokit::Client::PubSubHubbub do
  let(:client) { Octokit::Client.new(:oauth_token => 'myfaketoken') }

  describe ".subscribe" do
    context "with valid params" do
      let(:subscribe_request_body) {
        {
          :"hub.callback" => 'github://Travis?token=travistoken',
          :"hub.mode" => 'subscribe',
          :"hub.topic" => 'https://github.com/joshk/completeness-fu/events/push'
        }
      }
      it "subscribes to pull events" do
        stub_post("/hub").
          with(subscribe_request_body).
          to_return(:status => 204)

        expect(client.subscribe("https://github.com/joshk/completeness-fu/events/push", "github://Travis?token=travistoken")).to eq(true)
        assert_requested :post, "https://api.github.com/hub", :body => subscribe_request_body, :times => 1,
          :headers => {'Content-type' => 'application/x-www-form-urlencoded'}
      end
    end
    context "when topic is not recognized" do
      let(:subscribe_request_body) {
        {
          :"hub.callback" => 'github://Travis?token=travistoken',
          :"hub.mode" => 'subscribe',
          :"hub.topic" => 'https://github.com/joshk/not_existing_project/events/push'
        }
      }
      it "raises an error" do
        stub_post("/hub").
          with(subscribe_request_body).
          to_return(:status => 422)

        expect {
          client.subscribe("https://github.com/joshk/not_existing_project/events/push", "github://Travis?token=travistoken")
        }.to raise_exception
        assert_requested :post, "https://api.github.com/hub", :body => subscribe_request_body, :times => 1,
          :headers => {'Content-type' => 'application/x-www-form-urlencoded'}
      end
    end
  end

  describe ".unsubscribe" do
    let(:unsubscribe_request_body) {
      {
        :"hub.callback" => 'github://Travis?token=travistoken',
        :"hub.mode" => 'unsubscribe',
        :"hub.topic" => 'https://github.com/joshk/completeness-fu/events/push'
      }
    }

    it "unsubscribes from pull events" do
      stub_post("/hub").
        with(unsubscribe_request_body).
        to_return(:status => 204)

      expect(client.unsubscribe("https://github.com/joshk/completeness-fu/events/push", "github://Travis?token=travistoken")).to eq(true)
      assert_requested :post, "https://api.github.com/hub", :body => unsubscribe_request_body, :times => 1,
        :headers => {'Content-type' => 'application/x-www-form-urlencoded'}
    end
  end

end
