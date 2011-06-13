# -*- encoding: utf-8 -*-
require 'helper'

describe Octokit::Client::PubSubHubBub do

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
      stub_post("https://api.github.com/hub?access_token=myfaketoken").
        with(subscribe_request_body).
        to_return(:body => nil)

      client.subscribe_service_hook("joshk", "completeness-fu", "Travis", { :token => 'travistoken' }).should == true
      assert_requested :post, "https://api.github.com/hub?access_token=myfaketoken", :body => subscribe_request_body, :times => 1
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
      stub_post("https://api.github.com/hub?access_token=myfaketoken").
        with(unsubscribe_request_body).
        to_return(:body => nil)

      client.unsubscribe_service_hook("joshk", "completeness-fu", "Travis").should == true
      assert_requested :post, "https://api.github.com/hub?access_token=myfaketoken", :body => unsubscribe_request_body, :times => 1
    end
  end

  describe ".subscribe" do
    it "subscribes to pull events" do
      stub_post("https://api.github.com/hub?access_token=myfaketoken").
        with({
          :"hub.callback" => 'github://Travis?token=travistoken',
          :"hub.mode" => 'subscribe',
          :"hub.topic" => 'https://github.com/joshk/completeness-fu/events/push'
        }).
        to_return(:body => nil)

      client.subscribe("https://github.com/joshk/completeness-fu/events/push", "github://Travis?token=travistoken").should == true
    end

    it "raises an error if the topic is not recognized" do
      stub_post("https://api.github.com/hub?access_token=myfaketoken").
        with({
          :"hub.callback" => 'github://Travis?token=travistoken',
          :"hub.mode" => 'subscribe',
          :"hub.topic" => 'https://github.com/joshk/completeness-fud/events/push'
        }).
        to_return(:status => 422)

      proc {
        client.subscribe("https://github.com/joshk/completeness-fud/events/push", "github://Travis?token=travistoken")
      }.should raise_exception
    end
  end

  describe ".unsubscribe" do
    it "unsubscribes from pull events" do
      stub_post("https://api.github.com/hub?access_token=myfaketoken").
      with({
        :"hub.callback" => 'github://Travis?token=travistoken',
        :"hub.mode" => 'unsubscribe',
        :"hub.topic" => 'https://github.com/joshk/completeness-fu/events/push'
      }).
      to_return(:body => nil)

      client.unsubscribe("https://github.com/joshk/completeness-fu/events/push", "github://Travis?token=travistoken").should == true
    end
  end

end
