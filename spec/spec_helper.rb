# frozen_string_literal: true

if RUBY_ENGINE == 'ruby'
  require 'simplecov'
  SimpleCov.start
end

require 'json'
require 'octokit'
require 'rspec'
require 'webmock/rspec'
require 'base64'
require 'jwt'
# latest version of pry-byebug is not compatible with Ruby 3.2.0
if Gem::Version.new(RUBY_VERSION) < Gem::Version.new('3.2.0')
  require 'pry-byebug'
end
if Gem::Version.new(Faraday::VERSION) >= Gem::Version.new('2.0')
  require 'faraday/multipart'
end

WebMock.disable_net_connect!

RSpec.configure do |config|
  config.warnings = true
  config.raise_errors_for_deprecations!
  config.before(:all) do
    @test_repo = "#{test_github_login}/#{test_github_repository}"
    @test_repo_id = test_github_repository_id
    @test_org_repo = "#{test_github_org}/#{test_github_repository}"
  end
end

require 'vcr'
VCR.configure do |c| # rubocop:disable Metrics/BlockLength
  c.configure_rspec_metadata!
  c.filter_sensitive_data('<GITHUB_LOGIN>') do
    test_github_login
  end
  c.filter_sensitive_data('<GITHUB_COLLABORATOR_LOGIN>') do
    test_github_collaborator_login
  end
  c.filter_sensitive_data('<GITHUB_TEAM_SLUG>') do
    test_github_team_slug
  end
  c.filter_sensitive_data('<GITHUB_TEAM_ID>') do
    test_github_team_id
  end
  c.filter_sensitive_data('<GITHUB_PASSWORD>') do
    test_github_password
  end
  c.filter_sensitive_data('<<ACCESS_TOKEN>>') do
    test_github_token
  end
  c.filter_sensitive_data('<<ACCESS_TOKEN>>') do
    test_github_token_two
  end
  c.filter_sensitive_data('<GITHUB_COLLABORATOR_TOKEN>') do
    test_github_collaborator_token
  end
  c.filter_sensitive_data('<GITHUB_CLIENT_ID>') do
    test_github_client_id
  end
  c.filter_sensitive_data('<GITHUB_CLIENT_SECRET>') do
    test_github_client_secret
  end
  c.filter_sensitive_data('<<ENTERPRISE_GITHUB_LOGIN>>') do
    test_github_enterprise_login
  end
  c.filter_sensitive_data('<<ENTERPRISE_ACCESS_TOKEN>>') do
    test_github_enterprise_token
  end
  c.filter_sensitive_data('<<MANAGE_GHES_ENDPOINT>>') do
    test_github_manage_ghes_endpoint
  end
  c.filter_sensitive_data('<<MANAGE_GHES_PASSWORD>>') do
    test_github_manage_ghes_password
  end
  c.filter_sensitive_data('<<ENTERPRISE_HOSTNAME>>') do
    test_github_enterprise_endpoint
  end
  c.define_cassette_placeholder('<GITHUB_TEST_REPOSITORY>') do
    test_github_repository
  end
  c.define_cassette_placeholder('<GITHUB_TEST_REPOSITORY_ID>') do
    test_github_repository_id
  end
  c.define_cassette_placeholder('<GITHUB_TEST_ORGANIZATION>') do
    test_github_org
  end
  c.define_cassette_placeholder('<GITHUB_TEST_ORG_TEAM_ID>') do
    '10050505050000'
  end
  c.define_cassette_placeholder('<GITHUB_TEST_INTEGRATION>') do
    test_github_integration
  end
  c.define_cassette_placeholder('<GITHUB_TEST_INTEGRATION_INSTALLATION>') do
    test_github_integration_installation
  end
  # This MUST belong to the app used for test_github_client_id and
  # test_github_client_secret
  c.define_cassette_placeholder('<GITHUB_TEST_OAUTH_TOKEN>') do
    test_github_oauth_token
  end

  c.before_http_request(:real?) do |request|
    next if request.headers['X-Vcr-Test-Repo-Setup']
    next unless request.uri.include? test_github_repository

    options = {
      headers: { 'X-Vcr-Test-Repo-Setup' => 'true' },
      auto_init: true
    }

    test_repo = "#{test_github_login}/#{test_github_repository}"
    unless oauth_client.repository?(test_repo, options)
      Octokit.octokit_warn "NOTICE: Creating #{test_repo} test repository."
      oauth_client.create_repository(test_github_repository, options)
    end

    test_org_repo = "#{test_github_org}/#{test_github_repository}"
    unless oauth_client.repository?(test_org_repo, options)
      Octokit.octokit_warn "NOTICE: Creating #{test_org_repo} test repository."
      options[:organization] = test_github_org
      oauth_client.create_repository(test_github_repository, options)
    end
  end

  c.ignore_request do |request|
    !!request.headers['X-Vcr-Test-Repo-Setup']
  end

  record_mode =
    if ENV['GITHUB_CI']
      :none
    elsif ENV['OCTOKIT_TEST_VCR_RECORD']
      :all
    else
      :once
    end

  c.default_cassette_options = {
    serialize_with: :json,
    # TODO: Track down UTF-8 issue and remove
    preserve_exact_body_bytes: true,
    decode_compressed_response: true,
    record: record_mode
  }
  c.cassette_library_dir = 'spec/cassettes'
  c.hook_into :webmock
end

def delete_test_repo
  oauth_client.delete_repository @test_repo
rescue Octokit::NotFound
end

def test_github_login
  ENV.fetch 'OCTOKIT_TEST_GITHUB_LOGIN', 'api-padawan'
end

def test_github_collaborator_login
  ENV.fetch 'OCTOKIT_TEST_GITHUB_COLLABORATOR_LOGIN', 'hubot'
end

def test_github_team_slug
  ENV.fetch 'OCTOKIT_TEST_GITHUB_TEAM_SLUG', 'the-a-team'
end

def test_github_team_id
  ENV.fetch 'OCTOKIT_TEST_GITHUB_TEAM_ID', 123_456
end

def test_github_password
  ENV.fetch 'OCTOKIT_TEST_GITHUB_PASSWORD', 'wow_such_password'
end

def test_github_token
  ENV.fetch 'OCTOKIT_TEST_GITHUB_TOKEN', 'x' * 40
end

def test_github_token_two
  ENV.fetch 'OCTOKIT_TEST_GITHUB_TOKEN_TWO', 'y' * 40
end

def test_github_collaborator_token
  ENV.fetch 'OCTOKIT_TEST_GITHUB_COLLABORATOR_TOKEN', 'x' * 40
end

def test_github_client_id
  ENV.fetch 'OCTOKIT_TEST_GITHUB_CLIENT_ID', 'x' * 21
end

def test_github_client_secret
  ENV.fetch 'OCTOKIT_TEST_GITHUB_CLIENT_SECRET', 'x' * 40
end

def test_github_enterprise_login
  ENV.fetch 'OCTOKIT_TEST_GITHUB_ENTERPRISE_LOGIN', 'crashoverride'
end

def test_github_enterprise_token
  ENV.fetch 'OCTOKIT_TEST_GITHUB_ENTERPRISE_TOKEN', 'x' * 40
end

def test_github_enterprise_endpoint
  ENV.fetch 'OCTOKIT_TEST_GITHUB_ENTERPRISE_ENDPOINT', 'http://enterprise.github.dev/api/v3/'
end

def test_github_manage_ghes_endpoint
  ENV.fetch 'OCTOKIT_TEST_GITHUB_MANAGE_GHES_ENDPOINT', 'http://enterprise.github.dev:8443'
end

def test_github_manage_ghes_username
  ENV.fetch 'OCTOKIT_TEST_GITHUB_MANAGE_GHES_USERNAME', 'api_key'
end

def test_github_manage_ghes_password
  ENV.fetch 'OCTOKIT_TEST_GITHUB_MANAGE_GHES_PASSWORD', 'passworD1'
end

def test_github_repository
  ENV.fetch 'OCTOKIT_TEST_GITHUB_REPOSITORY', 'api-sandbox'
end

def test_github_repository_id
  ENV.fetch('OCTOKIT_TEST_GITHUB_REPOSITORY_ID', 20_974_780).to_i
end

def test_github_org
  ENV.fetch 'OCTOKIT_TEST_GITHUB_ORGANIZATION', 'api-playground'
end

def test_github_integration
  ENV.fetch('OCTOKIT_TEST_GITHUB_INTEGRATION', 76_765).to_i
end

def test_github_integration_installation
  ENV.fetch('OCTOKIT_TEST_GITHUB_INTEGRATION_INSTALLATION', 898_507).to_i
end

def test_github_integration_pem_key
  ENV.fetch 'OCTOKIT_TEST_INTEGRATION_PEM_KEY', "#{fixture_path}/fake_integration.private-key.pem"
end

def test_github_oauth_token
  ENV.fetch 'OCTOKIT_TEST_GITHUB_OAUTH_TOKEN', 'q' * 40
end

def stub_delete(url)
  stub_request(:delete, github_url(url))
end

def stub_get(url)
  stub_request(:get, github_url(url))
end

def stub_head(url)
  stub_request(:head, github_url(url))
end

def stub_patch(url)
  stub_request(:patch, github_url(url))
end

def stub_post(url)
  stub_request(:post, github_url(url))
end

def stub_put(url)
  stub_request(:put, github_url(url))
end

def fixture_path
  File.expand_path('fixtures', __dir__)
end

def fixture(file)
  File.new("#{fixture_path}/#{file}")
end

def json_response(file)
  {
    body: fixture(file),
    headers: {
      content_type: 'application/json; charset=utf-8'
    }
  }
end

def github_url(url)
  return url if url =~ /^http/

  url = File.join(Octokit.api_endpoint, url)
  uri = Addressable::URI.parse(url)
  uri.path.gsub!('v3//', 'v3/')

  uri.to_s
end

def github_enterprise_url(url)
  test_github_enterprise_endpoint + url
end

def github_manage_ghes_url(url)
  test_github_manage_ghes_endpoint + url
end

def basic_auth_client(login: test_github_login, password: test_github_password)
  Octokit::Client.new(login: login, password: password)
end

def oauth_client(access_token: test_github_token)
  Octokit::Client.new(access_token: access_token)
end

def enterprise_admin_client
  stack = Faraday::RackBuilder.new do |builder|
    builder.request :multipart
    builder.request :url_encoded
    builder.adapter Faraday.default_adapter
  end

  client = Octokit::EnterpriseAdminClient.new \
    access_token: test_github_enterprise_token,
    connection_options: { ssl: { verify: false } }

  client.configure do |c|
    c.api_endpoint = test_github_enterprise_endpoint
    c.middleware = stack
  end
  client
end

def http_cache_middleware_store
  @http_cache_middleware_store ||= Faraday::HttpCache::MemoryStore.new
end

def oauth_client_with_http_cache_middleware(access_token: test_github_token)
  stack = Faraday::RackBuilder.new do |builder|
    builder.use Faraday::HttpCache, serializer: Marshal, store: http_cache_middleware_store, shared_cache: false
    builder.adapter Faraday.default_adapter
  end

  client = oauth_client(access_token: access_token)

  client.configure do |c|
    c.middleware = stack
  end
  client
end

def manage_ghes_client
  stack = Faraday::RackBuilder.new do |builder|
    builder.request :multipart
    builder.request :url_encoded
    builder.adapter Faraday.default_adapter
  end

  client = Octokit::ManageGHESClient.new \
    manage_ghes_endpoint: test_github_manage_ghes_endpoint,
    manage_ghes_username: test_github_manage_ghes_username,
    manage_ghes_password: test_github_manage_ghes_password,
    connection_options: { ssl: { verify: false } }

  client.configure do |c|
    c.middleware = stack
  end
  client
end

def new_jwt_token
  private_pem = File.read(test_github_integration_pem_key)
  private_key = OpenSSL::PKey::RSA.new(private_pem)

  payload = {}.tap do |opts|
    opts[:iat] = Time.now.to_i           # Issued at time.
    opts[:exp] = opts[:iat] + 600        # JWT expiration time is 10 minutes from issued time.
    opts[:iss] = test_github_integration # Integration's GitHub identifier.
  end

  JWT.encode(payload, private_key, 'RS256')
end

def use_vcr_placeholder_for(text, replacement)
  VCR.configure do |c|
    c.define_cassette_placeholder(replacement) do
      text
    end
  end
end
