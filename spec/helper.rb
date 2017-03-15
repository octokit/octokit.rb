if RUBY_ENGINE == 'ruby'
  require 'simplecov'
  require 'coveralls'

  SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter.new [
    SimpleCov::Formatter::HTMLFormatter,
    Coveralls::SimpleCov::Formatter
  ]
  SimpleCov.start
end

require 'json'
require 'octokit'
require 'rspec'
require 'webmock/rspec'
require 'base64'
require 'jwt'

WebMock.disable_net_connect!(:allow => 'coveralls.io')

RSpec.configure do |config|
  config.raise_errors_for_deprecations!
  config.before(:all) do
    @test_repo = "#{test_github_login}/#{test_github_repository}"
    @test_repo_id = test_github_repository_id
    @test_org_repo = "#{test_github_org}/#{test_github_repository}"
  end
end

require 'vcr'
VCR.configure do |c|
  c.configure_rspec_metadata!
  c.filter_sensitive_data("<GITHUB_LOGIN>") do
    test_github_login
  end
  c.filter_sensitive_data("<GITHUB_PASSWORD>") do
    test_github_password
  end
  c.filter_sensitive_data("<<ACCESS_TOKEN>>") do
    test_github_token
  end
  c.filter_sensitive_data("<GITHUB_CLIENT_ID>") do
    test_github_client_id
  end
  c.filter_sensitive_data("<GITHUB_CLIENT_SECRET>") do
    test_github_client_secret
  end
  c.filter_sensitive_data("<<ENTERPRISE_GITHUB_LOGIN>>") do
    test_github_enterprise_login
  end
  c.filter_sensitive_data("<<ENTERPRISE_ACCESS_TOKEN>>") do
    test_github_enterprise_token
  end
  c.filter_sensitive_data("<<ENTERPRISE_MANAGEMENT_CONSOLE_PASSWORD>>") do
    test_github_enterprise_management_console_password
  end
  c.filter_sensitive_data("<<ENTERPRISE_MANAGEMENT_CONSOLE_ENDPOINT>>") do
    test_github_enterprise_management_console_endpoint
  end
  c.filter_sensitive_data("<<ENTERPRISE_HOSTNAME>>") do
    test_github_enterprise_endpoint
  end
  c.define_cassette_placeholder("<GITHUB_TEST_REPOSITORY>") do
    test_github_repository
  end
  c.define_cassette_placeholder("<GITHUB_TEST_ORGANIZATION>") do
    test_github_org
  end
  c.define_cassette_placeholder("<GITHUB_TEST_ORG_TEAM_ID>") do
    "10050505050000"
  end
  c.define_cassette_placeholder("<GITHUB_TEST_INTEGRATION>") do
    test_github_integration
  end
  c.define_cassette_placeholder("<GITHUB_TEST_INTEGRATION_INSTALLATION>") do
    test_github_integration_installation
  end

  c.before_http_request(:real?) do |request|
    next if request.headers['X-Vcr-Test-Repo-Setup']
    next unless request.uri.include? test_github_repository

    options = {
      :headers => {'X-Vcr-Test-Repo-Setup' => 'true'},
      :auto_init => true
    }

    test_repo = "#{test_github_login}/#{test_github_repository}"
    if !oauth_client.repository?(test_repo, options)
      Octokit.octokit_warn "NOTICE: Creating #{test_repo} test repository."
      oauth_client.create_repository(test_github_repository, options)
    end

    test_org_repo = "#{test_github_org}/#{test_github_repository}"
    if !oauth_client.repository?(test_org_repo, options)
      Octokit.octokit_warn "NOTICE: Creating #{test_org_repo} test repository."
      options[:organization] = test_github_org
      oauth_client.create_repository(test_github_repository, options)
    end
  end

  c.ignore_request do |request|
    !!request.headers['X-Vcr-Test-Repo-Setup']
  end

  c.default_cassette_options = {
    :serialize_with             => :json,
    # TODO: Track down UTF-8 issue and remove
    :preserve_exact_body_bytes  => true,
    :decode_compressed_response => true,
    :record                     => ENV['TRAVIS'] ? :none : :once
  }
  c.cassette_library_dir = 'spec/cassettes'
  c.hook_into :webmock
end

def delete_test_repo
  begin
    oauth_client.delete_repository @test_repo
  rescue Octokit::NotFound
  end
end

def test_github_login
  ENV.fetch 'OCTOKIT_TEST_GITHUB_LOGIN', 'api-padawan'
end

def test_github_password
  ENV.fetch 'OCTOKIT_TEST_GITHUB_PASSWORD', 'wow_such_password'
end

def test_github_token
  ENV.fetch 'OCTOKIT_TEST_GITHUB_TOKEN', 'x' * 40
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

def test_github_enterprise_management_console_password
  ENV.fetch 'OCTOKIT_TEST_GITHUB_ENTERPRISE_MANAGEMENT_CONSOLE_PASSWORD', 'Secretpa55'
end

def test_github_enterprise_management_console_endpoint
  ENV.fetch 'OCTOKIT_TEST_GITHUB_ENTERPRISE_MANAGEMENT_CONSOLE_ENDPOINT', 'https://enterprise.github.dev:8443/'
end

def test_github_enterprise_endpoint
  ENV.fetch 'OCTOKIT_TEST_GITHUB_ENTERPRISE_ENDPOINT', 'http://enterprise.github.dev/api/v3/'
end

def test_github_repository
  ENV.fetch 'OCTOKIT_TEST_GITHUB_REPOSITORY', 'api-sandbox'
end

def test_github_repository_id
  ENV.fetch 'OCTOKIT_TEST_GITHUB_REPOSITORY_ID', 20_974_780
end

def test_github_org
  ENV.fetch 'OCTOKIT_TEST_GITHUB_ORGANIZATION', 'api-playground'
end

def test_github_integration
  ENV.fetch 'OCTOKIT_TEST_GITHUB_INTEGRATION', 42
end

def test_github_integration_installation
  ENV.fetch 'OCTOKIT_TEST_GITHUB_INTEGRATION_INSTALLATION', 37
end

def test_github_integration_pem_key
  ENV.fetch 'OCTOKIT_TEST_INTEGRATION_PEM_KEY', "#{fixture_path}/fake_integration.private-key.pem"
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
  File.expand_path("../fixtures", __FILE__)
end

def fixture(file)
  File.new(fixture_path + '/' + file)
end

def json_response(file)
  {
    :body => fixture(file),
    :headers => {
      :content_type => 'application/json; charset=utf-8'
    }
  }
end

def github_url(url)
  return url if url =~ /^http/

  url = File.join(Octokit.api_endpoint, url)
  uri = Addressable::URI.parse(url)
  uri.path.gsub!("v3//", "v3/")

  uri.to_s
end

def github_enterprise_url(url)
  test_github_enterprise_endpoint + url
end

def github_management_console_url(url)
  test_github_enterprise_management_console_endpoint + url
end

def basic_github_url(path, options = {})
  url = File.join(Octokit.api_endpoint, path)
  uri = Addressable::URI.parse(url)
  uri.path.gsub!("v3//", "v3/")

  uri.user = options.fetch(:login, test_github_login)
  uri.password = options.fetch(:password, test_github_password)

  uri.to_s
end

def basic_auth_client(login = test_github_login, password = test_github_password )
  client = Octokit.client
  client.login = test_github_login
  client.password = test_github_password

  client
end

def oauth_client
  Octokit::Client.new(:access_token => test_github_token)
end

def enterprise_admin_client
  stack = Faraday::RackBuilder.new do |builder|
    builder.request :multipart
    builder.request :url_encoded
    builder.adapter Faraday.default_adapter
  end

  client = Octokit::EnterpriseAdminClient.new \
    :access_token => test_github_enterprise_token,
    :connection_options => { :ssl => { :verify => false } }

  client.configure do |c|
    c.api_endpoint = test_github_enterprise_endpoint
    c.middleware = stack
  end
  client
end

def enterprise_management_console_client
  stack = Faraday::RackBuilder.new do |builder|
    builder.request :multipart
    builder.request :url_encoded
    builder.adapter Faraday.default_adapter
  end

  client = Octokit::EnterpriseManagementConsoleClient.new \
    :management_console_endpoint => test_github_enterprise_management_console_endpoint,
    :management_console_password => test_github_enterprise_management_console_password,
    :connection_options => { :ssl => { :verify => false } }

  client.configure do |c|
    c.middleware = stack
  end
  client
end

def use_vcr_placeholder_for(text, replacement)
  VCR.configure do |c|
    c.define_cassette_placeholder(replacement) do
      text
    end
  end
end
