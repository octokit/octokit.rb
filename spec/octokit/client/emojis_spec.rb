# -*- encoding: utf-8 -*-
require 'helper'

describe Octokit::Client::Emojis do
  before do
    @client = Octokit::Client.new
  end

  describe ".emojis" do
    it "should return all github emojis" do
      stub_get("/emojis").
        to_return(:body => fixture("v3/emojis.json"))
      emojis = @client.emojis
      emojis[:metal].should == 'https://a248.e.akamai.net/assets.github.com/images/icons/emoji/metal.png?v5'
    end
  end

end
