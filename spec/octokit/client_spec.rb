require 'helper'
require 'json'

describe Octokit::Client do

  describe "module configuration" do

    before do
      Octokit.reset!
      Octokit.configure do |config|
        Octokit::Configurable.keys.each do |key|
          config.send("#{key}=", "Some #{key}")
        end
      end
    end

    after do
      Octokit.reset!
    end

    it "inherits the module configuration" do
      client = Octokit::Client.new
      Octokit::Configurable.keys.each do |key|
        expect(client.instance_variable_get(:"@#{key}")).to eq "Some #{key}"
      end
    end

    describe "with class level configuration" do

      before do
        @opts = {
          :connection_options => {:ssl => {:verify => false}},
          :per_page => 40,
          :login    => "defunkt",
          :password => "il0veruby"
        }
      end

      it "overrides module configuration" do
        client = Octokit::Client.new(@opts)
        expect(client.per_page).to eq 40
        expect(client.login).to eq "defunkt"
        expect(client.instance_variable_get(:"@password")).to eq "il0veruby"
        expect(client.auto_paginate).to eq Octokit.auto_paginate
        expect(client.client_id).to eq Octokit.client_id
      end

      it "can set configuration after initialization" do
        client = Octokit::Client.new
        client.configure do |config|
          @opts.each do |key, value|
            config.send("#{key}=", value)
          end
        end
        expect(client.per_page).to eq 40
        expect(client.login).to eq "defunkt"
        expect(client.instance_variable_get(:"@password")).to eq "il0veruby"
        expect(client.auto_paginate).to eq Octokit.auto_paginate
        expect(client.client_id).to eq Octokit.client_id
      end

      it "masks passwords on inspect" do
        client = Octokit::Client.new(@opts)
        inspected = client.inspect
        expect(inspected).to_not include "il0veruby"
      end

      it "masks tokens on inspect" do
        client = Octokit::Client.new(:access_token => '87614b09dd141c22800f96f11737ade5226d7ba8')
        inspected = client.inspect
        expect(inspected).to_not match "87614b09dd141c22800f96f11737ade5226d7ba8"
      end

      it "masks client secrets on inspect" do
        client = Octokit::Client.new(:client_secret => '87614b09dd141c22800f96f11737ade5226d7ba8')
        inspected = client.inspect
        expect(inspected).to_not match "87614b09dd141c22800f96f11737ade5226d7ba8"
      end

      describe "with .netrc" do
        it "can read .netrc files" do
          Octokit.reset!
          client = Octokit::Client.new \
            :netrc => true,
            :netrc_file => File.join(fixture_path, '.netrc')
          expect(client.login).to eq "sferik"
          expect(client.instance_variable_get(:"@password")).to eq "il0veruby"
        end

        it "can read non-standard API endpoint creds from .netrc" do
          Octokit.reset!
          client = Octokit::Client.new \
            :netrc => true,
            :netrc_file => File.join(fixture_path, '.netrc'),
            :api_endpoint => 'http://api.github.dev'
          expect(client.login).to eq "defunkt"
          expect(client.instance_variable_get(:"@password")).to eq "il0veruby"
        end
      end
    end
  end

  describe "authentication" do
    before do
      Octokit.reset!
      @client = Octokit.client
    end

    describe "with module level config" do
      before do
        Octokit.reset!
      end
      it "sets basic auth creds with .configure" do
        Octokit.configure do |config|
          config.login = 'pengwynn'
          config.password = 'il0veruby'
        end
        expect(Octokit.client).to be_basic_authenticated
      end
      it "sets basic auth creds with module methods" do
        Octokit.login = 'pengwynn'
        Octokit.password = 'il0veruby'
        expect(Octokit.client).to be_basic_authenticated
      end
      it "sets oauth token with .configure" do
        Octokit.configure do |config|
          config.access_token = 'd255197b4937b385eb63d1f4677e3ffee61fbaea'
        end
        expect(Octokit.client).to_not be_basic_authenticated
        expect(Octokit.client).to be_token_authenticated
      end
      it "sets oauth token with module methods" do
        Octokit.access_token = 'd255197b4937b385eb63d1f4677e3ffee61fbaea'
        expect(Octokit.client).to_not be_basic_authenticated
        expect(Octokit.client).to be_token_authenticated
      end
      it "sets oauth application creds with .configure" do
        Octokit.configure do |config|
          config.client_id     = '97b4937b385eb63d1f46'
          config.client_secret = 'd255197b4937b385eb63d1f4677e3ffee61fbaea'
        end
        expect(Octokit.client).to_not be_basic_authenticated
        expect(Octokit.client).to_not be_token_authenticated
        expect(Octokit.client).to be_application_authenticated
      end
      it "sets oauth token with module methods" do
        Octokit.client_id     = '97b4937b385eb63d1f46'
        Octokit.client_secret = 'd255197b4937b385eb63d1f4677e3ffee61fbaea'
        expect(Octokit.client).to_not be_basic_authenticated
        expect(Octokit.client).to_not be_token_authenticated
        expect(Octokit.client).to be_application_authenticated
      end
    end

    describe "with class level config" do
      it "sets basic auth creds with .configure" do
        @client.configure do |config|
          config.login = 'pengwynn'
          config.password = 'il0veruby'
        end
        expect(@client).to be_basic_authenticated
      end
      it "sets basic auth creds with instance methods" do
        @client.login = 'pengwynn'
        @client.password = 'il0veruby'
        expect(@client).to be_basic_authenticated
      end
      it "sets oauth token with .configure" do
        @client.access_token = 'd255197b4937b385eb63d1f4677e3ffee61fbaea'
        expect(@client).to_not be_basic_authenticated
        expect(@client).to be_token_authenticated
      end
      it "sets oauth token with instance methods" do
        @client.access_token = 'd255197b4937b385eb63d1f4677e3ffee61fbaea'
        expect(@client).to_not be_basic_authenticated
        expect(@client).to be_token_authenticated
      end
      it "sets oauth application creds with .configure" do
        @client.configure do |config|
          config.client_id     = '97b4937b385eb63d1f46'
          config.client_secret = 'd255197b4937b385eb63d1f4677e3ffee61fbaea'
        end
        expect(@client).to_not be_basic_authenticated
        expect(@client).to_not be_token_authenticated
        expect(@client).to be_application_authenticated
      end
      it "sets oauth token with module methods" do
        @client.client_id     = '97b4937b385eb63d1f46'
        @client.client_secret = 'd255197b4937b385eb63d1f4677e3ffee61fbaea'
        expect(@client).to_not be_basic_authenticated
        expect(@client).to_not be_token_authenticated
        expect(@client).to be_application_authenticated
      end
    end

    describe "when basic authenticated"  do
      it "makes authenticated calls" do
        Octokit.configure do |config|
          config.login = 'pengwynn'
          config.password = 'il0veruby'
        end

        VCR.turn_off!
        root_request = stub_get("https://pengwynn:il0veruby@api.github.com/")
        Octokit.client.get("/")
        assert_requested root_request
        VCR.turn_on!
      end
    end
    describe "when token authenticated", :vcr do
      it "makes authenticated calls" do
        client = oauth_client

        root_request = stub_get("/").
          with(:headers => {:authorization => "token #{test_github_token}"})
        client.get("/")
        assert_requested root_request
      end
      it "fetches and memoizes login" do
        client = oauth_client

        expect(client.login).to eq test_github_login
        assert_requested :get, github_url('/user')
      end
    end
    describe "when application authenticated", :vcr do
      it "makes authenticated calls" do
        client = Octokit.client
        client.client_id     = '97b4937b385eb63d1f46'
        client.client_secret = 'd255197b4937b385eb63d1f4677e3ffee61fbaea'

        root_request = stub_get("/?client_id=97b4937b385eb63d1f46&client_secret=d255197b4937b385eb63d1f4677e3ffee61fbaea")
        client.get("/")
        assert_requested root_request
      end
    end
  end

  describe ".agent" do
    before do
      Octokit.reset!
    end
    it "acts like a Sawyer agent" do
      expect(Octokit.client.agent).to respond_to :start
    end
    it "caches the agent" do
      agent = Octokit.client.agent
      expect(agent.object_id).to eq Octokit.client.agent.object_id
    end
  end # .agent

  describe ".root" do
    it "fetches the API root" do
      Octokit.reset!
      VCR.use_cassette 'root' do
        root = Octokit.client.root
        expect(root.rels[:issues].href).to eq "https://api.github.com/issues"
      end
    end
  end

  describe ".last_response", :vcr do
    it "caches the last agent response" do
      Octokit.reset!
      client = Octokit.client
      expect(client.last_response).to be_nil
      client.get "/"
      expect(client.last_response.status).to eq 200
    end
  end # .last_response

  describe ".get", :vcr do
    before(:each) do
      Octokit.reset!
    end
    it "handles query params" do
      Octokit.get "/", :foo => "bar"
      assert_requested :get, "https://api.github.com?foo=bar"
    end
    it "handles headers" do
      request = stub_get("/zen").
        with(:query => {:foo => "bar"}, :headers => {:accept => "text/plain"})
      Octokit.get "/zen", :foo => "bar", :accept => "text/plain"
      assert_requested request
    end
  end # .get

  describe ".head", :vcr do
    it "handles query params" do
      Octokit.reset!
      Octokit.head "/", :foo => "bar"
      assert_requested :head, "https://api.github.com?foo=bar"
    end
    it "handles headers" do
      Octokit.reset!
      request = stub_head("/zen").
        with(:query => {:foo => "bar"}, :headers => {:accept => "text/plain"})
      Octokit.head "/zen", :foo => "bar", :accept => "text/plain"
      assert_requested request
    end
  end # .head

  describe "when making requests" do
    before do
      Octokit.reset!
      @client = Octokit.client
    end
    it "Accepts application/vnd.github.beta+json by default" do
      VCR.use_cassette 'root' do
        root_request = stub_get("/").
          with(:headers => {:accept => "application/vnd.github.beta+json"})
        @client.get "/"
        assert_requested root_request
        expect(@client.last_response.status).to eq 200
      end
    end
    it "allows Accept'ing another media type" do
      root_request = stub_get("/").
        with(:headers => {:accept => "application/vnd.github.beta.diff+json"})
      @client.get "/", :accept => "application/vnd.github.beta.diff+json"
      assert_requested root_request
      expect(@client.last_response.status).to eq 200
    end
    it "sets a default user agent" do
      root_request = stub_get("/").
        with(:headers => {:user_agent => Octokit::Default.user_agent})
      @client.get "/"
      assert_requested root_request
      expect(@client.last_response.status).to eq 200
    end
    it "sets a custom user agent" do
      user_agent = "Mozilla/5.0 I am Spartacus!"
      root_request = stub_get("/").
        with(:headers => {:user_agent => user_agent})
      client = Octokit::Client.new :user_agent => user_agent
      client.get "/"
      assert_requested root_request
      expect(client.last_response.status).to eq 200
    end
    it "sets a proxy server" do
      Octokit.configure do |config|
        config.proxy = 'http://proxy.example.com:80'
      end
      conn = Octokit.client.send(:agent).instance_variable_get(:"@conn")
      expect(conn.proxy[:uri].to_s).to eq 'http://proxy.example.com'
    end
    it "passes along request headers for POST" do
      VCR.turn_off!
      headers = {"X-GitHub-Foo" => "bar"}
      root_request = stub_post("/").
        with(:headers => headers).
        to_return(:status => 201)
      client = Octokit::Client.new
      client.post "/", :headers => headers
      assert_requested root_request
      expect(client.last_response.status).to eq 201
      VCR.turn_on!
    end
  end

  describe "auto pagination", :vcr do
    before do
      Octokit.reset!
      Octokit.configure do |config|
        config.auto_paginate = true
        config.per_page = 3
      end
    end

    after do
      Octokit.reset!
    end

    it "fetches all the pages" do
      Octokit.client.paginate('/repos/octokit/octokit.rb/issues')
      assert_requested :get, github_url("/repos/octokit/octokit.rb/issues?per_page=3")
      (2..7).each do |i|
        assert_requested :get, github_url("/repositories/417862/issues?per_page=3&page=#{i}")
      end
    end
  end

  context "error handling" do
    before do
      Octokit.reset!
      VCR.turn_off!
    end

    after do
      VCR.turn_on!
    end

    it "raises on 404" do
      stub_get('/booya').to_return(:status => 404)
      expect { Octokit.get('/booya') }.to raise_error Octokit::NotFound
    end

    it "raises on 500" do
      stub_get('/boom').to_return(:status => 500)
      expect { Octokit.get('/boom') }.to raise_error Octokit::InternalServerError
    end

    it "includes a message" do
      stub_get('/boom').
        to_return \
        :status => 422,
        :headers => {
          :content_type => "application/json",
        },
        :body => {:message => "No repository found for hubtopic"}.to_json
      begin
        Octokit.get('/boom')
      rescue Octokit::UnprocessableEntity => e
        expect(e.message).to include \
          "GET https://api.github.com/boom: 422 - No repository found"
      end
    end

    it "includes an error" do
      stub_get('/boom').
        to_return \
        :status => 422,
        :headers => {
          :content_type => "application/json",
        },
        :body => {:error => "No repository found for hubtopic"}.to_json
      begin
        Octokit.get('/boom')
      rescue Octokit::UnprocessableEntity => e
        expect(e.message).to include \
          "GET https://api.github.com/boom: 422 - Error: No repository found"
      end
    end

    it "includes an error summary" do
      stub_get('/boom').
        to_return \
        :status => 422,
        :headers => {
          :content_type => "application/json",
        },
        :body => {
          :message => "Validation Failed",
          :errors => [
            :resource => "Issue",
            :field    => "title",
            :code     => "missing_field"
          ]
        }.to_json
      begin
        Octokit.get('/boom')
      rescue Octokit::UnprocessableEntity => e
        expect(e.message).to include \
          "GET https://api.github.com/boom: 422 - Validation Failed"
        expect(e.message).to include "  resource: Issue"
        expect(e.message).to include "  field: title"
        expect(e.message).to include "  code: missing_field"
      end
    end

    it "knows the difference between Forbidden and rate limiting" do
      stub_get('/some/admin/stuffs').to_return(:status => 403)
      expect { Octokit.get('/some/admin/stuffs') }.to raise_error Octokit::Forbidden

      stub_get('/users/mojomobo').to_return \
        :status => 403,
        :headers => {
          :content_type => "application/json",
        },
        :body => {:message => "API rate limit exceeded"}.to_json
      expect { Octokit.get('/users/mojomobo') }.to raise_error Octokit::TooManyRequests

      stub_get('/user').to_return \
        :status => 403,
        :headers => {
          :content_type => "application/json",
        },
        :body => {:message => "Maximum number of login attempts exceeded"}.to_json
      expect { Octokit.get('/user') }.to raise_error Octokit::TooManyLoginAttempts
    end

    it "raises on unknown client errors" do
      stub_get('/user').to_return \
        :status => 418,
        :headers => {
          :content_type => "application/json",
        },
        :body => {:message => "I'm a teapot"}.to_json
      expect { Octokit.get('/user') }.to raise_error Octokit::ClientError
    end

    it "raises on unknown server errors" do
      stub_get('/user').to_return \
        :status => 509,
        :headers => {
          :content_type => "application/json",
        },
        :body => {:message => "Bandwidth exceeded"}.to_json
      expect { Octokit.get('/user') }.to raise_error Octokit::ServerError
    end

    it "handles documentation URLs in error messages" do
      stub_get('/user').to_return \
        :status => 415,
        :headers => {
          :content_type => "application/json",
        },
        :body => {
          :message => "Unsupported Media Type",
          :documentation_url => "http://developer.github.com/v3"
        }.to_json
      begin
        Octokit.get('/user')
      rescue Octokit::UnsupportedMediaType => e
        msg = "415 - Unsupported Media Type"
        expect(e.message).to include(msg)
        expect(e.documentation_url).to eq("http://developer.github.com/v3")
      end
    end
  end

  it "knows the difference between unauthorized and needs OTP" do
      stub_get('/authorizations').to_return(:status => 401)
      expect { Octokit.get('/authorizations') }.to raise_error Octokit::Unauthorized

      stub_get('/authorizations/1').to_return \
        :status => 401,
        :headers => {
          :content_type => "application/json",
          "X-GitHub-OTP" => "required; sms"
        },
        :body => {:message => "Must specify two-factor authentication OTP code."}.to_json
      expect { Octokit.get('/authorizations/1') }.to raise_error Octokit::OneTimePasswordRequired
  end

  it "knows the password delivery mechanism when needs OTP" do
    stub_get('/authorizations/1').to_return \
      :status => 401,
      :headers => {
        :content_type => "application/json",
        "X-GitHub-OTP" => "required; app"
      },
      :body => {:message => "Must specify two-factor authentication OTP code."}.to_json

    begin
      Octokit.get('/authorizations/1')
    rescue Octokit::OneTimePasswordRequired => otp_error
      expect(otp_error.password_delivery).to eql 'app'
    end
  end

end
