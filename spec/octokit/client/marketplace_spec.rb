require 'helper'

describe Octokit::Client::Marketplace do
  before(:each) do
    Octokit.reset!
    binding.pry
    @client = oauth_client
  end

  after(:each) do
    Octokit.reset!
  end

  describe ".find_app_marketplace_purchases" do
    context "with oatuh app client id and secret", :vcr do
      it "return purchases for a user" do
        allow(@client).to receive(:octokit_warn)
        purchases = @client.find_app_marketplace_purchases
        expect(purchases).to be_kind_of Array
        assert_requested :get, basic_github_url("/user/marketplace_purchases")
      end
    end
  end # .find_app_marketplace_purchases
end
