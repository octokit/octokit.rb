require 'helper'

describe Octokit::Authentication do

  describe '.authorize_url' do

    context 'with client id and client secret' do

      it 'returns the authorize_url' do
        resp = Octokit.authorize_url('id_here', 'secret_here')
        expect(resp).to eq('https://github.com/login/oauth/authorize?client_id=id_here&client_secret=secret_here')
      end

    end

  end


end
