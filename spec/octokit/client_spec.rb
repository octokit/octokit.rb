require File.expand_path('../../spec_helper.rb', __FILE__)

describe Octokit::Client do

  describe "module configuration" do

    before do
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
        client.instance_variable_get(:"@#{key}").must_equal "Some #{key}"
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
        client.per_page.must_equal 40
        client.login.must_equal "defunkt"
        client.instance_variable_get(:"@password").must_equal "il0veruby"
        client.auto_paginate.must_equal Octokit.auto_paginate
        client.client_id.must_equal Octokit.client_id
      end

      it "can set configuration after initialization" do
        client = Octokit::Client.new
        client.configure do |config|
          @opts.each do |key, value|
            config.send("#{key}=", value)
          end
        end
        client.per_page.must_equal 40
        client.login.must_equal "defunkt"
        client.instance_variable_get(:"@password").must_equal "il0veruby"
        client.auto_paginate.must_equal Octokit.auto_paginate
        client.client_id.must_equal Octokit.client_id
      end

      it "masks passwords on inspect" do
        client = Octokit::Client.new(@opts)
        inspected = client.inspect
        inspected.wont_match "il0veruby"
      end

      it "masks tokens on inspect" do
        client = Octokit::Client.new(:access_token => '87614b09dd141c22800f96f11737ade5226d7ba8')
        inspected = client.inspect
        inspected.wont_match "87614b09dd141c22800f96f11737ade5226d7ba8"
      end

      it "masks client secrets on inspect" do
        client = Octokit::Client.new(:client_secret => '87614b09dd141c22800f96f11737ade5226d7ba8')
        inspected = client.inspect
        inspected.wont_match "87614b09dd141c22800f96f11737ade5226d7ba8"
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
        assert Octokit.client.basic_authenticated?
      end
      it "sets basic auth creds with module methods" do
        Octokit.login = 'pengwynn'
        Octokit.password = 'il0veruby'
        assert Octokit.client.basic_authenticated?
      end
      it "sets oauth token with .configure" do
        Octokit.configure do |config|
          config.access_token = 'd255197b4937b385eb63d1f4677e3ffee61fbaea'
        end
        refute Octokit.client.basic_authenticated?
        assert Octokit.client.token_authenticated?
      end
      it "sets oauth token with module methods" do
        Octokit.access_token = 'd255197b4937b385eb63d1f4677e3ffee61fbaea'
        refute Octokit.client.basic_authenticated?
        assert Octokit.client.token_authenticated?
      end
      it "sets oauth application creds with .configure" do
        Octokit.configure do |config|
          config.client_id     = '97b4937b385eb63d1f46'
          config.client_secret = 'd255197b4937b385eb63d1f4677e3ffee61fbaea'
        end
        refute Octokit.client.basic_authenticated?
        refute Octokit.client.token_authenticated?
        assert Octokit.client.application_authenticated?
      end
      it "sets oauth token with module methods" do
        Octokit.client_id     = '97b4937b385eb63d1f46'
        Octokit.client_secret = 'd255197b4937b385eb63d1f4677e3ffee61fbaea'
        refute Octokit.client.basic_authenticated?
        refute Octokit.client.token_authenticated?
        assert Octokit.client.application_authenticated?
      end
    end

    describe "with class level config" do
      it "sets basic auth creds with .configure" do
        @client.configure do |config|
          config.login = 'pengwynn'
          config.password = 'il0veruby'
        end
        assert @client.basic_authenticated?
      end
      it "sets basic auth creds with instance methods" do
        @client.login = 'pengwynn'
        @client.password = 'il0veruby'
        assert @client.basic_authenticated?
      end
      it "sets oauth token with .configure" do
        @client.access_token = 'd255197b4937b385eb63d1f4677e3ffee61fbaea'
        refute @client.basic_authenticated?
        assert @client.token_authenticated?
      end
      it "sets oauth token with instance methods" do
        @client.access_token = 'd255197b4937b385eb63d1f4677e3ffee61fbaea'
        refute @client.basic_authenticated?
        assert @client.token_authenticated?
      end
      it "sets oauth application creds with .configure" do
        @client.configure do |config|
          config.client_id     = '97b4937b385eb63d1f46'
          config.client_secret = 'd255197b4937b385eb63d1f4677e3ffee61fbaea'
        end
        refute @client.basic_authenticated?
        refute @client.token_authenticated?
        assert @client.application_authenticated?
      end
      it "sets oauth token with module methods" do
        @client.client_id     = '97b4937b385eb63d1f46'
        @client.client_secret = 'd255197b4937b385eb63d1f4677e3ffee61fbaea'
        refute @client.basic_authenticated?
        refute @client.token_authenticated?
        assert @client.application_authenticated?
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

  describe "#agent" do
    before do
      Octokit.reset!
    end

    it "acts like a Sawyer agent" do
      Octokit.client.send(:agent).must_respond_to :start
    end

    it "caches the agent" do
      agent = Octokit.client.send(:agent)
      agent.object_id.must_equal Octokit.client.send(:agent).object_id
    end
  end

  describe "#last_response" do
    it "caches the last agent response" do
      VCR.use_cassette 'root' do
        client = Octokit.client
        client.last_response.must_be_nil
        client.get "/"
        client.last_response.status.must_equal 200
      end
    end
  end

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
        @client.last_response.status.must_equal 200
      end
    end
    it "allows Accept'ing another media type" do
      VCR.use_cassette 'root' do
        root_request = stub_get("/").
          with(:headers => {:accept => "application/vnd.github.beta.diff+json"})
        @client.get "/", :accept => "application/vnd.github.beta.diff+json"
        assert_requested root_request
        @client.last_response.status.must_equal 200
      end
    end
    it "sets a default user agent" do
      VCR.use_cassette 'root' do
        root_request = stub_get("/").
          with(:headers => {:user_agent => Octokit::Default.user_agent})
        @client.get "/"
        assert_requested root_request
        @client.last_response.status.must_equal 200
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
        client.last_response.status.must_equal 200
      end
    end
    it "sets a proxy server" do
      Octokit.configure do |config|
        config.proxy = 'http://proxy.example.com:80'
      end
      conn = Octokit.client.send(:agent).instance_variable_get(:"@conn")
      puts conn.inspect
      conn.proxy[:uri].to_s.must_equal 'http://proxy.example.com'
    end
  end
end
