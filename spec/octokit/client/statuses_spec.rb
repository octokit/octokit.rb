require 'helper'

describe Octokit::Client::Statuses do

  before do
    Octokit.reset!
    VCR.insert_cassette 'statuses'
    @client = basic_auth_client
  end

  after do
    Octokit.reset!
    VCR.eject_cassette
  end

  describe ".statuses" do
    it "lists commit statuses" do
      statuses = Octokit.statuses('pengwynn/octokit', '7d069dedd4cb56bf57760688657abd0e6b5a28b8')
      expect(statuses).to be_kind_of Array
      assert_requested :get, github_url("/repos/pengwynn/octokit/statuses/7d069dedd4cb56bf57760688657abd0e6b5a28b8")
    end
  end # .statuses

  describe ".create_status" do
    it "creates status" do
      info = {
        :target_url => 'http://wynnnetherland.com'
      }
      @client.create_status("#{@client.login}/rails_admin", '99a0932e18dfecec394228443f92782123496548', 'success', info)
      assert_requested :post, basic_github_url("/repos/#{@client.login}/rails_admin/statuses/99a0932e18dfecec394228443f92782123496548")
    end
  end # .create_status

end
