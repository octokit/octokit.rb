require 'helper'

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

    describe "when basic authenticated" do
      it "makes authenticated calls" do
        Octokit.configure do |config|
          config.login = 'pengwynn'
          config.password = 'il0veruby'
        end

        VCR.use_cassette 'root' do
          root_request = stub_get("https://pengwynn:il0veruby@api.github.com/")
          Octokit.client.get("/")
          assert_requested root_request
        end
      end
    end
    describe "when token authenticated" do
      it "makes authenticated calls" do
        client = Octokit.client
        client.access_token = 'd255197b4937b385eb63d1f4677e3ffee61fbaea'

        VCR.use_cassette 'root' do
          root_request = stub_get("/").
            with(:headers => {:authorization => "token d255197b4937b385eb63d1f4677e3ffee61fbaea"})
          client.get("/")
          assert_requested root_request
        end
      end
    end
    describe "when application authenticated" do
      it "makes authenticated calls" do
        client = Octokit.client
        client.client_id     = '97b4937b385eb63d1f46'
        client.client_secret = 'd255197b4937b385eb63d1f4677e3ffee61fbaea'

        VCR.use_cassette 'root' do
          root_request = stub_get("/?client_id=97b4937b385eb63d1f46&client_secret=d255197b4937b385eb63d1f4677e3ffee61fbaea")
          client.get("/")
          assert_requested root_request
        end
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
      VCR.use_cassette 'root' do
        root = Octokit.client.root
        expect(root.rels[:issues].href).to eq "https://api.github.com/issues"
      end
    end
  end

  describe ".last_response" do
    it "caches the last agent response" do
      Octokit.reset!
      VCR.use_cassette 'root' do
        client = Octokit.client
        expect(client.last_response).to be_nil
        client.get "/"
        expect(client.last_response.status).to eq 200
      end
    end
  end # .last_response

  describe ".get" do
    before(:each) do
      Octokit.reset!
    end
    it "handles query params" do
      VCR.use_cassette 'root' do
        Octokit.get "/", :foo => "bar"
        assert_requested :get, "https://api.github.com?foo=bar"
      end
    end
    it "handles headers" do
      VCR.use_cassette 'root' do
        request = stub_get("/zen").
          with(:query => {:foo => "bar"}, :headers => {:accept => "text/plain"})
        Octokit.get "/zen", :foo => "bar", :accept => "text/plain"
        assert_requested request
      end
    end
  end # .get

  describe ".head" do
    it "handles query params" do
      VCR.use_cassette 'root' do
        Octokit.head "/", :foo => "bar"
        assert_requested :head, "https://api.github.com?foo=bar"
      end
    end
    it "handles headers" do
      VCR.use_cassette 'root' do
        request = stub_head("/zen").
          with(:query => {:foo => "bar"}, :headers => {:accept => "text/plain"})
        Octokit.head "/zen", :foo => "bar", :accept => "text/plain"
        assert_requested request
      end
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
      VCR.use_cassette 'root' do
        root_request = stub_get("/").
          with(:headers => {:accept => "application/vnd.github.beta.diff+json"})
        @client.get "/", :accept => "application/vnd.github.beta.diff+json"
        assert_requested root_request
        expect(@client.last_response.status).to eq 200
      end
    end
    it "sets a default user agent" do
      VCR.use_cassette 'root' do
        root_request = stub_get("/").
          with(:headers => {:user_agent => Octokit::Default.user_agent})
        @client.get "/"
        assert_requested root_request
        expect(@client.last_response.status).to eq 200
      end
    end
    it "sets a custom user agent" do
      user_agent = "Mozilla/5.0 I am Spartacus!"
      VCR.use_cassette 'root' do
        root_request = stub_get("/").
          with(:headers => {:user_agent => user_agent})
        client = Octokit::Client.new :user_agent => user_agent
        client.get "/"
        assert_requested root_request
        expect(client.last_response.status).to eq 200
      end
    end
    it "sets a proxy server" do
      Octokit.configure do |config|
        config.proxy = 'http://proxy.example.com:80'
      end
      conn = Octokit.client.send(:agent).instance_variable_get(:"@conn")
      expect(conn.proxy[:uri].to_s).to eq 'http://proxy.example.com'
    end
  end

  describe "auto pagination" do
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
      VCR.use_cassette('pagination', :erb => true, :record => :none) do
        Octokit.client.paginate('/repos/rails/rails/issues', :query => {:state => 'closed'})
        assert_requested :get, github_url("/repos/rails/rails/issues?per_page=3&state=closed")
        (2..19).each do |i|
          assert_requested :get, github_url("/repositories/8514/issues?per_page=3&page=#{i}&state=closed")
        end
      end
    end
  end
end
