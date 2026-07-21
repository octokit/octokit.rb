# frozen_string_literal: true

describe Octokit::Team do
  describe '.path' do
    context 'with org name and team slug' do
      it 'returns name api path' do
        path = Octokit::Team.path 'octokit', 'justice-league'
        expect(path).to eq 'orgs/octokit/teams/justice-league'
      end
    end

    context 'with org id and team id' do
      it 'returns id api path' do
        path = Octokit::Team.path 3_430_433, 123_456
        expect(path).to eq 'organizations/3430433/team/123456'
      end
    end
  end
end
