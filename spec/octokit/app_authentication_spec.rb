# frozen_string_literal: true

require 'openssl'
require 'json'
require 'base64'

describe Octokit::AppAuthentication do
  let(:app_id) { '12345' }
  let(:private_key_pem) { File.read(File.join(fixture_path, 'fake_integration.private-key.pem')) }
  let(:private_key) { OpenSSL::PKey::RSA.new(private_key_pem) }
  let(:installation_id) { 67_890 }

  before do
    Octokit.reset!
  end

  after do
    Octokit.reset!
  end

  describe '#app_authenticated?' do
    it 'returns true when app_id and private_key are set' do
      client = Octokit::Client.new(app_id: app_id, private_key: private_key_pem)
      expect(client.app_authenticated?).to be true
    end

    it 'returns false when only app_id is set' do
      client = Octokit::Client.new(app_id: app_id)
      expect(client.app_authenticated?).to be false
    end

    it 'returns false when only private_key is set' do
      client = Octokit::Client.new(private_key: private_key_pem)
      expect(client.app_authenticated?).to be false
    end

    it 'returns false when neither is set' do
      client = Octokit::Client.new
      expect(client.app_authenticated?).to be false
    end
  end

  describe '#installation_authenticated?' do
    it 'returns true when app_id, private_key, and installation_id are set' do
      client = Octokit::Client.new(
        app_id: app_id,
        private_key: private_key_pem,
        installation_id: installation_id
      )
      expect(client.installation_authenticated?).to be true
    end

    it 'returns false when installation_id is missing' do
      client = Octokit::Client.new(app_id: app_id, private_key: private_key_pem)
      expect(client.installation_authenticated?).to be false
    end

    it 'returns false when app credentials are missing' do
      client = Octokit::Client.new(installation_id: installation_id)
      expect(client.installation_authenticated?).to be false
    end
  end

  describe '#generate_app_jwt' do
    let(:client) { Octokit::Client.new(app_id: app_id, private_key: private_key_pem) }

    it 'returns a valid JWT string' do
      jwt = client.generate_app_jwt
      expect(jwt).to be_a(String)
      expect(jwt.split('.').length).to eq(3)
    end

    it 'generates a JWT with correct claims' do
      jwt = client.generate_app_jwt
      parts = jwt.split('.')
      payload = JSON.parse(Base64.urlsafe_decode64(parts[1]))

      expect(payload['iss']).to eq(app_id)
      expect(payload['iat']).to be_a(Integer)
      expect(payload['exp']).to be_a(Integer)
      expect(payload['exp'] - payload['iat']).to eq(11 * 60) # iat is 60s in past, exp is 10 min from now
    end

    it 'generates a JWT with RS256 algorithm' do
      jwt = client.generate_app_jwt
      parts = jwt.split('.')
      header = JSON.parse(Base64.urlsafe_decode64(parts[0]))

      expect(header['alg']).to eq('RS256')
      expect(header['typ']).to eq('JWT')
    end

    it 'generates a JWT with a valid RS256 signature' do
      jwt = client.generate_app_jwt
      parts = jwt.split('.')
      signing_input = "#{parts[0]}.#{parts[1]}"
      signature = Base64.urlsafe_decode64(parts[2])

      # Verify the signature using the public key
      public_key = private_key.public_key
      expect(public_key.verify(OpenSSL::Digest::SHA256.new, signature, signing_input)).to be true
    end

    it 'caches the JWT across calls' do
      jwt1 = client.generate_app_jwt
      jwt2 = client.generate_app_jwt
      expect(jwt1).to eq(jwt2)
    end

    it 'accepts an OpenSSL::PKey::RSA object' do
      client = Octokit::Client.new(app_id: app_id, private_key: private_key)
      jwt = client.generate_app_jwt
      expect(jwt.split('.').length).to eq(3)
    end

    it 'raises an error for invalid private_key type' do
      client = Octokit::Client.new(app_id: app_id, private_key: 12_345)
      expect { client.generate_app_jwt }.to raise_error(ArgumentError, /private_key must be/)
    end
  end

  describe 'automatic JWT authentication' do
    let(:client) { Octokit::Client.new(app_id: app_id, private_key: private_key_pem) }

    it 'sets bearer_token automatically on first request' do
      stub_get('https://api.github.com/app')
        .to_return(status: 200, body: '{"id": 1}', headers: { 'Content-Type' => 'application/json' })

      client.app
      expect(client.bearer_token).not_to be_nil
      expect(client.bearer_token.split('.').length).to eq(3)
    end

    it 'uses Bearer auth for API requests' do
      stub_get('https://api.github.com/app')
        .to_return(status: 200, body: '{"id": 1}', headers: { 'Content-Type' => 'application/json' })

      client.app
      assert_requested :get, 'https://api.github.com/app',
                       headers: { 'Authorization' => /^Bearer .+/ }
    end
  end

  describe 'automatic installation token authentication' do
    let(:client) do
      Octokit::Client.new(
        app_id: app_id,
        private_key: private_key_pem,
        installation_id: installation_id
      )
    end

    let(:token_response) do
      {
        token: 'ghs_test_installation_token',
        expires_at: (Time.now + 3600).utc.iso8601
      }.to_json
    end

    it 'exchanges JWT for installation token on first request' do
      # First, the client will POST to create installation access token
      stub_post("https://api.github.com/app/installations/#{installation_id}/access_tokens")
        .to_return(
          status: 201,
          body: token_response,
          headers: { 'Content-Type' => 'application/json' }
        )

      # Then it uses the installation token for the actual request
      stub_get('https://api.github.com/repos/octokit/octokit.rb/issues')
        .to_return(
          status: 200,
          body: '[]',
          headers: { 'Content-Type' => 'application/json' }
        )

      client.issues('octokit/octokit.rb')

      assert_requested :post,
                       "https://api.github.com/app/installations/#{installation_id}/access_tokens",
                       headers: { 'Authorization' => /^Bearer .+/ }
      expect(client.access_token).to eq('ghs_test_installation_token')
    end

    it 'caches the installation token across requests' do
      stub_post("https://api.github.com/app/installations/#{installation_id}/access_tokens")
        .to_return(
          status: 201,
          body: token_response,
          headers: { 'Content-Type' => 'application/json' }
        )

      stub_get('https://api.github.com/repos/octokit/octokit.rb/issues')
        .to_return(
          status: 200,
          body: '[]',
          headers: { 'Content-Type' => 'application/json' }
        )

      # First request triggers token exchange
      client.issues('octokit/octokit.rb')
      # Second request should reuse the cached token
      client.issues('octokit/octokit.rb')

      # Token endpoint should only be called once
      assert_requested :post,
                       "https://api.github.com/app/installations/#{installation_id}/access_tokens",
                       times: 1
    end
  end

  describe 'JWT refresh' do
    let(:client) { Octokit::Client.new(app_id: app_id, private_key: private_key_pem) }

    it 'regenerates JWT when expired' do
      client.generate_app_jwt

      # Simulate expiry and a stale bearer token
      client.instance_variable_set(:@jwt_expires_at, Time.now - 60)
      client.instance_variable_set(:@bearer_token, 'stale_token')

      jwt = client.generate_app_jwt
      expect(jwt).not_to eq('stale_token')
      expect(jwt.split('.').length).to eq(3)
    end
  end

  describe 'setters' do
    it 'resets token state when app_id changes' do
      client = Octokit::Client.new(app_id: app_id, private_key: private_key_pem)
      client.generate_app_jwt
      expect(client.instance_variable_get(:@jwt_expires_at)).not_to be_nil

      client.app_id = '99999'
      expect(client.instance_variable_get(:@jwt_expires_at)).to be_nil
    end

    it 'resets token state when private_key changes' do
      client = Octokit::Client.new(app_id: app_id, private_key: private_key_pem)
      client.generate_app_jwt
      expect(client.instance_variable_get(:@jwt_expires_at)).not_to be_nil

      client.private_key = private_key_pem
      expect(client.instance_variable_get(:@jwt_expires_at)).to be_nil
      expect(client.instance_variable_get(:@resolved_private_key)).to be_nil
    end

    it 'resets installation token state when installation_id changes' do
      client = Octokit::Client.new(
        app_id: app_id,
        private_key: private_key_pem,
        installation_id: installation_id
      )
      client.instance_variable_set(:@installation_token_expires_at, Time.now + 3600)

      client.installation_id = 11_111
      expect(client.instance_variable_get(:@installation_token_expires_at)).to be_nil
    end
  end

  describe 'inspect' do
    it 'masks the private key in inspect output' do
      client = Octokit::Client.new(app_id: app_id, private_key: private_key_pem)
      inspected = client.inspect
      expect(inspected).not_to include('BEGIN RSA PRIVATE KEY')
      expect(inspected).to include('********')
    end
  end

  describe 'configuration via ENV' do
    it 'reads app_id from OCTOKIT_APP_ID' do
      allow(ENV).to receive(:fetch).and_call_original
      allow(ENV).to receive(:fetch).with('OCTOKIT_APP_ID', nil).and_return('env_app_id')

      Octokit.reset!
      expect(Octokit::Default.app_id).to eq('env_app_id')
    end

    it 'reads installation_id from OCTOKIT_INSTALLATION_ID' do
      allow(ENV).to receive(:fetch).and_call_original
      allow(ENV).to receive(:fetch).with('OCTOKIT_INSTALLATION_ID', nil).and_return('12345')

      Octokit.reset!
      expect(Octokit::Default.installation_id).to eq('12345')
    end

    it 'reads private_key from OCTOKIT_PRIVATE_KEY' do
      allow(ENV).to receive(:fetch).and_call_original
      allow(ENV).to receive(:fetch).with('OCTOKIT_PRIVATE_KEY', nil).and_return('pem_data')

      Octokit.reset!
      expect(Octokit::Default.private_key).to eq('pem_data')
    end
  end
end
