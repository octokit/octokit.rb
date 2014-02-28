require 'helper'
require 'octokit/rate_limit'

describe Octokit::RateLimit do

  it "parses rate limit info from response headers" do
    response = double()
    expect(response).to receive(:headers).
      at_least(:once).
      and_return({
        "X-RateLimit-Limit" => 60,
        "X-RateLimit-Remaining" => 42,
        "X-RateLimit-Reset" => (Time.now + 60).to_i
      })
    info = Octokit::RateLimit.from_response(response)
    expect(info.limit).to eq(60)
    expect(info.remaining).to eq(42)
    expect(info.resets_in).to eq(59)
    expect(info.resets_at).to be_kind_of(Time)
  end

  it "handles nil responses" do
    info = Octokit::RateLimit.from_response(nil)
    expect(info.limit).to be_nil
    expect(info.remaining).to be_nil
    expect(info.resets_in).to be_nil
    expect(info.resets_at).to be_nil
  end

  describe ".exceeded?" do
    context "with exceeded rate limit" do
      it "returns true" do
        response = double()
        expect(response).to receive(:headers).
          at_least(:once).
          and_return({"X-RateLimit-Remaining" => 0})
        rate_limit = Octokit::RateLimit.from_response(response)
        expect(rate_limit.exceeded?).to be true
      end
    end # with exceeded rate limit

    context "without exceeded rate limit" do
      it "returns false" do
        response = double()
        expect(response).to receive(:headers).
          at_least(:once).
          and_return({"X-RateLimit-Remaining" => 1})
        rate_limit = Octokit::RateLimit.from_response(response)
        expect(rate_limit.exceeded?).to be false
      end
    end # without exceeded rate limit

    context "without rate limit headers" do
      it "returns false" do
        response = double()
        expect(response).to receive(:headers).at_least(:once)
        rate_limit = Octokit::RateLimit.from_response(response)
        expect(rate_limit.exceeded?).to be false
      end
    end # without rate limit headers
  end # .exceeded?
end
