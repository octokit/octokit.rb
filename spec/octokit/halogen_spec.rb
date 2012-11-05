require 'helper'

describe Octokit::Halogen do

  describe '.parse' do

    it 'parses *_url links' do
      data = {
        :url      => '/',
        :user_url => '/users/pengwynn',
        :repo_url => '/repos/pengwynn/octokit'
      }

      halogen = Octokit::Halogen.new
      data, links = halogen.parse(data)

      expect(links[:self]).to eq('/')
      expect(links[:user]).to eq('/users/pengwynn')
      expect(links[:repo]).to eq('/repos/pengwynn/octokit')
    end
  end

end
