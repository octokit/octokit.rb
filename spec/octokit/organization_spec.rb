# frozen_string_literal: true

require 'helper'

describe Octokit::Organization do
  describe '.path' do
    context 'with name' do
      it 'returns name api path' do
        path = Octokit::Organization.path 'octokit'
        expect(path).to eq 'orgs/octokit'
      end
    end # with login

    context 'with id' do
      it 'returns id api path' do
        path = Octokit::Organization.path 3_430_433
        expect(path).to eq 'organizations/3430433'
      end
    end # with id
  end # .path
end # Octokit::Organizations
