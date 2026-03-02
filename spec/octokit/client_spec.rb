# frozen_string_literal: true

require 'json'

describe Octokit::Client do
  before do
    Octokit.reset!
  end

  after do
    Octokit.reset!
  end

  describe 'module configuration' do
    before do
      Octokit.reset!
      Octokit.configure do |config|
        # rubocop:disable Style/HashEachMethods
        #
        # This may look like a `.keys.each` which should be replaced with `#each_key`, but
        # this doesn't actually work, since `#keys` is just a method we've defined ourselves.
        # The class doesn't fulfill the whole `Enumerable` contract.
        Octokit::Configurable.keys.each do |key|
          # rubocop:enable Style/HashEachMethods
          config.send("#{key}=", "Some #{key}")
        end
      end
    end

    after do
      Octokit.reset!
    end

    it 'inherits the module configuration' do
      client = Octokit::Client.new
      # rubocop:disable Style/HashEachMethods
      #
      # This may look like a `.keys.each` which should be replaced with `#each_key`, but
      # this doesn't actually work, since `#keys` is just a method we've defined ourselves.
      # The class doesn't fulfill the whole `Enumerable` contract.
      Octokit::Configurable.keys.each do |key|
        # rubocop:enable Style/HashEachMethods
        expect(client.instance_variable_get(:"@#{key}")).to eq("Some #{key}")
      end
    end

    describe 'with class level configuration' do
      before do
        @opts = {
          connection_options: { ssl: { verify: false } },
          per_page: 40,
          login: 'defunkt',
          password: 'il0veruby'
        }
      end

      it 'uses defaults when parameters are nil' do
        new_opts = @opts.merge(api_endpoint: nil)
        client = Octokit::Client.new(new_opts)
        expect(client.api_endpoint).to eq(Octokit.api_endpoint)
      end

      it 'overrides module configuration' do
        client = Octokit::Client.new(@opts)
        expect(client.per_page).to eq(40)
        expect(client.login).to eq('defunkt')
        expect(client.instance_variable_get(:@password)).to eq('il0veruby')
        expect(client.auto_paginate).to eq(Octokit.auto_paginate)
        expect(client.client_id).to eq(Octokit.client_id)
      end

      it 'can set configuration after initialization' do
        client = Octokit::Client.new
        client.configure do |config|
          @opts.each do |key, value|
            config.send("#{key}=", value)
          end
        end
        expect(client.per_page).to eq(40)
        expect(client.login).to eq('defunkt')
        expect(client.instance_variable_get(:@password)).to eq('il0veruby')
        expect(client.auto_paginate).to eq(Octokit.auto_paginate)
        expect(client.client_id).to eq(Octokit.client_id)
      end

      it 'masks passwords on inspect' do
        client = Octokit::Client.new(@opts)
        inspected = client.inspect
        expect(inspected).not_to include('il0veruby')
      end

      it 'masks tokens on inspect' do
        client = Octokit::Client.new(access_token: '87614b09dd141c22800f96f11737ade5226d7ba8')
        inspected = client.inspect
        expect(inspected).not_to include('87614b09dd141c22800f96f11737ade5226d7ba8')
      end

      it 'masks bearer token on inspect' do
        client = Octokit::Client.new(bearer_token: 'secret JWT')
        inspected = client.inspect
        expect(inspected).not_to include('secret JWT')
      end

      it 'masks client secrets on inspect' do
        client = Octokit::Client.new(client_secret: '87614b09dd141c22800f96f11737ade5226d7ba8')
        inspected = client.inspect
        expect(inspected).not_to include('87614b09dd141c22800f96f11737ade5226d7ba8')
      end

      describe 'with .netrc' do
        before do
          File.chmod(0o600, File.join(fixture_path, '.netrc'))
        end

        it 'can read .netrc files' do
          Octokit.reset!
          client = Octokit::Client.new(netrc: true, netrc_file: File.join(fixture_path, '.netrc'))
          expect(client.login).to eq('sferik')
          expect(client.instance_variable_get(:@password)).to eq('il0veruby')
        end

        it 'can read non-standard API endpoint creds from .netrc' do
          Octokit.reset!
          client = Octokit::Client.new(netrc: true, netrc_file: File.join(fixture_path, '.netrc'), api_endpoint: 'http://api.github.dev')
          expect(client.login).to eq('defunkt')
          expect(client.instance_variable_get(:@password)).to eq('il0veruby')
        end
      end
    end
  end

  describe 'content type' do
    it 'sets a default Content-Type header' do
      gist_request = stub_post('/gists')
                     .with({
                             headers: { 'Content-Type' => 'application/json' }
                           })

      Octokit.client.post '/gists', {}
      assert_requested gist_request
    end
    it 'fixes % bug', :vcr do
      new_gist = {
        description: '%A gist from Octokit',
        public: true,
        files: {
          'zen.text' => { content: 'Keep it logically awesome.' }
        }
      }
      client = Octokit::Client.new
      client.post '/gists', new_gist
      expect(client.last_response.status).to eq(201)
    end
  end

  describe 'authentication' do
    before do
      Octokit.reset!
      @client = Octokit.client
    end

    describe 'with module level config' do
      before do
        Octokit.reset!
      end

      it 'sets basic auth creds with .configure' do
        Octokit.configure do |config|
          config.login = 'pengwynn'
          config.password = 'il0veruby'
        end
        expect(Octokit.client).to be_basic_authenticated
      end

      it 'sets basic auth creds with module methods' do
        Octokit.login = 'pengwynn'
        Octokit.password = 'il0veruby'
        expect(Octokit.client).to be_basic_authenticated
      end

      it 'sets oauth token with .configure' do
        Octokit.configure do |config|
          config.access_token = 'd255197b4937b385eb63d1f4677e3ffee61fbaea'
        end
        expect(Octokit.client).not_to be_basic_authenticated
        expect(Octokit.client).to be_token_authenticated
      end

      it 'sets oauth token with module methods' do
        Octokit.access_token = 'd255197b4937b385eb63d1f4677e3ffee61fbaea'
        expect(Octokit.client).not_to be_basic_authenticated
        expect(Octokit.client).to be_token_authenticated
      end

      it 'sets bearer token with module method' do
        Octokit.bearer_token = 'secret JWT'
        expect(Octokit.client).to be_bearer_authenticated
      end

      it 'sets bearer token with .configure' do
        Octokit.configure do |config|
          config.bearer_token = 'secret JWT'
        end
        expect(Octokit.client).not_to be_basic_authenticated
        expect(Octokit.client).not_to be_token_authenticated
        expect(Octokit.client).to be_bearer_authenticated
      end

      it 'sets oauth application creds with .configure' do
        Octokit.configure do |config|
          config.client_id     = '97b4937b385eb63d1f46'
          config.client_secret = 'd255197b4937b385eb63d1f4677e3ffee61fbaea'
        end
        expect(Octokit.client).not_to be_basic_authenticated
        expect(Octokit.client).not_to be_token_authenticated
        expect(Octokit.client).to be_application_authenticated
      end

      it 'sets oauth token with module methods' do
        Octokit.client_id     = '97b4937b385eb63d1f46'
        Octokit.client_secret = 'd255197b4937b385eb63d1f4677e3ffee61fbaea'
        expect(Octokit.client).not_to be_basic_authenticated
        expect(Octokit.client).not_to be_token_authenticated
        expect(Octokit.client).to be_application_authenticated
      end
    end

    describe 'with class level config' do
      it 'sets basic auth creds with .configure' do
        @client.configure do |config|
          config.login = 'pengwynn'
          config.password = 'il0veruby'
        end
        expect(@client).to be_basic_authenticated
      end
      it 'sets basic auth creds with instance methods' do
        @client.login = 'pengwynn'
        @client.password = 'il0veruby'
        expect(@client).to be_basic_authenticated
      end
      it 'sets oauth token with .configure' do
        @client.access_token = 'd255197b4937b385eb63d1f4677e3ffee61fbaea'
        expect(@client).not_to be_basic_authenticated
        expect(@client).to be_token_authenticated
      end
      it 'sets oauth token with instance methods' do
        @client.access_token = 'd255197b4937b385eb63d1f4677e3ffee61fbaea'
        expect(@client).not_to be_basic_authenticated
        expect(@client).to be_token_authenticated
      end
      it 'sets oauth application creds with .configure' do
        @client.configure do |config|
          config.client_id     = '97b4937b385eb63d1f46'
          config.client_secret = 'd255197b4937b385eb63d1f4677e3ffee61fbaea'
        end
        expect(@client).not_to be_basic_authenticated
        expect(@client).not_to be_token_authenticated
        expect(@client).to be_application_authenticated
      end
      it 'sets oauth token with module methods' do
        @client.client_id     = '97b4937b385eb63d1f46'
        @client.client_secret = 'd255197b4937b385eb63d1f4677e3ffee61fbaea'
        expect(@client).not_to be_basic_authenticated
        expect(@client).not_to be_token_authenticated
        expect(@client).to be_application_authenticated
      end
    end

    describe 'when basic authenticated' do
      it 'makes authenticated calls' do
        Octokit.configure do |config|
          config.login = 'pengwynn'
          config.password = 'il0veruby'
        end

        root_request = stub_request(:get, github_url('/')).with(basic_auth: %w[pengwynn il0veruby])
        Octokit.client.get('/')
        assert_requested root_request
      end
    end

    describe 'when token authenticated', :vcr do
      it 'makes authenticated calls' do
        client = oauth_client

        root_request = stub_get('/')
                       .with(headers: { authorization: "token #{test_github_token}" })
        client.get('/')
        assert_requested root_request
      end
      it 'fetches and memoizes login' do
        client = oauth_client

        expect(client.login).to eq(test_github_login)
        assert_requested :get, github_url('/user')
      end
    end

    describe 'when bearer authenticated', :vcr do
      it 'makes authenticated calls' do
        jwt = 'secret JWT'
        client = Octokit::Client.new(bearer_token: jwt)

        root_request = stub_get('/')
                       .with(headers: { authorization: "Bearer #{jwt}" })
        client.get('/')
        assert_requested root_request
      end
    end

    describe 'when application authenticated' do
      it 'makes authenticated calls' do
        client = Octokit::Client.new(
          client_id: '97b4937b385eb63d1f46',
          client_secret: 'd255197b4937b385eb63d1f4677e3ffee61fbaea'
        )

        root_request = stub_request(:get, github_url('/'))
                       .with(basic_auth: %w[97b4937b385eb63d1f46 d255197b4937b385eb63d1f4677e3ffee61fbaea])

        client.get('/')
        assert_requested root_request
      end
    end
  end

  describe '.agent' do
    before do
      Octokit.reset!
    end
    it 'acts like a Sawyer agent' do
      expect(Octokit.client.agent).to respond_to :start
    end
    it 'caches the agent' do
      client = Octokit::Client.new
      agent = client.agent
      expect(agent.object_id).to eq(client.agent.object_id)
    end
  end # .agent

  describe '.root' do
    it 'fetches the API root' do
      Octokit.reset!
      VCR.use_cassette 'root' do
        root = Octokit.client.root
        expect(root.rels[:issues].href).to eq('https://api.github.com/issues')
      end
    end

    it 'passes app creds in the query string' do
      root_request = stub_request(:get, github_url('/'))
                     .with(basic_auth: %w[97b4937b385eb63d1f46 d255197b4937b385eb63d1f4677e3ffee61fbaea])
      client = Octokit.client
      client.client_id     = '97b4937b385eb63d1f46'
      client.client_secret = 'd255197b4937b385eb63d1f4677e3ffee61fbaea'
      client.root
      assert_requested root_request
    end
  end

  describe '.last_response', :vcr do
    it 'caches the last agent response' do
      Octokit.reset!
      client = Octokit.client
      expect(client.last_response).to be_nil
      client.get '/'
      expect(client.last_response.status).to eq(200)
    end
  end # .last_response

  describe '.get', :vcr do
    before(:each) do
      Octokit.reset!
    end
    it 'handles query params' do
      Octokit.get '/', foo: 'bar'
      assert_requested :get, 'https://api.github.com?foo=bar'
    end
    it 'handles headers' do
      request = stub_get('/zen')
                .with(query: { foo: 'bar' }, headers: { accept: 'text/plain' })
      Octokit.get '/zen', foo: 'bar', accept: 'text/plain'
      assert_requested request
    end
  end # .get

  describe '.head', :vcr do
    it 'handles query params' do
      Octokit.reset!
      Octokit.head '/', foo: 'bar'
      assert_requested :head, 'https://api.github.com?foo=bar'
    end
    it 'handles headers' do
      Octokit.reset!
      request = stub_head('/zen')
                .with(query: { foo: 'bar' }, headers: { accept: 'text/plain' })
      Octokit.head '/zen', foo: 'bar', accept: 'text/plain'
      assert_requested request
    end
  end # .head

  describe 'when making requests' do
    before do
      Octokit.reset!
      @client = Octokit.client
    end
    it 'Accepts application/vnd.github.v3+json by default' do
      VCR.use_cassette 'root' do
        root_request = stub_get('/')
                       .with(headers: { accept: 'application/vnd.github.v3+json' })
        @client.get '/'
        assert_requested root_request
        expect(@client.last_response.status).to eq(200)
      end
    end
    it "allows Accept'ing another media type" do
      root_request = stub_get('/')
                     .with(headers: { accept: 'application/vnd.github.beta.diff+json' })
      @client.get '/', accept: 'application/vnd.github.beta.diff+json'
      assert_requested root_request
      expect(@client.last_response.status).to eq(200)
    end
    it 'sets a default user agent' do
      root_request = stub_get('/')
                     .with(headers: { user_agent: Octokit::Default.user_agent })
      @client.get '/'
      assert_requested root_request
      expect(@client.last_response.status).to eq(200)
    end
    it 'sets a custom user agent' do
      user_agent = 'Mozilla/5.0 I am Spartacus!'
      root_request = stub_get('/')
                     .with(headers: { user_agent: user_agent })
      client = Octokit::Client.new(user_agent: user_agent)
      client.get '/'
      assert_requested root_request
      expect(client.last_response.status).to eq(200)
    end
    it 'sets a proxy server' do
      Octokit.configure do |config|
        config.proxy = 'http://proxy.example.com:80'
      end
      conn = Octokit.client.send(:agent).instance_variable_get(:@conn)
      expect(conn.proxy[:uri].to_s).to eq('http://proxy.example.com')
    end
    it 'no sets an ssl verify' do
      client = Octokit::Client.new
      expect(client.connection_options[:ssl]).to be nil
    end
    it 'sets an ssl verify => true' do
      client = Octokit::Client.new(
        connection_options: { ssl: { verify: true } }
      )
      conn = client.send(:agent).instance_variable_get(:@conn)
      expect(conn.ssl[:verify]).to eq(true)
      expect(conn.ssl[:verify_mode]).to eq(OpenSSL::SSL::VERIFY_PEER)
    end
    it 'sets an ssl verify => false' do
      client = Octokit::Client.new(
        connection_options: { ssl: { verify: false } }
      )
      conn = client.send(:agent).instance_variable_get(:@conn)
      expect(conn.ssl[:verify]).to eq(false)
      expect(conn.ssl[:verify_mode]).to eq(OpenSSL::SSL::VERIFY_NONE)
    end
    it 'sets an ssl verify mode' do
      Octokit.configure do |config|
        config.ssl_verify_mode = OpenSSL::SSL::VERIFY_NONE
      end
      conn = Octokit.client.send(:agent).instance_variable_get(:@conn)
      expect(conn.ssl[:verify_mode]).to eq(OpenSSL::SSL::VERIFY_NONE)
    end
    it 'ensures ssl verify mode is set to default when no override provided' do
      conn = Octokit.client.send(:agent).instance_variable_get(:@conn)
      expect(conn.ssl[:verify_mode]).to eq(OpenSSL::SSL::VERIFY_PEER)
    end
    it 'passes along request headers for POST' do
      headers = { 'X-GitHub-Foo' => 'bar' }
      root_request = stub_post('/')
                     .with(headers: headers)
                     .to_return(status: 201)
      client = Octokit::Client.new
      client.post '/', headers: headers
      assert_requested root_request
      expect(client.last_response.status).to eq(201)
    end
    it 'adds app creds in query params to anonymous requests' do
      client = Octokit::Client.new
      client.client_id     = key = '97b4937b385eb63d1f46'
      client.client_secret = secret = 'd255197b4937b385eb63d1f4677e3ffee61fbaea'
      root_request = stub_request(:get, github_url('/')).with(basic_auth: [key, secret])

      client.get('/')
      assert_requested root_request
    end
    it 'omits app creds in query params for basic requests' do
      client = Octokit::Client.new login: 'login', password: 'passw0rd'
      client.client_id     = key = '97b4937b385eb63d1f46'
      client.client_secret = secret = 'd255197b4937b385eb63d1f4677e3ffee61fbaea'
      root_request = stub_request(:get, github_url('/?foo=bar')).with(basic_auth: %w[login passw0rd])

      client.get('/', foo: 'bar')
      assert_requested root_request
    end
    it 'omits app creds in query params for token requests' do
      client = Octokit::Client.new(access_token: '87614b09dd141c22800f96f11737ade5226d7ba8')
      client.client_id     = key = '97b4937b385eb63d1f46'
      client.client_secret = secret = 'd255197b4937b385eb63d1f4677e3ffee61fbaea'
      root_request = stub_get(github_url('/?foo=bar')).with \
        headers: { 'Authorization' => 'token 87614b09dd141c22800f96f11737ade5226d7ba8' }

      client.get('/', foo: 'bar')
      assert_requested root_request
    end
  end

  describe 'redirect handling' do
    it 'follows redirect for 301 response' do
      client = oauth_client

      original_request = stub_get('/foo')
                         .to_return(status: 301, headers: { 'Location' => '/bar' })
      redirect_request = stub_get('/bar').to_return(status: 200)

      client.get('/foo')
      assert_requested original_request
      assert_requested redirect_request
    end

    it 'follows redirect for 302 response' do
      client = oauth_client

      original_request = stub_get('/foo')
                         .to_return(status: 302, headers: { 'Location' => '/bar' })
      redirect_request = stub_get('/bar').to_return(status: 200)

      client.get('/foo')
      assert_requested original_request
      assert_requested redirect_request
    end

    it 'follows redirect for 307 response' do
      client = oauth_client

      original_request = stub_post(github_url('/foo'))
                         .with(body: { some_property: 'some_value' }.to_json)
                         .to_return(status: 307, headers: { 'Location' => '/bar' })
      redirect_request = stub_post(github_url('/bar'))
                         .with(body: { some_property: 'some_value' }.to_json)
                         .to_return(status: 201, headers: { 'Location' => '/bar' })

      client.post('/foo', { some_property: 'some_value' })
      assert_requested original_request
      assert_requested redirect_request
    end

    it 'follows redirects for supported HTTP methods' do
      client = oauth_client

      http_methods = %i[head get post put patch delete]

      http_methods.each do |http|
        original_request = stub_request(http, github_url('/foo'))
                           .to_return(status: 301, headers: { 'Location' => '/bar' })
        redirect_request = stub_request(http, github_url('/bar'))
                           .to_return(status: 200)

        client.send(http, '/foo')
        assert_requested original_request
        assert_requested redirect_request
      end
    end

    it 'does not change HTTP method when following a redirect' do
      client = oauth_client

      original_request = stub_delete('/foo')
                         .to_return(status: 301, headers: { 'Location' => '/bar' })
      redirect_request = stub_delete('/bar').to_return(status: 200)

      client.delete('/foo')
      assert_requested original_request
      assert_requested redirect_request

      other_methods = %i[head get post put patch]
      other_methods.each do |http|
        assert_not_requested http, github_url('/bar')
      end
    end

    it 'keeps authentication info when redirecting to the same host' do
      client = oauth_client

      original_request = stub_get('/foo')
                         .with(headers: { 'Authorization' => "token #{test_github_token}" })
                         .to_return(status: 301, headers: { 'Location' => '/bar' })
      redirect_request = stub_get('/bar')
                         .with(headers: { 'Authorization' => "token #{test_github_token}" })
                         .to_return(status: 200)

      client.get('/foo')
      assert_requested original_request
      assert_requested redirect_request
    end

    it 'drops authentication info when redirecting to a different host' do
      client = oauth_client

      original_request = stub_request(:get, github_url('/foo'))
                         .with(headers: { 'Authorization' => "token #{test_github_token}" })
                         .to_return(status: 301, headers: { 'Location' => 'https://example.com/bar' })
      redirect_request = stub_request(:get, 'https://example.com/bar')
                         .to_return(status: 200)

      client.get('/foo')

      assert_requested original_request
      assert_requested(redirect_request.with(headers: { 'Authorization' => 'dummy' }))
    end

    it 'follows at most 3 consecutive redirects' do
      client = oauth_client

      original_request = stub_get('/a')
                         .to_return(status: 302, headers: { 'Location' => '/b' })
      first_redirect = stub_get('/b')
                       .to_return(status: 302, headers: { 'Location' => '/c' })
      second_redirect = stub_get('/c')
                        .to_return(status: 302, headers: { 'Location' => '/d' })
      third_redirect = stub_get('/d')
                       .to_return(status: 302, headers: { 'Location' => '/e' })
      fourth_redirect = stub_get('/e').to_return(status: 200)

      expect { client.get('/a') }.to raise_error(Octokit::Middleware::RedirectLimitReached)
      assert_requested original_request
      assert_requested first_redirect
      assert_requested second_redirect
      assert_requested third_redirect
      assert_not_requested fourth_redirect
    end
  end

  describe 'auto pagination', :vcr do
    before do
      Octokit.reset!
      Octokit.configure do |config|
        config.auto_paginate = true
        config.per_page = 1
      end
    end

    after do
      Octokit.reset!
    end

    it 'fetches all the pages' do
      url = '/search/users?q=user:joeyw user:pengwynn user:sferik'
      Octokit.client.paginate url
      assert_requested :get, github_url("#{url}&per_page=1")
      (2..3).each do |i|
        assert_requested :get, github_url("#{url}&per_page=1&page=#{i}")
      end
    end

    it 'accepts a block for custom result concatination' do
      results = Octokit.client.paginate('/search/users?per_page=1&q=user:pengwynn+user:defunkt',
                                        per_page: 1) do |data, last_response|
        data.items.concat last_response.data.items
      end

      expect(results.total_count).to eq(2)
      expect(results.items.length).to eq(2)
    end

    it 'sets headers for all pages' do
      url = '/search/repositories?q=octokit+language:Python'
      accept_text_match = 'application/vnd.github.v3.text-match+json'
      github_media_type_header = 'github.v3; param=text-match; format=json'
      Octokit.client.paginate url, accept: accept_text_match
      expect(Octokit.client.last_response.headers['x-github-media-type']).to eq(github_media_type_header)
    end
  end

  describe '.as_app' do
    before do
      @client_id = '97b4937b385eb63d1f46'
      @client_secret = 'd255197b4937b385eb63d1f4677e3ffee61fbaea'

      Octokit.reset!
      Octokit.configure do |config|
        config.access_token  = 'a' * 40
        config.client_id     = @client_id
        config.client_secret = @client_secret
        config.per_page      = 50
      end

      @root_request = stub_request(:get, github_url('/')).with(basic_auth: [@client_id, @client_secret])
    end

    it 'uses preconfigured client and secret' do
      client = Octokit.client
      login = client.as_app(&:login)
      expect(login).to eq(@client_id)
    end

    it 'requires a client and secret' do
      Octokit.reset!
      client = Octokit.client
      expect do
        client.as_app(&:get)
      end.to raise_error Octokit::ApplicationCredentialsRequired
    end

    it 'duplicates the client' do
      client = Octokit.client
      page_size = client.as_app(&:per_page)
      expect(page_size).to eq(client.per_page)
    end

    it 'uses client and secret as Basic auth' do
      client = Octokit.client
      app_client = client.as_app do |c|
        c
      end
      expect(app_client).to be_basic_authenticated
    end

    it 'makes authenticated requests' do
      stub_get github_url('/user')

      client = Octokit.client
      client.get '/user'
      client.as_app do |c|
        c.get '/'
      end

      assert_requested @root_request
    end
  end

  context 'error handling' do
    before do
      Octokit.reset!
      VCR.turn_off!
    end

    after do
      VCR.turn_on!
    end

    it 'raises on 404' do
      stub_get('/booya').to_return(status: 404)
      expect { Octokit.get('/booya') }.to raise_error Octokit::NotFound
    end

    it 'raises on 500' do
      stub_get('/boom').to_return(status: 500)
      expect { Octokit.get('/boom') }.to raise_error Octokit::InternalServerError
    end

    it 'includes a message' do
      stub_get('/boom')
        .to_return \
          status: 422,
          headers: {
            content_type: 'application/json'
          },
          body: { message: 'No repository found for hubtopic' }.to_json
      begin
        Octokit.get('/boom')
      rescue Octokit::UnprocessableEntity => e
        expect(e.message).to include('GET https://api.github.com/boom: 422 - No repository found')
      end
    end

    it 'includes an error' do
      stub_get('/boom')
        .to_return \
          status: 422,
          headers: {
            content_type: 'application/json'
          },
          body: { error: 'No repository found for hubtopic' }.to_json
      begin
        Octokit.get('/boom')
      rescue Octokit::UnprocessableEntity => e
        expect(e.message).to include('GET https://api.github.com/boom: 422 - Error: No repository found')
      end
    end

    it 'includes an error summary' do
      stub_get('/boom')
        .to_return \
          status: 422,
          headers: {
            content_type: 'application/json'
          },
          body: {
            message: 'Validation Failed',
            errors: [
              'Position is invalid',
              { resource: 'Issue',
                field: 'title',
                code: 'missing_field' }
            ]
          }.to_json
      begin
        Octokit.get('/boom')
      rescue Octokit::UnprocessableEntity => e
        expect(e.message).to include('GET https://api.github.com/boom: 422 - Validation Failed')
        expect(e.message).to include('  Position is invalid')
        expect(e.message).to include('  resource: Issue')
        expect(e.message).to include('  field: title')
        expect(e.message).to include('  code: missing_field')
      end
    end

    it 'exposes errors array' do
      stub_get('/boom')
        .to_return \
          status: 422,
          headers: {
            content_type: 'application/json'
          },
          body: {
            message: 'Validation Failed',
            errors: [
              resource: 'Issue',
              field: 'title',
              code: 'missing_field'
            ]
          }.to_json
      begin
        Octokit.get('/boom')
      rescue Octokit::UnprocessableEntity => e
        expect(e.errors.first[:resource]).to eq('Issue')
        expect(e.errors.first[:field]).to eq('title')
        expect(e.errors.first[:code]).to eq('missing_field')
      end
    end

    it 'exposes errors string' do
      stub_get('/boom')
        .to_return \
          status: 422,
          headers: {
            content_type: 'application/json'
          },
          body: {
            message: 'Validation Failed',
            errors: 'Issue'
          }.to_json
      begin
        Octokit.get('/boom')
      rescue Octokit::UnprocessableEntity => e
        expect(e.message).to include('GET https://api.github.com/boom: 422 - Validation Failed')
        expect(e.message).to include('Issue')
      end
    end

    it 'handles errors as a hash' do
      stub_get('/boom')
        .to_return \
          status: 422,
          headers: { content_type: 'application/json' },
          body: {
            message: 'Validation Failed',
            errors: { field: 'some field', issue: 'some issue' }
          }.to_json
      begin
        Octokit.get('/boom')
      rescue Octokit::UnprocessableEntity => e
        expect(e.message).to include('GET https://api.github.com/boom: 422 - Validation Failed')
        expect(e.message).to include('Error summary:')
        expect(e.message).to include('[:field, "some field"]')
        expect(e.message).to include('[:issue, "some issue"]')
      end
    end

    it 'handles nil errors gracefully' do
      stub_get('/boom')
        .to_return \
          status: 422,
          headers: { content_type: 'application/json' },
          body: {
            message: 'Validation Failed',
            errors: nil
          }.to_json
      begin
        Octokit.get('/boom')
      rescue Octokit::UnprocessableEntity => e
        expect(e.message).to include('GET https://api.github.com/boom: 422 - Validation Failed')
        expect(e.message).not_to include('Error summary:')
      end
    end

    it 'handles errors array of strings' do
      stub_get('/boom')
        .to_return \
          status: 422,
          headers: { content_type: 'application/json' },
          body: {
            message: 'Validation Failed',
            errors: ['Issue 1', 'Issue 2']
          }.to_json
      begin
        Octokit.get('/boom')
      rescue Octokit::UnprocessableEntity => e
        expect(e.message).to include('GET https://api.github.com/boom: 422 - Validation Failed')
        expect(e.message).to include('Error summary:')
        expect(e.message).to include('Issue 1')
        expect(e.message).to include('Issue 2')
      end
    end

    it 'handles errors with special characters' do
      stub_get('/boom')
        .to_return \
          status: 422,
          headers: { content_type: 'application/json' },
          body: {
            message: 'Validation Failed',
            errors: 'Error with <special> characters & symbols'
          }.to_json
      begin
        Octokit.get('/boom')
      rescue Octokit::UnprocessableEntity => e
        expect(e.message).to include('GET https://api.github.com/boom: 422 - Validation Failed')
        expect(e.message).to include('Error summary:')
        expect(e.message).to include('Error with <special> characters & symbols')
      end
    end

    it 'handles nested structures in errors' do
      stub_get('/boom')
        .to_return \
          status: 422,
          headers: { content_type: 'application/json' },
          body: {
            message: 'Validation Failed',
            errors: [
              { field: 'some field', issue: 'some issue' },
              { details: { subfield: 'value' } }
            ]
          }.to_json
      begin
        Octokit.get('/boom')
      rescue Octokit::UnprocessableEntity => e
        expect(e.message).to include('GET https://api.github.com/boom: 422 - Validation Failed')
        expect(e.message).to include('Error summary:')
        expect(e.message).to include('field: some field')
        expect(e.message).to include('issue: some issue')
        # Ruby, depending on the version, may format the hash differently
        # either with a ligature (=>) or a colon (:)
        # '{:subfield => "value"}' or '{subfield: "value"}'
        # so we use a regex to match either for the test assertion
        expect(e.message).to match(
          /details: \{(?::subfield\s*=>\s*"value"|subfield:\s*"value")\}/
        )
      end
    end

    it 'handles mixed-type errors array' do
      stub_get('/boom')
        .to_return \
          status: 422,
          headers: { content_type: 'application/json' },
          body: {
            message: 'Validation Failed',
            errors: ['Issue', { field: 'some field', issue: 'some issue' }]
          }.to_json
      begin
        Octokit.get('/boom')
      rescue Octokit::UnprocessableEntity => e
        expect(e.message).to include('GET https://api.github.com/boom: 422 - Validation Failed')
        expect(e.message).to include('Error summary:')
        expect(e.message).to include('Issue')
        expect(e.message).to include('field: some field')
        expect(e.message).to include('issue: some issue')
      end
    end

    it 'knows the difference between different kinds of forbidden' do
      stub_get('/some/admin/stuffs').to_return(status: 403)
      expect { Octokit.get('/some/admin/stuffs') }.to raise_error Octokit::Forbidden

      stub_get('/users/mojomobo').to_return \
        status: 403,
        headers: {
          content_type: 'application/json'
        },
        body: { message: 'API rate limit exceeded' }.to_json
      expect { Octokit.get('/users/mojomobo') }.to raise_error(Octokit::TooManyRequests, /API rate limit exceeded/)

      stub_get('/users/mojomobo').to_return \
        status: 403,
        headers: {
          content_type: 'application/json'
        },
        body: { message: 'You have exceeded a secondary rate limit.' }.to_json
      expect { Octokit.get('/users/mojomobo') }.to raise_error(Octokit::TooManyRequests, /You have exceeded a secondary rate limit./)

      stub_get('/user').to_return \
        status: 403,
        headers: {
          content_type: 'application/json'
        },
        body: { message: 'Maximum number of login attempts exceeded' }.to_json
      expect { Octokit.get('/user') }.to raise_error Octokit::TooManyLoginAttempts

      stub_get('/user').to_return \
        status: 403,
        headers: {
          content_type: 'application/json'
        },
        body: { message: 'This API returns blobs up to 1 MB in size' }.to_json
      expect { Octokit.get('/user') }.to raise_error Octokit::TooLargeContent

      stub_get('/user').to_return \
        status: 403,
        headers: {
          content_type: 'application/json'
        },
        body: { message: 'for this endpoint for blobs between 1-100 MB.' }.to_json
      expect { Octokit.get('/user') }.to raise_error Octokit::TooLargeContent

      stub_get('/user').to_return \
        status: 403,
        headers: {
          content_type: 'application/json'
        },
        body: { message: 'You have triggered an abuse detection mechanism and have been temporarily blocked from content creation. Please retry your request again later.' }.to_json
      expect { Octokit.get('/user') }.to raise_error Octokit::AbuseDetected

      stub_get('/blocked/repository').to_return \
        status: 403,
        headers: {
          content_type: 'application/json'
        },
        body: { message: 'Repository access blocked' }.to_json
      expect { Octokit.get('/blocked/repository') }.to raise_error Octokit::RepositoryUnavailable

      stub_post('/user/repos').to_return \
        status: 403,
        headers: {
          content_type: 'application/json'
        },
        body: { message: 'At least one email address must be verified to do that' }.to_json
      expect { Octokit.post('/user/repos') }.to raise_error Octokit::UnverifiedEmail

      stub_post('/user/repos').to_return \
        status: 403,
        headers: {
          content_type: 'application/json'
        },
        body: { message: 'Sorry. Your account was suspended. Please contact github-enterprise@example.com' }.to_json
      expect { Octokit.post('/user/repos') }.to raise_error Octokit::AccountSuspended

      stub_post('/user/repos').to_return \
        status: 403,
        headers: {
          content_type: 'application/json'
        },
        body: { message: 'The repository has been disabled due to a billing issue with the owner account.' }.to_json
      expect { Octokit.post('/user/repos') }.to raise_error Octokit::BillingIssue

      stub_get('/teams/8675309').to_return \
        status: 403,
        headers: {
          content_type: 'application/json'
        },
        body: { message: 'Resource protected by organization SAML enforcement. You must grant your personal token access to this organization.' }.to_json
      expect { Octokit.get('/teams/8675309') }.to raise_error Octokit::SAMLProtected

      stub_get('/torrentz').to_return \
        status: 451,
        headers: {
          content_type: 'application/json'
        }
      expect { Octokit.get('/torrentz') }.to raise_error Octokit::UnavailableForLegalReasons

      stub_post('/installation/repositories').to_return \
        status: 403,
        headers: {
          content_type: 'application/json'
        },
        body: { message: 'This installation owned by octocat suspended your access at 2020-08-28T16:32:59Z.' }.to_json
      expect { Octokit.post('/installation/repositories') }.to raise_error Octokit::InstallationSuspended

      stub_post('/app/installations/12345/access_tokens').to_return \
        status: 403,
        headers: {
          content_type: 'application/json'
        },
        body: { message: 'This installation has been suspended // See: https://docs.github.com/rest/reference/apps#create-an-installation-access-token-for-an-app' }.to_json
      expect { Octokit.post('/app/installations/12345/access_tokens') }.to raise_error Octokit::InstallationSuspended
    end

    it 'knows the difference between different kinds of unprocessable entity' do
      stub_get('/some/admin/stuffs').to_return(status: 422)
      expect { Octokit.get('/some/admin/stuffs') }.to raise_error Octokit::UnprocessableEntity

      stub_post('/repositories/123456789/pulls/1/comments').to_return \
        status: 422,
        headers: {
          content_type: 'application/json'
        },
        body: {
          message: 'Validation Failed',
          errors: [
            'end_commit_oid is not part of the pull request',
            { resource: 'PullRequestReviewComment',
              field: 'end_commit_oid',
              code: 'custom' }
          ]
        }.to_json
      expect { Octokit.post('/repositories/123456789/pulls/1/comments') }.to raise_error Octokit::CommitIsNotPartOfPullRequest

      stub_post('/repositories/123456789/pulls/21/comments').to_return \
        status: 422,
        headers: {
          content_type: 'application/json'
        },
        body: {
          message: 'Validation Failed',
          errors: [
            message: 'path diff too large',
            resource: 'PullRequestReviewComment',
            field: 'path',
            code: 'custom'
          ]
        }.to_json
      expect { Octokit.post('/repositories/123456789/pulls/21/comments') }.to raise_error Octokit::PathDiffTooLarge
    end

    it 'raises on unknown client errors' do
      stub_get('/user').to_return \
        status: 418,
        headers: {
          content_type: 'application/json'
        },
        body: { message: "I'm a teapot" }.to_json
      expect { Octokit.get('/user') }.to raise_error Octokit::ClientError
    end

    it 'raises on unknown server errors' do
      stub_get('/user').to_return \
        status: 509,
        headers: {
          content_type: 'application/json'
        },
        body: { message: 'Bandwidth exceeded' }.to_json
      expect { Octokit.get('/user') }.to raise_error Octokit::ServerError
    end

    it 'resets last_response on errors' do
      stub_get('/booya').to_return(status: 200)
      stub_get('/user').to_return \
        status: 509,
        headers: {
          content_type: 'application/json'
        },
        body: { message: 'Bandwidth exceeded' }.to_json

      client = Octokit.client
      client.get('/booya')
      expect(client.last_response).to_not be_nil
      expect { client.get('/user') }.to raise_error Octokit::ServerError
      expect(client.last_response).to be_nil
    end

    it 'handles documentation URLs in error messages' do
      stub_get('/user').to_return \
        status: 415,
        headers: {
          content_type: 'application/json'
        },
        body: {
          message: 'Unsupported Media Type',
          documentation_url: 'http://developer.github.com/v3'
        }.to_json
      begin
        Octokit.get('/user')
      rescue Octokit::UnsupportedMediaType => e
        msg = '415 - Unsupported Media Type'
        expect(e.message).to include(msg)
        expect(e.documentation_url).to eq('http://developer.github.com/v3')
      end
    end

    it 'handles an error response with an array body' do
      stub_get('/user').to_return \
        status: 500,
        headers: {
          content_type: 'application/json'
        },
        body: [].to_json
      expect { Octokit.get('/user') }.to raise_error Octokit::ServerError
    end

    it 'exposes the response status code' do
      stub_get('/boom')
        .to_return \
          status: 422,
          headers: {
            content_type: 'application/json'
          },
          body: { error: 'No repository found for hubtopic' }.to_json
      begin
        Octokit.get('/boom')
      rescue Octokit::UnprocessableEntity => e
        expect(e.response_status).to eql 422
      end
    end

    it 'exposes the response headers' do
      stub_get('/boom')
        .to_return \
          status: 422,
          headers: {
            content_type: 'application/json'
          },
          body: { error: 'No repository found for hubtopic' }.to_json
      begin
        Octokit.get('/boom')
      rescue Octokit::UnprocessableEntity => e
        expect(e.response_headers).to eql({ 'content-type' => 'application/json' })
      end
    end

    it 'exposes the response body' do
      stub_get('/boom')
        .to_return \
          status: 422,
          headers: {
            content_type: 'application/json'
          },
          body: { error: 'No repository found for hubtopic' }.to_json
      begin
        Octokit.get('/boom')
      rescue Octokit::UnprocessableEntity => e
        expect(e.response_body).to eql({ error: 'No repository found for hubtopic' }.to_json)
      end
    end
  end

  it 'knows the difference between unauthorized and needs OTP' do
    stub_get('/authorizations').to_return(status: 401)
    expect { Octokit.get('/authorizations') }.to raise_error Octokit::Unauthorized

    stub_get('/authorizations/1').to_return \
      status: 401,
      headers: {
        :content_type => 'application/json',
        'X-GitHub-OTP' => 'required; sms'
      },
      body: { message: 'Must specify two-factor authentication OTP code.' }.to_json
    expect { Octokit.get('/authorizations/1') }.to raise_error Octokit::OneTimePasswordRequired
  end

  it 'knows the password delivery mechanism when needs OTP' do
    stub_get('/authorizations/1').to_return \
      status: 401,
      headers: {
        :content_type => 'application/json',
        'X-GitHub-OTP' => 'required; app'
      },
      body: { message: 'Must specify two-factor authentication OTP code.' }.to_json

    begin
      Octokit.get('/authorizations/1')
    rescue Octokit::OneTimePasswordRequired => e
      expect(e.password_delivery).to eql 'app'
    end
  end

  it 'returns empty context when non rate limit error occurs' do
    stub_get('/user').to_return \
      status: 509,
      headers: {
        content_type: 'application/json'
      },
      body: { message: 'Bandwidth exceeded' }.to_json
    begin
      Octokit.get('/user')
    rescue Octokit::ServerError => e
      expect(e.context).to be_nil
    end
  end

  it 'returns context with default data when rate limit error occurs but headers are missing' do
    stub_get('/user').to_return \
      status: 403,
      headers: {
        content_type: 'application/json'
      },
      body: { message: 'rate limit exceeded' }.to_json
    begin
      expect_any_instance_of(Faraday::Env).to receive(:headers).at_least(:once).and_return({})
      Octokit.get('/user')
    rescue Octokit::TooManyRequests => e
      expect(e.context).to be_an_instance_of(Octokit::RateLimit)
    end
  end

  it 'returns context when non rate limit error occurs but rate limit headers are present' do
    stub_get('/user').to_return \
      status: 403,
      headers: {
        'content_type' => 'application/json',
        'X-RateLimit-Limit' => 60,
        'X-RateLimit-Remaining' => 42,
        'X-RateLimit-Reset' => (Time.now + 60).to_i
      },
      body: { message: 'rate limit exceeded' }.to_json
    begin
      Octokit.get('/user')
    rescue Octokit::TooManyRequests => e
      expect(e.context).to be_an_instance_of(Octokit::RateLimit)
      expect(e.context.limit).to eql 60
      expect(e.context.remaining).to eql 42
    end
  end

  it 'returns context with default data when rate limit error occurs but headers are missing' do
    stub_get('/user').to_return \
      status: 403,
      headers: {
        content_type: 'application/json'
      },
      body: { message: 'You have exceeded a secondary rate limit.' }.to_json
    begin
      Octokit.get('/user')
    rescue Octokit::TooManyRequests => e
      expect(e.context).to be_an_instance_of(Octokit::RateLimit)
    end
  end

  it 'returns context when non rate limit error occurs but rate limit headers are present' do
    stub_get('/user').to_return \
      status: 403,
      headers: {
        'content_type' => 'application/json',
        'X-RateLimit-Limit' => 60,
        'X-RateLimit-Remaining' => 42,
        'X-RateLimit-Reset' => (Time.now + 60).to_i
      },
      body: { message: 'You have exceeded a secondary rate limit.' }.to_json
    begin
      Octokit.get('/user')
    rescue Octokit::TooManyRequests => e
      expect(e.context).to be_an_instance_of(Octokit::RateLimit)
      expect(e.context.limit).to eql 60
      expect(e.context.remaining).to eql 42
    end
  end

  describe 'module call shortcut' do
    before do
      Octokit.reset!
      @client = oauth_client
      @ent_manage_ghes_client = manage_ghes_client
    end

    it 'has no method collisions' do
      client_methods = collect_methods(Octokit::Client)
      admin_client = collect_methods(Octokit::EnterpriseAdminClient)
      manage_ghes_client = collect_methods(Octokit::ManageGHESClient)

      expect(client_methods & admin_client).to eql []
      expect(client_methods & manage_ghes_client).to eql []
      expect(admin_client & manage_ghes_client).to eql []
    end

    it 'uniquely separates method missing calls' do
      expect { @ent_manage_ghes_client.public_events }.to raise_error NoMethodError
    end

    def collect_methods(clazz)
      clazz.included_modules.select { |m| m.to_s =~ Regexp.new(clazz.to_s) }
           .collect(&:public_instance_methods).flatten
    end
  end

  describe 'rels parsing' do
    before do
      Octokit.reset!
      @client = oauth_client
    end

    it 'handles git@github ssh URLs', :vcr do
      repo = @client.repository('octokit/octokit.rb')
      expect(repo.rels[:ssh].href).to eq('git@github.com:octokit/octokit.rb.git')
    end
  end
end
