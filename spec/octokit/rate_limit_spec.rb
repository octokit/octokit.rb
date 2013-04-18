require File.expand_path('../../spec_helper.rb', __FILE__)
require 'octokit/rate_limit'

describe Octokit::RateLimit do

  it "parses rate limit info from response headers" do
    response = MiniTest::Mock.new
    response.expect :headers, {
      "X-RateLimit-Limit" => 60,
      "X-RateLimit-Remaining" => 42
    }
    info = Octokit::RateLimit.from_response(response)
    info.limit.must_equal 60
    info.remaining.must_equal 42
  end

  it "handles nil responses" do
    info = Octokit::RateLimit.from_response(nil)
    info.limit.must_be_nil
    info.remaining.must_be_nil
  end

end
