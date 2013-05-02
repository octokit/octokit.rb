require 'helper'

describe Octokit::Client::Say do
  before do
    @client = Octokit::Client.new
  end

  describe ".say" do
    it "returns an ASCII octocat" do
      VCR.use_cassette('say', :match_requests_on => [:uri, :query]) do
        text = @client.say
        expect(text).to match /Half measures/
        assert_requested :get, github_url("/octocat")
      end
    end

    it "returns an ASCII octocat with custom text" do
      VCR.use_cassette('say', :match_requests_on => [:uri, :query]) do
        text = @client.say "There is no need to be upset"
        expect(text).to match /upset/
        assert_requested :get, github_url("/octocat?s=There+is+no+need+to+be+upset")
      end
    end
  end

end
