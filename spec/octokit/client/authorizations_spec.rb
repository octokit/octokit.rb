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
        expect(authorization.app.name).to_not be_nil
        assert_requested :post, basic_github_url("/authorizations")
      end

      it "creates a new API authorization each time" do
        first_authorization = @client.create_authorization
        second_authorization = @client.create_authorization
        expect(first_authorization.id).to_not eq second_authorization.id
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
      fetched = @client.authorization(authorization['id'])
      assert_requested :get, basic_github_url("/authorizations/#{authorization.id}")
    end
  end # .authorization

  describe ".update_authorization", :vcr do
    it "updates and existing authorization" do
      authorization = @client.create_authorization
      updated = @client.update_authorization(authorization.id, :add_scopes => ['repo:status'])
      expect(updated.scopes).to include 'repo:status'
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

  describe ".check_authorization", :vcr do
    context "with valid authentication" do
      context "when checking valid authorization" do
        before do
          @authorization = basic_auth_client.create_authorization \
            :client_id => test_github_client_id,
            :client_secret => test_github_client_secret
        end

        after do
          basic_auth_client.delete_authorization @authorization.id
        end

        it "returns a valid authorization" do
          result = basic_oauth_app_client.check_authorization \
            test_github_client_id,
            @authorization.token
          expect(result.token).to be
          assert_requested :get,
            basic_github_url(
              "/applications/#{test_github_client_id}/tokens/#{@authorization.token}",
              {:login => test_github_client_id, :password => test_github_client_secret}
            )
        end
      end

      context "when checking invalid authorization" do
        it "raises Octokit::NotFound" do
         expect {
            basic_oauth_app_client.check_authorization \
              test_github_client_id,
              'token123'
          }.to raise_error Octokit::NotFound
          assert_requested :get,
            basic_github_url(
              "/applications/#{test_github_client_id}/tokens/token123",
              {:login => test_github_client_id, :password => test_github_client_secret}
            )
        end
      end
    end

    context "with invalid authentication" do
      it "raises Octokit::NotFound" do
        expect {
          Octokit.check_authorization \
            test_github_client_id,
            'brokentoken'
        }.to raise_error Octokit::NotFound
        assert_requested :get,
          github_url("/applications/#{test_github_client_id}/tokens/brokentoken")
      end
    end
  end # .check_authorization

  describe ".delete_authorization", :vcr do
    it "deletes an existing authorization" do
      VCR.eject_cassette
      VCR.use_cassette 'delete_authorization' do
        authorization = @client.create_authorization
        result = @client.delete_authorization(authorization.id)
        expect(result).to eq true
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

  describe ".revoke_authorizations", :vcr do
    context "with valid authentication" do
      context "with a valid application client id" do
        it "returns true after successful revocation" do
          result = basic_oauth_app_client.revoke_authorizations(test_github_client_id)
          expect(result).to be_true
          assert_requested :delete,
            basic_github_url(
              "/applications/#{test_github_client_id}/tokens",
              {:login => test_github_client_id, :password => test_github_client_secret}
            )
        end
      end

      context "with invalid application client id" do
        it "returns false" do
          result = basic_oauth_app_client.revoke_authorizations('some_invalid_client_id')
          expect(result).to be_false
          assert_requested :delete,
             basic_github_url(
              "/applications/some_invalid_client_id/tokens",
              {:login => test_github_client_id, :password => test_github_client_secret}
            )
        end
      end
    end

    context "with invalid authentication" do
      it "returns false" do
        result = Octokit.revoke_authorizations(test_github_client_id)
        expect(result).to be_false
        assert_requested :delete, github_url("/applications/#{test_github_client_id}/tokens")
      end
    end
  end # .revoke_authorizations
end
