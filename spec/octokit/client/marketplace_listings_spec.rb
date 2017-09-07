require 'helper'

describe Octokit::Client::MarketplaceListings do
  before(:each) do
    Octokit.reset!
    @client     = oauth_client
    @jwt_client = Octokit::Client.new(:bearer_token => new_jwt_token)
    use_vcr_placeholder_for(@jwt_client.bearer_token, '<JWT_BEARER_TOKEN>')
  end

  after(:each) do
    Octokit.reset!
  end

  describe ".list_plans", :vcr do
    it "returns plans for a marketplace listing" do
      plans = @jwt_client.list_plans
      expect(plans).to be_kind_of Array
      assert_requested :get, github_url("/marketplace_listing/plans")
    end
  end # .list_plans

  describe ".list_accounts_for_plan", :vcr do
    it "returns accounts for a given plan" do
      plans = @jwt_client.list_accounts_for_plan(7)
      expect(plans).to be_kind_of Array
      assert_requested :get, github_url("/marketplace_listing/plans/7/accounts")
    end
  end # .list_accounts_for_plan

  describe ".plan_for_account", :vcr do
    it "returns the plan for a given account" do
      plans = @jwt_client.plan_for_account(1)
      expect(plans).to be_kind_of Sawyer::Resource
      assert_requested :get, github_url("/marketplace_listing/accounts/1")
    end
  end # .plan_for_account

  private

  def new_jwt_token
    private_pem = File.read(test_github_integration_pem_key)
    private_key = OpenSSL::PKey::RSA.new(private_pem)

    payload = {}.tap do |opts|
      opts[:iat] = Time.now.to_i           # Issued at time.
      opts[:exp] = opts[:iat] + 600        # JWT expiration time is 10 minutes from issued time.
      opts[:iss] = test_github_integration # Integration's GitHub identifier.
    end

    JWT.encode(payload, private_key, 'RS256')
  end
end
