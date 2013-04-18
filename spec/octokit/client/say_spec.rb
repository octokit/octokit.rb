require File.expand_path('../../../spec_helper.rb', __FILE__)

describe Octokit::Client::Say do
  before do
    @client = Octokit::Client.new
  end

  describe ".say" do
    it "returns an ASCII octocat" do
      VCR.use_cassette('say', :match_requests_on => [:uri, :query]) do
        text = @client.say
        text.must_match /Half measures/
      end
    end

    it "returns an ASCII octocat with custom text" do
      VCR.use_cassette('say', :match_requests_on => [:uri, :query]) do
        text = @client.say "There is no need to be upset"
        text.must_match /upset/
      end
    end
  end

end
