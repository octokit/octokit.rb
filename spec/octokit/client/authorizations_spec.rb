require File.expand_path('../../../spec_helper.rb', __FILE__)

describe Octokit::Client::Authorizations do

  before do
    Octokit.reset!
    VCR.turn_on!
    VCR.insert_cassette 'authorizations'
    @client = basic_auth_client
  end

  after do
    VCR.eject_cassette
  end

  describe ".create_authorization" do
    it "creates an API authorization" do
      authorization = @client.create_authorization
      assert authorization.app.name
      assert_requested :post, basic_github_url("/authorizations")
    end
    it "creates a new authorization with options" do
      info = {
        :scopes => ["gist"],
      }
      authorization = @client.create_authorization info
      authorization.scopes.must_be_kind_of Array
      assert_requested :post, basic_github_url("/authorizations")
    end
  end # .create_authorization

  describe ".authorizations" do
    it "lists existing authorizations" do
      authorizations = @client.authorizations
      authorizations.must_be_kind_of Array
      assert_requested :get, basic_github_url("/authorizations")
    end
  end # .authorizations

  describe ".authorization" do
    it "returns a single authorization" do
      authorization = @client.create_authorization
      fetched = @client.authorization(authorization['id'])
      assert_requested :get, basic_github_url("/authorizations/#{authorization.id}")
    end
  end # .authorization

  describe ".update_authorization" do
    it "updates and existing authorization" do
      authorization = @client.create_authorization
      updated = @client.update_authorization(authorization.id, :add_scopes => ['repo:status'])
      updated.scopes.must_include 'repo:status'
      assert_requested :patch, basic_github_url("/authorizations/#{authorization.id}")
    end
  end # .update_authorization

  describe ".scopes" do
    it "checks the scopes on the current token" do
      authorization = @client.create_authorization
      token_client = Octokit::Client.new(:access_token => authorization.token)
      token_client.scopes.must_be_kind_of Array
      assert_requested :get, github_url("/user")
    end
    it "checks the scopes on a one-off token" do
      authorization = @client.create_authorization
      Octokit.reset!
      Octokit.scopes(authorization.token).must_be_kind_of Array
      assert_requested :get, github_url("/user")
    end
  end # .scopes

  describe ".delete_authorization" do
    it "deletes an existing authorization" do
      VCR.eject_cassette
      VCR.use_cassette 'delete_authorization' do
        authorization = @client.create_authorization
        result = @client.delete_authorization(authorization.id)
        result.must_equal true
        assert_requested :delete, basic_github_url("/authorizations/#{authorization.id}")
      end
    end
  end # .delete_authorization


end
