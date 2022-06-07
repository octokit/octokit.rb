# frozen_string_literal: true

require 'helper'

describe Octokit::Client::Say do
  before do
    Octokit.reset!
    @client = oauth_client
  end

  describe '.say', :vcr do
    it 'returns an ASCII octocat' do
      text = @client.say
      expect(text).to match(/MMMMMMMMMMMMMMMMMMMMM/)
      assert_requested :get, github_url('/octocat')
    end

    it 'returns an ASCII octocat with custom text' do
      text = @client.say 'There is no need to be upset'
      expect(text).to match(/upset/)
      assert_requested :get, github_url('/octocat?s=There+is+no+need+to+be+upset')
    end
  end
end
