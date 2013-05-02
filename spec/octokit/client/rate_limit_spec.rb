require 'helper'

describe Octokit::Client do

  describe ".rate_limit" do
    it "makes a response if there is no last response" do
      client = Octokit::Client.new
      VCR.use_cassette 'rate_limit' do
        rate = client.rate_limit

        expect(rate.limit).to eq 60
        expect(rate.remaining).to eq 44
      end
    end # .rate_limit
    it "checks the rate limit from the last response" do
      client = Octokit::Client.new
      VCR.use_cassette 'root' do
        client.get('/')
        VCR.use_cassette 'rate_limit' do
          rate = client.rate_limit
          expect(rate.limit).to eq 60
          expect(rate.remaining).to eq 59
        end
      end
    end
  end

  describe ".rate_limit!" do
    it "makes a web request to check the rate limit" do
      client = Octokit::Client.new
      VCR.use_cassette 'rate_limit' do
        rate = client.rate_limit!

        expect(rate.limit).to eq 60
        expect(rate.remaining).to eq 44
      end
    end
  end # .rate_limit!

end
