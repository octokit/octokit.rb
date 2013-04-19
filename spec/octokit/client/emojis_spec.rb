require File.expand_path('../../../spec_helper.rb', __FILE__)

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
      emojis[:metal].must_match /metal/
    end
  end # .emojis
end
