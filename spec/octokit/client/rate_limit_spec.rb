require File.expand_path('../../../spec_helper.rb', __FILE__)

describe Octokit::Client do

  describe ".rate_limit" do

    it "makes a response if there is no last response" do
      client = Octokit::Client.new
      VCR.use_cassette 'rate_limit' do
        rate = client.rate_limit

        rate.limit.must_equal 60
        rate.remaining.must_equal 44
      end
    end

    it "checks the rate limit from the last response" do
      client = Octokit::Client.new
      VCR.use_cassette 'root' do
        client.get('/')
        VCR.use_cassette 'rate_limit' do
          rate = client.rate_limit
          rate.limit.must_equal 60
          rate.remaining.must_equal 59
        end
      end
    end

  end

  describe ".rate_limit!" do
    it "makes a web request to check the rate limit" do
      client = Octokit::Client.new
      VCR.use_cassette 'rate_limit' do
        rate = client.rate_limit!

        rate.limit.must_equal 60
        rate.remaining.must_equal 44
      end
    end
  end

end
