require 'helper'

describe Octokit::Client::Authorizations do

  before do
    Octokit.reset!
    @client = basic_auth_client
  end

  after do
    Octokit.reset!
  end

  describe ".create_authorization", :vcr do
    context 'without :idempotent => true' do
      it "creates an API authorization" do
        authorization = @client.create_authorization
        expect(authorization.app.name).not_to be_nil
        assert_requested :post, basic_github_url("/authorizations")
      end

      it "creates a new API authorization each time" do
        first_authorization = @client.create_authorization
        second_authorization = @client.create_authorization
        expect(first_authorization.id).not_to eq(second_authorization.id)
      end

      it "creates a new authorization with options" do
        info = {
          :scopes => ["gist"],
        }
        authorization = @client.create_authorization info
        expect(authorization.scopes).to be_kind_of Array
        assert_requested :post, basic_github_url("/authorizations")
      end
    end

    context 'with :idempotent => true' do
      it "creates a new authorization with options" do
        authorization = @client.create_authorization \
          :idempotent    => true,
          :client_id     => test_github_client_id,
          :client_secret => test_github_client_secret,
          :scopes => %w(gist)
        expect(authorization.scopes).to be_kind_of Array
        assert_requested :put, basic_github_url("/authorizations/clients/#{test_github_client_id}")
      end

      it 'returns an existing API authorization if one already exists' do
        first_authorization = @client.create_authorization \
          :idempotent    => true,
          :client_id     => test_github_client_id,
          :client_secret => test_github_client_secret
        second_authorization = @client.create_authorization \
          :idempotent    => true,
          :client_id     => test_github_client_id,
          :client_secret => test_github_client_secret
        expect(first_authorization.id).to eql second_authorization.id
      end
    end
  end # .create_authorization

  describe ".authorizations", :vcr do
    it "lists existing authorizations" do
      authorizations = @client.authorizations
      expect(authorizations).to be_kind_of Array
      assert_requested :get, basic_github_url("/authorizations")
    end
  end # .authorizations

  describe ".authorization", :vcr do
    it "returns a single authorization" do
      authorization = @client.create_authorization
      @client.authorization(authorization['id'])
      assert_requested :get, basic_github_url("/authorizations/#{authorization.id}")
    end
  end # .authorization

  describe ".update_authorization", :vcr do
    it "updates and existing authorization" do
      authorization = @client.create_authorization
      updated = @client.update_authorization(authorization.id, :add_scopes => ['repo:status'])
      expect(updated.scopes).to include('repo:status')
      assert_requested :patch, basic_github_url("/authorizations/#{authorization.id}")
    end
  end # .update_authorization

  describe ".scopes", :vcr do
    it "checks the scopes on the current token" do
      authorization = @client.create_authorization
      token_client = Octokit::Client.new(:access_token => authorization.token)
      expect(token_client.scopes).to be_kind_of Array
      assert_requested :get, github_url("/user")
    end
    it "checks the scopes on a one-off token" do
      authorization = @client.create_authorization
      Octokit.reset!
      expect(Octokit.scopes(authorization.token)).to be_kind_of Array
      assert_requested :get, github_url("/user")
    end
  end # .scopes

  describe ".delete_authorization", :vcr do
    it "deletes an existing authorization" do
      VCR.eject_cassette
      VCR.use_cassette 'delete_authorization' do
        authorization = @client.create_authorization
        result = @client.delete_authorization(authorization.id)
        expect(result).to be true
        assert_requested :delete, basic_github_url("/authorizations/#{authorization.id}")
      end
    end
  end # .delete_authorization

  describe ".authorize_url" do
    context "with preconfigured client credentials" do
      it "returns the authorize_url" do
        Octokit.configure do |c|
          c.client_id = 'id_here'
          c.client_secret = 'secret_here'
        end

        url = Octokit.authorize_url
        expect(url).to eq('https://github.com/login/oauth/authorize?client_id=id_here')
      end
    end

    context "with passed client credentials" do
      it "returns the authorize_url" do
        url = Octokit.authorize_url('id_here')
        expect(url).to eq('https://github.com/login/oauth/authorize?client_id=id_here')
      end
    end
  end # .authorize_url

end
