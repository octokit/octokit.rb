# frozen_string_literal: true

require 'openssl'
require 'json'
require 'base64'
require 'timecop'

describe Octokit::AppAuthentication do
  let(:now) { Time.utc(2026, 1, 1, 12) }
  let(:app_id) { '12345' }
  let(:private_key_pem) { File.read(File.join(fixture_path, 'fake_integration.private-key.pem')) }
  let(:private_key) { OpenSSL::PKey::RSA.new(private_key_pem) }
  let(:installation_id) { 67_890 }
  let(:app_options) { { app_id: app_id, private_key: private_key_pem } }
  let(:client) { Octokit::Client.new(app_options) }
  let(:issues_path) { '/repos/octokit/octokit.rb/issues' }

  around do |example|
    Timecop.freeze(now) { example.run }
  end

  before do
    Octokit.reset!
    stub_get('/app').to_return(status: 200, body: '{"id": 1}', headers: { 'Content-Type' => 'application/json' })
    stub_get('/user').to_return(status: 200, body: '{"login": "octokit"}', headers: { 'Content-Type' => 'application/json' })
    stub_get(issues_path).to_return(status: 200, body: '[]', headers: { 'Content-Type' => 'application/json' })
  end

  after do
    Octokit.reset!
  end

  def stub_token_exchange(id = installation_id)
    exchanges = 0
    stub_post("/app/installations/#{id}/access_tokens").to_return do
      exchanges += 1
      {
        status: 201,
        body: { token: "ghs_#{id}_#{exchanges}", expires_at: (Time.now + 3600).iso8601 }.to_json,
        headers: { 'Content-Type' => 'application/json' }
      }
    end
  end

  describe 'authentication predicates' do
    it 'recognizes App credentials without requiring an installation' do
      expect(client.app_authenticated?).to be true
      expect(client.installation_authenticated?).to be false
    end

    it 'recognizes installation credentials' do
      client.installation_id = installation_id
      expect(client.installation_authenticated?).to be true
    end

    [{}, { app_id: '12345' }, { private_key: 'key' }, { app_id: '', private_key: '' }].each do |options|
      it "does not authenticate with incomplete credentials #{options.keys}" do
        client = Octokit::Client.new(options)
        expect(client.app_authenticated?).to be false
        expect(client.installation_authenticated?).to be false
      end
    end

    it 'ignores an empty installation ID' do
      client.installation_id = ''
      expect(client.installation_authenticated?).to be false
    end
  end

  describe '#generate_app_jwt' do
    it 'signs the expected claims with RS256' do
      jwt = client.generate_app_jwt
      header, payload, signature = jwt.split('.')

      expect(JSON.parse(Base64.urlsafe_decode64(header))).to eq('alg' => 'RS256', 'typ' => 'JWT')
      expect(JSON.parse(Base64.urlsafe_decode64(payload)))
        .to eq('iat' => now.to_i - 60, 'exp' => now.to_i + 600, 'iss' => app_id)
      expect(private_key.public_key.verify(
               OpenSSL::Digest.new('SHA256'), Base64.urlsafe_decode64(signature), "#{header}.#{payload}"
             )).to be true
    end

    it 'caches JWTs until the refresh boundary' do
      jwt = client.generate_app_jwt
      Timecop.freeze(now + 479) { expect(client.generate_app_jwt).to equal(jwt) }
      Timecop.freeze(now + 480) { expect(client.generate_app_jwt).not_to eq(jwt) }
    end

    it 'accepts an RSA private key object' do
      client.private_key = private_key
      expect(client.generate_app_jwt.split('.').length).to eq(3)
    end

    it 'does not overwrite configured access or bearer tokens' do
      client.access_token = 'configured-access-token'
      client.bearer_token = 'configured-bearer-token'
      client.generate_app_jwt

      expect(client.access_token).to eq('configured-access-token')
      expect(client.bearer_token).to eq('configured-bearer-token')
    end

    it 'requires App credentials' do
      expect { Octokit::Client.new.generate_app_jwt }
        .to raise_error(Octokit::AppAuthenticationError, /app_id and private_key/)
    end

    it 'reports invalid key types' do
      client.private_key = 123
      expect { client.generate_app_jwt }.to raise_error(Octokit::AppAuthenticationError, /private_key must be/)
    end

    it 'reports invalid PEM keys' do
      client.private_key = 'not a private key'
      expect { client.generate_app_jwt }.to raise_error(Octokit::AppAuthenticationError, /Invalid GitHub App private key/)
    end

    it 'rejects public-only keys' do
      client.private_key = private_key.public_key
      expect { client.generate_app_jwt }.to raise_error(Octokit::AppAuthenticationError, /must include a private key/)
    end
  end

  describe 'request-time authentication' do
    it 'refreshes JWTs without rebuilding a retained agent' do
      agent = client.agent
      agent.call(:get, '/app')
      first_jwt = client.generate_app_jwt
      Timecop.freeze(now + 480) { agent.call(:get, '/app') }

      expect(client.agent).to equal(agent)
      assert_requested :get, github_url('/app'), headers: { 'Authorization' => "Bearer #{first_jwt}" }, times: 1
      assert_requested :get, github_url('/app'), times: 2
      expect(client.bearer_token).to be_nil
    end

    it 'gives App credentials precedence over other configured credentials' do
      client.login = 'user'
      client.password = 'password'
      client.access_token = 'configured-access-token'
      client.app

      assert_requested :get, github_url('/app'), headers: { 'Authorization' => "Bearer #{client.generate_app_jwt}" }
    end

    it 'does not parse a key or authenticate while building connections' do
      client.private_key = 'invalid key'
      expect(client.agent).to be_a(Sawyer::Agent)
      expect(client.client_without_redirects).to be_a(Faraday::Connection)
      expect { client.app }.to raise_error(Octokit::AppAuthenticationError)
    end

    it 'honors explicit authorization without generating credentials' do
      client.private_key = 'invalid key'
      client.get('/app', headers: { 'Authorization' => 'token explicit-token' })

      assert_requested :get, github_url('/app'), headers: { 'Authorization' => 'token explicit-token' }
    end
  end

  describe 'installation authentication' do
    let(:client) { Octokit::Client.new(app_options.merge(installation_id: installation_id)) }
    let(:token_request) { stub_token_exchange }

    before do
      token_request
    end

    it 'does not exchange tokens until an authenticated request is sent' do
      client.agent
      client.client_without_redirects
      client.get(issues_path, headers: { 'Authorization' => 'token explicit-token' })
      assert_not_requested token_request
    end

    it 'exchanges a JWT and caches the installation token' do
      2.times { client.issues('octokit/octokit.rb') }

      assert_requested token_request, times: 1
      assert_requested :post, github_url("/app/installations/#{installation_id}/access_tokens"),
                       headers: { 'Authorization' => "Bearer #{client.generate_app_jwt}" }
      assert_requested :get, github_url(issues_path),
                       headers: { 'Authorization' => "token ghs_#{installation_id}_1" }, times: 2
      expect(client.access_token).to be_nil
    end

    it 'refreshes tokens at the two-minute expiry margin through a retained agent' do
      agent = client.agent
      agent.call(:get, issues_path)
      Timecop.freeze(now + 3479) { agent.call(:get, issues_path) }
      assert_requested token_request, times: 1
      Timecop.freeze(now + 3480) { agent.call(:get, issues_path) }

      expect(client.agent).to equal(agent)
      assert_requested token_request, times: 2
      assert_requested :get, github_url(issues_path),
                       headers: { 'Authorization' => "token ghs_#{installation_id}_2" }, times: 1
    end

    it 'refreshes tokens through a retained no-redirect connection' do
      connection = client.client_without_redirects
      connection.get(issues_path)
      Timecop.freeze(now + 3600) { connection.get(issues_path) }

      assert_requested token_request, times: 2
      assert_requested :get, github_url(issues_path),
                       headers: { 'Authorization' => "token ghs_#{installation_id}_2" }, times: 1
    end

    it 'does not send credentials to a redirected host' do
      stub_get(issues_path).to_return(status: 302, headers: { 'Location' => 'https://download.example.com/file' })
      redirected = stub_get('https://download.example.com/file')
                   .with(headers: { 'Authorization' => 'dummy' }).to_return(status: 200)
      client.get(issues_path)

      assert_requested redirected
      assert_requested token_request, times: 1
    end

    it 'serializes first-use and expiry refreshes across concurrent requests' do
      shared_client = client
      2.times do |round|
        Timecop.freeze(now + (round * 3600)) do
          ready = Queue.new
          start = Queue.new
          threads = 8.times.map do
            Thread.new do
              ready << true
              start.pop
              shared_client.issues('octokit/octokit.rb')
            end
          end
          8.times { ready.pop }
          8.times { start << true }
          threads.each(&:value)
        end
      end

      assert_requested token_request, times: 2
    end

    it 'uses global App configuration without recursion or discarding the module client' do
      app_options.merge(installation_id: installation_id, access_token: 'ambient-token').each do |key, value|
        Octokit.public_send("#{key}=", value)
      end
      module_client = Octokit.client
      2.times { Octokit.issues('octokit/octokit.rb') }

      expect(Octokit.client).to equal(module_client)
      expect(Octokit.last_response.status).to eq(200)
      assert_requested token_request, times: 1
    end

    it 'authenticates with environment-backed credentials' do
      allow(ENV).to receive(:fetch).and_call_original
      allow(ENV).to receive(:fetch).with('OCTOKIT_APP_ID', nil).and_return(app_id)
      allow(ENV).to receive(:fetch).with('OCTOKIT_PRIVATE_KEY', nil).and_return(private_key_pem)
      allow(ENV).to receive(:fetch).with('OCTOKIT_INSTALLATION_ID', nil).and_return(installation_id.to_s)
      Octokit.reset!
      Octokit.issues('octokit/octokit.rb')

      assert_requested token_request, times: 1
    end

    [
      {},
      { token: 'token' },
      { token: 123, expires_at: '2026-01-01T13:00:00Z' },
      { token: 'token', expires_at: 'invalid-date' },
      []
    ].each do |data|
      it "rejects a malformed exchange response #{data}" do
        stub_post("/app/installations/#{installation_id}/access_tokens")
          .to_return(status: 201, body: data.to_json, headers: { 'Content-Type' => 'application/json' })
        expect { client.get(issues_path) }.to raise_error(Octokit::AppAuthenticationError)
        expect(client.last_response).to be_nil
      end
    end

    it 'preserves HTTP errors from token exchange and allows a later retry' do
      stub_post("/app/installations/#{installation_id}/access_tokens").to_return(status: 404)
      expect { client.get(issues_path) }.to raise_error(Octokit::NotFound)
      retry_request = stub_token_exchange
      client.get(issues_path)

      assert_requested retry_request, times: 2
    end

    it 'does not expose generated credentials or the private key in inspect' do
      long_token = "ghs_12345_#{'a' * 180}.#{'b' * 180}.#{'c' * 150}"
      stub_post("/app/installations/#{installation_id}/access_tokens")
        .to_return(
          status: 201, body: { token: long_token, expires_at: (now + 3600).iso8601 }.to_json,
          headers: { 'Content-Type' => 'application/json' }
        )
      client.get(issues_path)

      expect(client.inspect).not_to include(long_token[36..], client.generate_app_jwt, 'BEGIN RSA PRIVATE KEY')
    end

    context 'following relations' do
      before do
        first_page = {
          status: 200, body: '[{"id":1}]',
          headers: {
            'Content-Type' => 'application/json',
            'Link' => "<#{github_url(issues_path)}?page=2>; rel=\"next\"",
            'X-RateLimit-Limit' => '5000', 'X-RateLimit-Remaining' => '4999',
            'X-RateLimit-Reset' => (now + 7200).to_i.to_s
          }
        }
        stub_get("#{issues_path}?per_page=100").to_return do
          Timecop.travel(now + 3600) if client.auto_paginate
          first_page
        end
        stub_get("#{issues_path}?page=2").to_return(
          status: 200, body: '[{"id":2}]', headers: { 'Content-Type' => 'application/json' }
        )
      end

      it 'refreshes during auto-pagination without replacing the agent' do
        client.auto_paginate = true
        agent = client.agent
        result = client.paginate(issues_path) do |data, response|
          data.concat(response.data)
        end
        expect(result.map(&:id)).to eq([1, 2])
        expect(client.agent).to equal(agent)
        assert_requested token_request, times: 2
        assert_requested :get, github_url("#{issues_path}?page=2"),
                         headers: { 'Authorization' => "token ghs_#{installation_id}_2" }
      end

      it 'refreshes when a saved Sawyer relation is followed later' do
        client.get(issues_path, per_page: 100)
        relation = client.last_response.rels[:next]
        agent = relation.agent
        Timecop.freeze(now + 3600) { expect(relation.get.data.first.id).to eq(2) }

        expect(relation.agent).to equal(agent)
        assert_requested token_request, times: 2
        assert_requested :get, github_url("#{issues_path}?page=2"),
                         headers: { 'Authorization' => "token ghs_#{installation_id}_2" }
      end
    end
  end

  describe 'installation transport' do
    it 'shares TLS, proxy, middleware, headers and request options without mutating configuration' do
      transport_header = Class.new(Faraday::Middleware) do
        def call(env)
          env.request_headers['X-Transport'] = 'custom'
          @app.call(env)
        end
      end
      middleware = Octokit.middleware.dup
      middleware.use transport_header
      options = {
        ssl: { ca_file: '/company/ca.pem', ca_path: '/company/certs', client_key: private_key }.freeze,
        request: { timeout: 17, open_timeout: 5 }.freeze,
        headers: { 'X-Custom' => 'value' }.freeze
      }.freeze
      client = Octokit::Client.new(app_options.merge(
                                     installation_id: installation_id,
                                     connection_options: options, middleware: middleware,
                                     user_agent: 'Custom App Client', proxy: 'http://proxy.example.com:8080'
                                   ))
      connections = []
      allow(Faraday).to receive(:new).and_wrap_original do |constructor, *args, &block|
        connection = constructor.call(*args, &block)
        connections << connection
        connection
      end
      token_request = stub_token_exchange

      client.get(issues_path)

      expect(connections.size).to eq(2)
      connections.each do |connection|
        expect(connection.ssl.to_h).to include(options[:ssl])
        expect(connection.options.to_h).to include(options[:request])
        expect(connection.proxy.uri.to_s).to eq('http://proxy.example.com:8080')
      end
      expect(client.connection_options).to equal(options)
      expect(options[:ssl]).not_to have_key(:verify_mode)
      expect(middleware.handlers).not_to include(Octokit::Middleware::Authorization)
      assert_requested token_request, times: 1
      [github_url(issues_path), github_url("/app/installations/#{installation_id}/access_tokens")].each do |url|
        assert_requested(url.include?('/access_tokens') ? :post : :get, url,
                         headers: { 'User-Agent' => 'Custom App Client', 'X-Custom' => 'value', 'X-Transport' => 'custom' })
      end
    end
  end

  describe 'configuration lifecycle' do
    it 'regenerates a JWT after changing the App ID' do
      client.generate_app_jwt
      client.app_id = '99999'
      claims = JSON.parse(Base64.urlsafe_decode64(client.generate_app_jwt.split('.')[1]))
      expect(claims['iss']).to eq('99999')
    end

    it 'invalidates the parsed private key when the key changes' do
      client.generate_app_jwt
      client.private_key = 'invalid key'
      expect { client.generate_app_jwt }.to raise_error(Octokit::AppAuthenticationError)
    end

    it 'switches installation identities without retaining the old token' do
      first_request = stub_token_exchange
      second_request = stub_token_exchange(111)
      client.installation_id = installation_id
      client.get(issues_path)
      client.installation_id = 111
      client.get(issues_path)
      client.installation_id = nil
      client.app

      assert_requested first_request, times: 1
      assert_requested second_request, times: 1
      assert_requested :get, github_url(issues_path), headers: { 'Authorization' => 'token ghs_111_1' }
      assert_requested :get, github_url('/app'), headers: { 'Authorization' => "Bearer #{client.generate_app_jwt}" }
    end

    it 'falls back to a configured access token when App credentials are cleared' do
      client.access_token = 'configured-access-token'
      agent = client.agent
      agent.call(:get, '/app')
      client.app_id = nil
      agent.call(:get, '/user')
      assert_requested :get, github_url('/user'), headers: { 'Authorization' => 'token configured-access-token' }
    end

    %i[reset! setup].each do |method|
      it "clears credentials and responses through #{method}, including on retained connections" do
        client.app
        old_agent = client.agent
        client.public_send(method)
        expect(client.app_authenticated?).to be false
        expect(client.last_response).to be_nil
        expect(client.agent).not_to equal(old_agent)
        unauthenticated = stub_get('/user')
                          .with { |request| !request.headers.key?('Authorization') }
                          .to_return(status: 200)
        old_agent.call(:get, '/user')
        client.user
        assert_requested unauthenticated, times: 2
      end
    end

    it 'reloads environment credentials and discards cached installation tokens on reset' do
      request = stub_token_exchange
      allow(ENV).to receive(:fetch).and_call_original
      allow(ENV).to receive(:fetch).with('OCTOKIT_APP_ID', nil).and_return(app_id)
      allow(ENV).to receive(:fetch).with('OCTOKIT_PRIVATE_KEY', nil).and_return(private_key_pem)
      allow(ENV).to receive(:fetch).with('OCTOKIT_INSTALLATION_ID', nil).and_return(installation_id.to_s)
      client.reset!
      client.get(issues_path)
      client.reset!
      client.get(issues_path)
      assert_requested request, times: 2
    end

    it 'binds duplicated clients to their own credentials' do
      original_agent = client.agent
      client.app
      copy = client.dup
      copy.app_id = '99999'
      copy.app

      expect(copy.agent).not_to equal(original_agent)
      expect(client.app_id).to eq(app_id)
      assert_requested :get, github_url('/app'), headers: { 'Authorization' => "Bearer #{copy.generate_app_jwt}" }
    end

    it 'does not reuse installation tokens across API endpoints' do
      request = stub_token_exchange
      client.installation_id = installation_id
      client.get(issues_path)
      client.api_endpoint = 'https://github.example.com/api/v3/'
      exchange = stub_post("https://github.example.com/api/v3/app/installations/#{installation_id}/access_tokens")
                 .to_return(
                   status: 201, body: { token: 'ghs_enterprise', expires_at: (now + 3600).iso8601 }.to_json,
                   headers: { 'Content-Type' => 'application/json' }
                 )
      endpoint = stub_get('https://github.example.com/api/v3/repos/octokit/octokit.rb/issues')
                 .with(headers: { 'Authorization' => 'token ghs_enterprise' })
                 .to_return(status: 200)
      client.get('repos/octokit/octokit.rb/issues')
      assert_requested request, times: 1
      assert_requested exchange, times: 1
      assert_requested endpoint
    end

    it 'ignores empty environment credentials' do
      allow(ENV).to receive(:fetch).and_call_original
      allow(ENV).to receive(:fetch).with('OCTOKIT_APP_ID', nil).and_return('')
      allow(ENV).to receive(:fetch).with('OCTOKIT_PRIVATE_KEY', nil).and_return('')
      Octokit.reset!
      client = Octokit::Client.new(access_token: 'configured-access-token')
      client.user
      expect(client.app_authenticated?).to be false
      assert_requested :get, github_url('/user'), headers: { 'Authorization' => 'token configured-access-token' }
    end
  end
end
