require 'helper'
require 'octokit/rate_limit'

describe Octokit::RateLimit do
  subject { described_class }

  describe ".from_response" do

    let(:core_limit) {
      OpenStruct.new({
        :limit => 60,
        :remaining => 42,
        :reset => (Time.now + 60).to_i
      })
    }

    let(:search_limit) {
      OpenStruct.new({
        :limit => 10,
        :remaining => 9,
        :reset => (Time.now + 60).to_i
      })
    }

    let(:resources) {
      OpenStruct.new({
        :core => core_limit,
        :search => search_limit
      })
    }

    let(:response) {
      OpenStruct.new({
        :resources => resources,
        :rate => core_limit
      })
    }

    it "parses rate limit info from response" do
      info = described_class.from_response(response)
      expect(info.limit).to eq(60)
      expect(info.remaining).to eq(42)
      expect(info.resets_in).to eq(59)
      expect(info.resets_at).to be_kind_of(Time)
    end

    it "handles nil responses" do
      info = described_class.from_response(nil)
      expect(info.limit).to be_nil
      expect(info.remaining).to be_nil
      expect(info.resets_in).to be_nil
      expect(info.resets_at).to be_nil
    end

    it "handles resets_in time in past" do
      response.resources.core.reset = (Time.now - 60).to_i
      info = described_class.from_response(response)
      expect(info.limit).to eq(60)
      expect(info.remaining).to eq(42)
      expect(info.resets_in).to eq(0)
      expect(info.resets_at).to be_kind_of(Time)
    end
  end
end
