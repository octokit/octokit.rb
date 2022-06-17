# frozen_string_literal: true

require 'helper'

describe Octokit::Client do
  subject { Octokit::Client }

  let(:client) { Octokit::Client.new }

  describe '#rate_limit' do
    context 'with no last response' do
      it 'makes a response', vcr: { cassette_name: 'rate_limit' } do
        rate = client.rate_limit
        expect(rate.limit).to be_kind_of Integer
        expect(rate.remaining).to be_kind_of Integer
      end # #rate_limit
    end

    context 'with last response' do
      before do
        VCR.use_cassette 'root' do
          client.get('/')
        end
      end

      it 'checks the rate limit from the last response', vcr: { cassette_name: 'rate_limit' } do
        rate = client.rate_limit
        expect(rate.limit).to be_kind_of Integer
        expect(rate.remaining).to be_kind_of Integer
        expect(rate.resets_at).to be_kind_of Time
        expect(rate.resets_in).to be_kind_of Integer
      end
    end
  end

  describe '#rate_limit!', vcr: { cassette_name: 'rate_limit' } do
    it 'makes a web request to check the rate limit' do
      rate = client.rate_limit!
      expect(rate.limit).to be_kind_of Integer
      expect(rate.remaining).to be_kind_of Integer
      expect(rate.resets_at).to be_kind_of Time
      expect(rate.resets_in).to be_kind_of Integer
    end
  end # #rate_limit!

  context 'deprecated methods' do
    let(:rate) { double('rate', remaining: 1) }

    before do
      allow(client).to receive(:octokit_warn)
    end

    describe '#rate_limit_remaining' do
      before do
        allow(client).to receive(:rate_limit).and_return(rate)
      end

      after do
        expect(client).to have_received(:octokit_warn)
          .with('Deprecated: Please use .rate_limit.remaining')
        expect(client).to have_received(:rate_limit)
      end

      it 'triggers warning and will call remaining on rate_limit' do
        client.rate_limit_remaining
      end
    end

    describe 'rate_limit_remaining!' do
      before do
        allow(client).to receive(:rate_limit!).and_return(rate)
      end

      after do
        expect(client).to have_received(:octokit_warn)
          .with('Deprecated: Please use .rate_limit!.remaining')
        expect(client).to have_received(:rate_limit!)
      end

      it 'triggers warning and will remaining on rate_limit!' do
        client.rate_limit_remaining!
      end
    end
  end
end
