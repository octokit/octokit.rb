require 'helper'

describe Octokit::Client::Emojis do
  before do
    VCR.insert_cassette 'emojis'
  end

  after do
    VCR.eject_cassette
  end

  describe ".emojis" do
    it "returns all github emojis" do
      emojis = Octokit.client.emojis
      expect(emojis[:metal]).to match /metal/
    end
  end # .emojis
end
