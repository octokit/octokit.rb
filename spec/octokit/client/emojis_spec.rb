# -*- encoding: utf-8 -*-
require 'helper'

describe Octokit::Client::Emojis do
  before do
    @client = Octokit::Client.new
  end

  describe ".emojis" do
    it "returns all github emojis" do
      stub_get("/emojis").
        to_return(json_response("emojis.json"))
      emojis = @client.emojis
      expect(emojis[:metal]).to eq('https://a248.e.akamai.net/assets.github.com/images/icons/emoji/metal.png?v5')
    end
  end

end
