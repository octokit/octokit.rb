require File.expand_path('../../../spec_helper.rb', __FILE__)

describe Octokit::Client::Users do

  before do
    Octokit.reset!
    VCR.turn_on!
    VCR.insert_cassette "users"
  end

  after do
    VCR.eject_cassette
  end

  describe ".all_users" do

    it "returns all GitHub users" do
      users = Octokit.all_users
      users.must_be_kind_of Array
    end

  end # .all_users

  describe ".user" do
    it "returns a user" do
      user = Octokit.client.user("sferik")
      user.login.must_equal 'sferik'
    end
    it "returns the authenticated user" do
      client = basic_auth_client
      user = client.user
      user.login.must_equal test_github_login
    end
  end # .user

  describe ".validate_credentials" do
    it "validates username and password" do
      Octokit.validate_credentials(:login => test_github_login, :password => test_github_password).must_equal true
    end
  end # .validate_credentials

  describe ".update_user" do
    it "updates a user profile" do
      client = basic_auth_client
      user = client.update_user(:location => "San Francisco, CA", :hireable => false)
      user.login.must_equal test_github_login
      assert_requested :patch, basic_github_url("/user")
    end
  end # .update_user

  describe ".followers" do
    it "returns followers for a user" do
      users = Octokit.followers("sferik")
      users.must_be_kind_of Array
      assert_requested :get, github_url("/users/sferik/followers")
    end
    it "returns the authenticated user's followers" do
      client = basic_auth_client
      users = client.followers
      users.must_be_kind_of Array
      assert_requested :get, basic_github_url("/users/#{test_github_login}/followers")
    end
  end # .followers

  describe ".following" do
    it "returns following for a user" do
      users = Octokit.following("sferik")
      users.must_be_kind_of Array
      assert_requested :get, github_url("/users/sferik/following")
    end
    it "returns the authenticated user's following" do
      client = basic_auth_client
      users = client.following
      users.must_be_kind_of Array
      assert_requested :get, basic_github_url("/users/#{test_github_login}/following")
    end
  end # .following

  describe ".follows?" do
    it "checks if the authenticated user follows another" do
      client = basic_auth_client
      follows = client.follows?("sferik")
      assert_requested :get, basic_github_url("/user/following/sferik")
    end
  end # .follows?

  describe ".follow" do
    it "follows a user" do
      client = basic_auth_client
      following = client.follow("pengwynn")
      assert_requested :put, basic_github_url("/user/following/pengwynn")
    end
  end # .follow

  describe ".unfollow" do
    it "unfollows a user" do
      client = basic_auth_client
      following = client.unfollow("pengwynn")
      assert_requested :delete, basic_github_url("/user/following/pengwynn")
    end
  end # .unfollow

  describe ".starred?" do
    it "checks if the authenticated user has starred a repository" do
      client = basic_auth_client
      starred = client.starred?("sferik", "rails_admin")
      assert_requested :get, basic_github_url("/user/starred/sferik/rails_admin")
    end
  end # .starred?

  describe ".starred" do
    it "returns starred repositories for a user" do
      repositories = Octokit.starred("sferik")
      assert_requested :get, github_url("/users/sferik/starred")
    end
    it "returns starred repositories for the authenticated user" do
      client = basic_auth_client
      repositories = client.starred
      assert_requested :get, basic_github_url("/user/starred")
    end
  end # .starred

  describe ".key" do
    it "returns a public key" do
      skip "Enable hypermedia for this one"
    end
  end

  describe ".keys" do
    it "returns public keys for the authenticated user" do
      client = basic_auth_client
      public_keys = client.keys
      public_keys.must_be_kind_of Array
      assert_requested :get, basic_github_url("/user/keys")
    end
  end # .keys

  describe ".user_keys" do
    it "returns public keys for another user" do
      public_keys = Octokit.user_keys("pengwynn")
      public_keys.must_be_kind_of Array
      assert_requested :get, github_url("/users/pengwynn/keys")
    end
  end # .user_keys

  describe ".add_key" do
    it "adds a public key" do
      title, key = "wynning", "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDN/h7Hf5TA6G4p19deF8YS9COfuBd133GPs49tO6AU/DKIt7tlitbnUnttT0VbNZM4fplyinPu5vJl60eusn/Ngq2vDfSHP5SfgHfA9H8cnHGPYG7w6F0CujFB3tjBhHa3L6Je50E3NC4+BGGhZMpUoTClEI5yEzx3qosRfpfJu/2MUp/V2aARCAiHUlUoj5eiB15zC25uDsY7SYxkh1JO0ecKSMISc/OCdg0kwi7it4t7S/qm8Wh9pVGuA5FmVk8w0hvL+hHWB9GT02WPqiesMaS9Sj3t0yuRwgwzLDaudQPKKTKYXi+SjwXxTJ/lei2bZTMC4QxYbqfqYQt66pQB wynn.netherland+api-padawan@gmail.com"
      client = basic_auth_client
      public_key = client.add_key(title, key)
      assert_requested :post, basic_github_url("/user/keys")
    end
  end # .add_key

  describe ".update_key" do
    it "updates a public key" do
      client = basic_auth_client
      public_key = client.update_key(4647049, :title => 'Updated key')
      assert_requested :patch, basic_github_url("/user/keys/4647049")
    end
  end # .update_key

  describe ".remove_key" do
    it "removes a public key" do
      client = basic_auth_client
      response = client.remove_key(4647049)
      assert_requested :delete, basic_github_url("/user/keys/4647049")
    end
  end # .remove_key

  describe ".emails" do
    it "returns email addresses" do
      client = basic_auth_client
      emails = client.emails
      emails.must_be_kind_of Array
      assert_requested :get, basic_github_url("/user/emails")
    end
  end # .emails

  describe ".add_email" do
    it "adds an email address" do
      client = basic_auth_client
      emails = client.add_email("wynn.netherland+api@gmail.com")
      assert_requested :post, basic_github_url("/user/emails")
    end
  end # .add_email

  describe ".remove_email" do
    it "removes an email address" do
      client = basic_auth_client
      emails = client.remove_email("wynn.netherland+api@gmail.com")
      assert_requested :delete, basic_github_url("/user/emails")
    end
  end # .remove_email

  describe ".subscriptions" do
    it "returns the repositories a user watches for notifications" do
      subscriptions = Octokit.subscriptions("pengwynn")
      assert_requested :get, github_url("/users/pengwynn/subscriptions")
    end
    it "returns the repositories the authenticated user watches for notifications" do
      client = basic_auth_client
      subscriptions = client.subscriptions
      assert_requested :get, basic_github_url("/user/subscriptions")
    end
  end # .subscriptions

  describe '.access_token' do
    it 'returns the access_token' do
      VCR.eject_cassette
      VCR.turn_off!
      stub_post("https://github.com/login/oauth/access_token").
        to_return(json_response("web_flow_token.json"))
      response = Octokit.exchange_code_for_token('code', 'id_here', 'secret_here')
      response.access_token.must_equal 'this_be_ye_token/use_it_wisely'
      assert_requested :post, "https://github.com/login/oauth/access_token"
    end
  end # .access_token

end
