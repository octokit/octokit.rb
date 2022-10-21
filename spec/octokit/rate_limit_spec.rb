# frozen_string_literal: true

require 'helper'
require 'octokit/rate_limit'

describe Octokit::RateLimit do
  describe '.from_response' do
    let(:response_headers) do
      {
        'X-RateLimit-Limit' => 60,
        'X-RateLimit-Remaining' => 42,
        'X-RateLimit-Reset' => (Time.now + 60).to_i
      }
    end

    let(:response) { double('response') }

    it 'parses rate limit info from response headers' do
      expect(response).to receive(:headers)
        .at_least(:once)
        .and_return(response_headers)
      info = described_class.from_response(response)
      expect(info.limit).to eq(60)
      expect(info.remaining).to eq(42)
      expect(info.resets_in).to eq(59)
      expect(info.resets_at).to be_kind_of(Time)
    end

    it 'returns a positive rate limit for Enterprise' do
      expect(response).to receive(:headers)
        .at_least(:once)
        .and_return({})
      info = described_class.from_response(response)
      expect(info.limit).to eq(1)
      expect(info.remaining).to eq(1)
      expect(info.resets_in).to eq(0)
      expect(info.resets_at).to be_kind_of(Time)
    end

    it 'handles nil responses' do
      info = described_class.from_response(nil)
      expect(info.limit).to be_nil
      expect(info.remaining).to be_nil
      expect(info.resets_in).to be_nil
      expect(info.resets_at).to be_nil
    end

    it 'handles resets_in time in past' do
      expect(response).to receive(:headers)
        .at_least(:once)
        .and_return(
          response_headers.merge('X-RateLimit-Reset' => (Time.now - 60).to_i)
        )
      info = described_class.from_response(response)
      expect(info.limit).to eq(60)
      expect(info.remaining).to eq(42)
      expect(info.resets_in).to eq(0)
      expect(info.resets_at).to be_kind_of(Time)
    end
  end
end
