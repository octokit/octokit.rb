# -*- encoding: utf-8 -*-
require 'helper'

describe Octokit::Client::PubSubHubbub do
  let(:client) { Octokit::Client.new(:oauth_token => 'myfaketoken') }

  describe ".subscribe" do
    it "subscribes to pull events" do
      stub_post("/hub").
        with({
          :"hub.callback" => 'github://Travis?token=travistoken',
          :"hub.mode" => 'subscribe',
          :"hub.topic" => 'https://github.com/joshk/completeness-fu/events/push'
        }).
        to_return(:body => nil)

      expect(client.subscribe("https://github.com/joshk/completeness-fu/events/push", "github://Travis?token=travistoken")).to eq(true)
    end

    it "raises an error if the topic is not recognized" do
      stub_post("/hub").
        with({
          :"hub.callback" => 'github://Travis?token=travistoken',
          :"hub.mode" => 'subscribe',
          :"hub.topic" => 'https://github.com/joshk/completeness-fud/events/push'
        }).
        to_return(:status => 422)

      expect {
        client.subscribe("https://github.com/joshk/completeness-fud/events/push", "github://Travis?token=travistoken")
      }.to raise_exception
    end
  end

  describe ".unsubscribe" do
    it "unsubscribes from pull events" do
      stub_post("/hub").
      with({
        :"hub.callback" => 'github://Travis?token=travistoken',
        :"hub.mode" => 'unsubscribe',
        :"hub.topic" => 'https://github.com/joshk/completeness-fu/events/push'
      }).
      to_return(:body => nil)

      expect(client.unsubscribe("https://github.com/joshk/completeness-fu/events/push", "github://Travis?token=travistoken")).to eq(true)
    end
  end

end
