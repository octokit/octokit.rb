# -*- encoding: utf-8 -*-
require 'helper'

describe Octokit::Client::Say do
  before do
    @client = Octokit::Client.new
  end

  describe ".say" do
    it "returns an ASCII octocat" do
      stub_get("/octocat").
        to_return \
          :status => 200,
          :body => fixture("say.txt"),
          :headers => {
            :content_type => 'text/plain'
          }

      text = @client.say
      expect(text).to match(/Half measures/)
    end

    it "returns an ASCII octocat with custom text" do
      stub_get("/octocat").
        to_return \
          :status => 200,
          :body => fixture("say_custom.txt"),
          :headers => {
            :content_type => 'text/plain'
          }

      text = @client.say
      expect(text).to match(/upset/)
    end
  end

end
