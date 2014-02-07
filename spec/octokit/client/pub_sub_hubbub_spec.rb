require 'helper'

describe Octokit::Client::PubSubHubbub do
  before do
    Octokit.reset!
    @client = oauth_client
  end

  describe ".subscribe" do
    it "subscribes to pull events" do
      VCR.turned_off do
        request = stub_post(github_url("/hub")).
          with(:body => {
            :"hub.callback" => 'github://Travis?token=travistoken',
            :"hub.mode" => 'subscribe',
            :"hub.topic" => 'https://github.com/elskwid/github-services/events/push',
            :"hub.secret" => '12345'
          }).
          to_return(:status => 204)
        result = @client.subscribe("https://github.com/elskwid/github-services/events/push", "github://Travis?token=travistoken", "12345")
        expect(result).to be_true
        assert_requested request
      end
    end
    it "raises an error when topic is not recognized", :vcr do
      subscribe_request_body = {
        :"hub.callback" => 'github://Travis?token=travistoken',
        :"hub.mode" => 'subscribe',
        :"hub.topic" => 'https://github.com/joshk/not_existing_project/events/push'
      }
      expect {
        @client.subscribe("https://github.com/joshk/not_existing_project/events/push", "github://Travis?token=travistoken")
      }.to raise_error Octokit::UnprocessableEntity
      assert_requested :post, github_url("/hub"), :body => subscribe_request_body, :times => 1,
        :headers => {'Content-type' => 'application/x-www-form-urlencoded'}
    end
  end # .subscribe

  describe ".subscribe_service_hook" do
    it "subscribes to pull event on specified topic" do
      VCR.turned_off do
        request = stub_post(github_url("/hub")).
          with(:body => {
            :"hub.callback" => 'github://Travis?token=travistoken',
            :"hub.mode" => 'subscribe',
            :"hub.topic" => 'https://github.com/elskwid/github-services/events/push',
            :"hub.secret" => '12345'
          }).
          to_return(:status => 204)
        result = @client.subscribe_service_hook("elskwid/github-services", "Travis", { :token => 'travistoken' }, "12345")
        expect(result).to be_true
        assert_requested request
      end
    end
    it "encodes URL parameters", :vcr  do
      irc_request_body = {
        :"hub.callback" => 'github://irc?server=chat.freenode.org&room=%23myproject',
        :"hub.mode" => 'subscribe',
        :"hub.topic" => 'https://github.com/joshk/completeness-fu/events/push'
      }
      stub_post("/hub").
        with(irc_request_body).
        to_return(:status => 204)
      expect(@client.subscribe_service_hook("joshk/completeness-fu", "irc", { :server => "chat.freenode.org", :room => "#myproject"})).to eql(true)
      # Since we can't depend upon hash ordering across the Rubies
      assert_requested :post, "https://api.github.com/hub", :times => 1 do |req|
        req.body[%r{hub.callback=github%3A%2F%2Firc%3Froom%3D%2523myproject}]
        req.body[%r{server%3Dchat.freenode.org}]
      end
    end
  end # .subscribe_service_hook

  context "with test repository" do
    before do
      @test_repo = setup_test_repo.full_name
    end

    after do
      teardown_test_repo @test_repo
    end

    describe ".unsubscribe", :vcr do
      it "unsubscribes from pull events" do
        unsubscribe_request_body = {
          :"hub.callback" => 'github://Travis?token=travistoken',
          :"hub.mode" => 'unsubscribe',
          :"hub.topic" => "https://github.com/#{@test_repo}/events/push"
        }

        result = @client.unsubscribe("https://github.com/#{@test_repo}/events/push", "github://Travis?token=travistoken")
        assert_requested :post, github_url("/hub"), :body => unsubscribe_request_body, :times => 1,
          :headers => {'Content-type' => 'application/x-www-form-urlencoded'}
        expect(result).to be_true
      end
    end # .unsubscribe

    describe "unsubscribe_service_hook", :vcr do
      it "unsubscribes to stop receiving events on specified topic" do
        unsubscribe_request_body = {
          :"hub.callback" => 'github://Travis',
          :"hub.mode" => 'unsubscribe',
          :"hub.topic" => "https://github.com/#{@test_repo}/events/push"
        }
        expect(@client.unsubscribe_service_hook(@test_repo, "Travis")).to eq(true)
        assert_requested :post, github_url("/hub"), :body => unsubscribe_request_body, :times => 1,
          :headers => {'Content-type' => 'application/x-www-form-urlencoded'}
      end
    end # .unsubscribe_service_hook
  end # with test repository
end # Octokit::Client::PubSubHubbub
